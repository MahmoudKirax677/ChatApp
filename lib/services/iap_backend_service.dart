import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import '../help/loadingClass2.dart';
import '../model/BuyCoinsApi.dart';
import 'iap_backend_config.dart';
import 'iap_service.dart';
import 'server_response.dart';
import 'package:googleapis/androidpublisher/v3.dart' as ap;
import 'package:googleapis/pubsub/v1.dart' as pubsub;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../help/globals.dart' as globals;

class IAPBackendService {
  late Dio dio;

  IAPBackendService() {
    dio = Dio(BaseOptions(headers: {
      'Accept': 'application/json',
      'content-type': 'application/json',
    }));

    if (kDebugMode) {
      dio.interceptors
          .add(LogInterceptor(responseBody: true, responseHeader: true));
    }
  }

  Future<ServerResponse> validatePurchase(Map data) async {
    final type = data['type'];
    final jsonData = data['data'];

    if (type == 'android') {
      final productId = jsonData['product_id'];
      final purchaseToken = jsonData['purchase_token'];

      final response = await googleVerifyPurchase(productId, purchaseToken);
      await prepareVerifyResponseAndUpdateProfile(response);
      return response;
    }

    if (type == 'ios') {
      final response = await iosVerifyPurchase(jsonDecode(jsonData));
      await prepareVerifyResponseAndUpdateProfile(response);
      return response;
    }

    return ServerResponse(success: false);
  }

  Future<ServerResponse> googleVerifyPurchase(productID, purchaseToken) async {
    final serviceAccountGooglePlay =
    await rootBundle.loadString(GoogleConfigArray.service_account_path);
    final clientCredentialsGooglePlay =
    auth.ServiceAccountCredentials.fromJson(serviceAccountGooglePlay);
    //
    final clientGooglePlay =
    await auth.clientViaServiceAccount(clientCredentialsGooglePlay, [
      ap.AndroidPublisherApi.androidpublisherScope,
      pubsub.PubsubApi.cloudPlatformScope,
    ]);
    final androidPublisher = ap.AndroidPublisherApi(clientGooglePlay);

    final response = await androidPublisher.purchases.products.get(
      GoogleConfigArray.app_id,
      productID,
      purchaseToken,
    );

    // 0. Yet to be acknowledged
    // 1. Acknowledged
  //  debugPrint('acknowledged: ${response.acknowledgementState}');

  //  debugPrint('Purchases response: ${response.toJson()}');

    final purchaseStateCode = response.purchaseState ?? 0;
    final state = purchaseStateCode > 2
        ? 'unknown'
        : NonSubscriptionStatus.values[response.purchaseState ?? 0].name;

  //  debugPrint('Purchases state: $state');

    if (response.orderId == null) {
      // Make sure an order id exists
      return ServerResponse(
          success: false,
          message: 'Could not handle purchase without order id');
    } else if (state == 'pending') {
      //all ok
      return ServerResponse(success: true, data: response.toJson());
    } else {
      return ServerResponse(success: false, message: 'failed , state $state');
    }
  }

  Future<ServerResponse> iosVerifyPurchase(receipts, [isSandbox = true]) async {
    late Map responseData;
    late int responseStatus;

    final receiptObject = generateIosReceiptObject(receipts);

    if (isSandbox) {
      final sandboxResponse =
      await postData(IosConfigArray.sandboxEndpoint, data: receiptObject);
      responseData = sandboxResponse.data;
      isSandbox = responseData['environment'] == "Sandbox";
      responseStatus = sandboxResponse.data['status'];
    }

    if (!isSandbox) {
      final productionResponse = await postData(
          IosConfigArray.productionEndpoint,
          data: receiptObject);
      responseData = productionResponse.data;
      responseStatus = productionResponse.data['status'];
    }

    if (responseStatus == 0) {
      final latestReceiptInfo = responseData['latest_receipt_info'];
     // debugPrint('Purchases response: ${latestReceiptInfo}');

      if (latestReceiptInfo != null && latestReceiptInfo[0] != null) {
        return ServerResponse(
            success: true, data: responseData['latest_receipt_info'][0]);
      } else {
        return ServerResponse(
            success: true, data: responseData['receipt']['in_app'][0]);
      }
    }
    return ServerResponse(
        success: false, data: responseData, statusCode: responseStatus);
  }

  Future prepareVerifyResponseAndUpdateProfile(ServerResponse _response) async {
    if (_response.success) {
      LoadingDialog2().showDialogBox();
      BuyCoinsApi().buyCoin(
        packageId: globals.coinsId,
        binNumber: _response.data["orderId"]
      ).then((value)async{
        await FlutterRingtonePlayer.play(fromAsset: "assets/pay.mp3", looping: false, asAlarm: false,volume: 0.05);
        showMsg('تم الشراء بنجاح شكرا لك');
        // print('***--**-*--**-*-*-*-*-*-*-*-*-*--*-*--+*+*-*-*-*-*-*-*');
        // print(jsonEncode(_response.data));
        // print(_response.data["orderId"]);
        // print('***--**-*--**-*-*-*-*-*-*-*--+*+*-*-*--*-*-*-*-*-*-*-*');
        LoadingDialog2().hideDialog();
        BuyCoinsApi().getProfile(globals.appContext);
      },onError: (e){
        LoadingDialog2().hideDialog();
      });
    }
  }

  String generateIosReceiptObject(receipts) {
    final receipt = receipts is List ? receipts.first : receipts;
    return jsonEncode({
      'receipt-data': receipt['appStoreReceipt'],
      'password': IosConfigArray.password,
    });
  }

  ///////////////////////

  Future<ServerResponse> postData(String route, {data, queryData}) async {
    final response =
    await dio.post(route, data: data, queryParameters: queryData);
    dynamic fetchedData = response.data;

    return ServerResponse(
      success: response.statusCode == 200,
      data: fetchedData,
      statusCode: response.statusCode,
    );
  }

  Future<ServerResponse> getData(String route, {data}) async {
    final response = await dio.get(route, queryParameters: data);
    dynamic fetchedData = response.data;

    return ServerResponse(
      success: response.statusCode == 200,
      data: fetchedData,
      statusCode: response.statusCode,
    );
  }
}

enum NonSubscriptionStatus {
  pending,
  completed,
  cancelled,
}
