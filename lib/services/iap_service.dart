import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:zefaf/services/server_response.dart';
import 'iap_api_repo.dart';

const Set<String> _kIds = {
  "50_coins",
  "100_coins",
  "200_coins",
};

class IAPService {
  ValueNotifier<String?> currentStatus = ValueNotifier<String?>(null);
  ValueNotifier<bool> purchasePending = ValueNotifier<bool>(false);
  ValueNotifier<List<String>> consumables = ValueNotifier<List<String>>([]);

  final bool _kAutoConsume = Platform.isIOS || true;

  String get getCurrentUser => 'default';

  void updateStatus(String value) {
    currentStatus.value = value;
  }

  bool isInitialized = false;

  final InAppPurchase iap = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> products = [];

  Completer<bool>? onPurchased;

  Future restorePurchase() {
    return iap.restorePurchases();
  }

  Future dispose() async {
    await _subscription.cancel();
    isInitialized = false;
    if (Platform.isIOS) {
      var iosPlatformAddition =
      iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }

    updateStatus('disposed');
  }

  Future init() async {
    initCurrentUser();

    if (!isInitialized) {
      isInitialized = true;
      final Stream<List<PurchaseDetails>> purchaseUpdated = iap.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _onPurchaseUpdate(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
        updateStatus('done');
      }, onError: (error) {
        showMsg('فشلت العملية');
        updateStatus('error');
      });
      await initStoreInfo();
    }
  }

  ProductDetails productDetailsFromProductId(String kId) {
    return products.firstWhere((e) => e.id == kId);
  }

  Future<bool> onPurchase(String kId) async {
    updateStatus('بانتظار التأكيد');
    await clearTransactionsIos();
    final productDetails = productDetailsFromProductId(kId);
    final purchaseParam = PurchaseParam(
        productDetails: productDetails, applicationUserName: getCurrentUser);
    try {
      await iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        showMsg('يوجد اشتراك مسبقا بنفس المعلومات يرجى المحاولة لاحقاً');
        //  await locator<IAPService>().tryFixLastPurchase();
      }
    }
    onPurchased = Completer<bool>();
    return onPurchased!.future;
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await iap.isAvailable();
    if (isAvailable) {
      final response = await iap.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        showMsg('بعض المنتجات غير متوفرة');
      }
      products = response.productDetails;
      for (ProductDetails product in products) {
        //debugPrint('${product.title}: ${product.description} (cost is ${product.price})');
      }

      if (Platform.isIOS) {
        var iosPlatformAddition =
        iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
    } else {
      showMsg('غير متاح في الوقت الحالي');
    }
  }

  Future<ServerResponse> _verifyPurchase(
      PurchaseDetails purchaseDetails) async {
    final iapApiRepo = IapApiRepo();

    if (Platform.isIOS) {
      final param = {
        'type': 'ios',
        'data': jsonEncode({
          'type': 'ios-appstore',
          'id': purchaseDetails.purchaseID,
          'appStoreReceipt':
          purchaseDetails.verificationData.serverVerificationData,
          'transactionReceipt':
          purchaseDetails.verificationData.localVerificationData,
        }),
      };
      final result = await iapApiRepo.verifyPurchase(param);

      return result;
    }
    if (Platform.isAndroid) {
      final encodedVerificationData =
          purchaseDetails.verificationData.localVerificationData;
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

      final result = await iapApiRepo.verifyPurchase(param);

      return result;
    }

    throw Exception('unsupported platform');
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    if (Platform.isIOS) {
      for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          isPending();
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            updateStatus('خطأ');

            handleError(purchaseDetails.error!);
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            final valid = await _handlePurchase(purchaseDetails);
            if (valid) {
              //ok
              deliverProduct(purchaseDetails);
            } else {
              _handleInvalidPurchase(purchaseDetails);

              return;
            }
          }
          if (purchaseDetails.status == PurchaseStatus.canceled) {

          }

          if (purchaseDetails.pendingCompletePurchase) {
            await iap.completePurchase(purchaseDetails);
          }
        }
      }
    }
    if (Platform.isAndroid) {
      updateStatus('بانتظار التأكيد');

      for (var purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          isPending();
        } else {
          final valid = await _handlePurchase(purchaseDetails);
          if (valid) {
            //ok
            deliverProduct(purchaseDetails);
          } else {
            return;
          }

          if (purchaseDetails.status == PurchaseStatus.canceled) {

          }

          if (!_kAutoConsume) {
            final InAppPurchaseAndroidPlatformAddition androidAddition = iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await iap.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }

  Future<bool> _handlePurchase(PurchaseDetails purchaseDetails) async {
    bool completed = false;
    try {
      if (purchaseDetails.status == PurchaseStatus.restored) {

        //   showSnackBar('تم التراجع عن شراء ' + purchaseDetails.productID);
        return false;
      }

      updateStatus('التحقق من العملية');

      // Send to server
      final validPurchaseResponse = await _verifyPurchase(
        purchaseDetails,
      );

      if (validPurchaseResponse.success) {
        // Apply changes locally

        showMsg('تم الشراء بنجاح شكرا لك');

        updateStatus('تم الشراء!');

        completed = true;
      } else {
        final msg = (validPurchaseResponse.message ?? '');

        showMsg('فشلت عملية الاشتراك اثناء التحقق من العملية$msg');

        completed = false;
      }
    } catch (e) {
      showMsg('خطأ غير متوقع عند التحقق من العملية$e');
      completed = false;
    }

    if (!(onPurchased?.isCompleted ?? false)) {
      onPurchased?.complete(completed);
    }
    return completed;
  }

  Future tryFixLastPurchase() async {
    isInitialized = false;
    await iap.restorePurchases();
    await clearTransactionsIos();
    await dispose();
    await init();
  }

  Future<void> clearTransactionsIos() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      transactions.forEach((transaction) async {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      });
    }
  }

  void handleError(IAPError iapError) {
    showMsg(iapError.message + iapError.details);
  }

  String priceDetailsFromPurchaseType(String kId) {
    final p = productDetailsFromProductId(kId);

    return p.price;
  }

  Future<void> initCurrentUser() async {
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    updateStatus('تم');


    purchasePending.value = false;
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }


  void isPending() {
    purchasePending.value = true;
    updateStatus('قيد الانتظار');
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

void showMsg(String s) {
  Fluttertoast.showToast(
    msg: s,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}