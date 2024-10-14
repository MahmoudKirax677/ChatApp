import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/services.dart';
import '../iap_api_repo.dart';
import '../server_response.dart';
import 'GetCoinsApi.dart';
import 'loadingClass.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class MyState<ProductDetails,CoinsModel>{
  ProductDetails? item1;
  CoinsModel? item2;
  MyState({this.item1,this.item2});
}

abstract class MainPageBaseController<ProductDetails,CoinsModel> extends GetxController with StateMixin<MyState<ProductDetails,CoinsModel>> ,LoadingDialog{}


class PaymentController extends MainPageBaseController{

  void showMsg(String s) {Fluttertoast.showToast(msg: s, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);}
  RxBool isInitialized = false.obs;
  final InAppPurchase iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> products = [];
  Completer<bool>? onPurchased;
  String get getCurrentUser => 'null';
  final Color accentColor = const Color(0xff9d0e5a);

   purchaseStream()async{
    if (!isInitialized.value) {
      isInitialized.value = true;
      final Stream<List<PurchaseDetails>> purchaseUpdated = iap.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _onPurchaseUpdate(purchaseDetailsList);
      },onDone: () {
        _subscription.cancel();
      },onError: (error) {});
      await getCoins();
      await getPastPurchases();
    }
  }


  /// Get Coins
  Future getCoins()async{
    showDialogBox();
    final bool isAvailable = await iap.isAvailable();
    if (isAvailable) {
      GetCoinsApi().getCoins().then((value)async{
        Set<String>? sx = {};
        for(var i = 0 ; i < value.data.length ; i++){
          sx.add(value.data[i].name.toLowerCase());
        }
        await iap.queryProductDetails(sx).then((valuex){
          hideDialog();
          products = valuex.productDetails..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
          change(MyState(item1: products,item2: value),status: RxStatus.success());
        },onError: (e){
          hideDialog();
        });
      }, onError: (e){
            hideDialog();
      });
    }
  }


  Future<void> getPastPurchases()async{
    if(defaultTargetPlatform == TargetPlatform.android){
      InAppPurchaseAndroidPlatformAddition androidAddition = InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      QueryPurchaseDetailsResponse response = await androidAddition.queryPastPurchases();
      for (var purchaseDetails in response.pastPurchases){
        // Send to server
        final validPurchaseResponse = await _verifyPurchase(purchaseDetails);
        if (validPurchaseResponse.success) {

        }
        if(purchaseDetails.pendingCompletePurchase){
          await iap.completePurchase(purchaseDetails);
        }
        await androidAddition.consumePurchase(purchaseDetails);
      }
    }
  }


  /// Get Purchase State
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList)async{
     if(GetPlatform.isIOS){
       for(final PurchaseDetails purchaseDetails in purchaseDetailsList){
         if (purchaseDetails.status == PurchaseStatus.error){
           showMsg('${purchaseDetails.error}');
         }else if(purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored){
           final valid = await _handlePurchase(purchaseDetails);
           if(valid){
           }else{
             return;
           }
         }else if(purchaseDetails.status == PurchaseStatus.canceled){
           showMsg('${purchaseDetails.error}');
         }else if(purchaseDetails.pendingCompletePurchase){
           await iap.completePurchase(purchaseDetails);
         }
       }
    }else if(GetPlatform.isAndroid) {
      for(var purchaseDetails in purchaseDetailsList){
        final valid = await _handlePurchase(purchaseDetails);
        if(valid){
        }else{
          return;
        }
        if(purchaseDetails.status == PurchaseStatus.canceled){
          showMsg('${purchaseDetails.error}');
        }
        if(purchaseDetails.pendingCompletePurchase){
          await iap.completePurchase(purchaseDetails);
        }
        final InAppPurchaseAndroidPlatformAddition androidAddition = iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchaseDetails);
      }
    }
  }




  Future<bool> _handlePurchase(PurchaseDetails purchaseDetails)async{
    bool completed = false;
    try {
      if(purchaseDetails.status == PurchaseStatus.restored){
        return false;
      }
      if(purchaseDetails.status == PurchaseStatus.pending){
        return false;
      }
      final validPurchaseResponse = await _verifyPurchase(purchaseDetails);
      if(validPurchaseResponse.success){
        completed = true;
      }else{
        final msg = (validPurchaseResponse.message ?? '');
        showMsg('فشلت عملية الشراء اثناء التحقق من العملية - $msg');
        completed = false;
      }
    }catch (e){
      showMsg('خطأ غير متوقع عند التحقق من العملية$e');
      completed = false;
    }
    hideDialog();
    return completed;
  }



  Future<ServerResponse> _verifyPurchase(PurchaseDetails purchaseDetails)async{
    if(GetPlatform.isIOS){
      final param = {
        'type': 'ios',
        'data': jsonEncode({
          'type': 'ios-appstore',
          'id': purchaseDetails.purchaseID,
          'appStoreReceipt': purchaseDetails.verificationData.serverVerificationData,
          'transactionReceipt': purchaseDetails.verificationData.localVerificationData,
        }),
      };
      final result = await IapApiRepo().verifyPurchase(param);
      return result;
    }else if(GetPlatform.isAndroid){
      final encodedVerificationData = purchaseDetails.verificationData.localVerificationData;
      if (encodedVerificationData.toString().isEmpty) {
        return ServerResponse(message: ' العملبة غير مكتملة ', success: false);
      }
      final localVerificationData = jsonDecode(encodedVerificationData);
      final param = {
        'type': 'android',
        'data': {
          'product_id': purchaseDetails.productID,
          'purchase_token': localVerificationData?['purchaseToken'],
        }
      };
      final result = await IapApiRepo().verifyPurchase(param);
      return result;
    }else{
      throw Exception('unsupported platform');
    }
  }


  Future<void> tryPurchase(ProductDetails productDetails)async{
     showDialogBox();
    try{
      final result = await onPurchase(productDetails.id);
      if(result == true){
       // print('***--**-*--**-*-*-*-*-*-*-*--+*+*-*-*--*-*-*-*-*-*-*-* ---- $result');
      }else{}
    }catch (e){
      showMsg('غير متاح في الوقت الحالي$e');
    }
  }




  Future<bool> onPurchase(String kId)async{
    await clearTransactionsIos();
    final productDetails = productDetailsFromProductId(kId);
    final purchaseParam = PurchaseParam(productDetails: productDetails, applicationUserName: getCurrentUser);
    try{
      await iap.buyConsumable(purchaseParam: purchaseParam);
    }on PlatformException catch (e){
      if(e.code == 'storekit_duplicate_product_object'){
        showMsg('يوجد اشتراك مسبقا بنفس المعلومات يرجى المحاولة لاحقاً');
      }
    }
    onPurchased = Completer<bool>();
    return onPurchased!.future;
  }


  ProductDetails productDetailsFromProductId(String kId){
    return products.firstWhere((e) => e.id == kId);
  }

  Future<void> clearTransactionsIos()async{
    if(GetPlatform.isIOS){
      final transactions = await SKPaymentQueueWrapper().transactions();
      transactions.forEach((transaction)async{
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      });
    }
  }


  @override
  void onReady() {
    super.onReady();
    purchaseStream();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

}