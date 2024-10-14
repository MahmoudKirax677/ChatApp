import 'dart:core';
import 'package:zefaf/services/server_response.dart';
import 'package:zefaf/services/service_locator.dart';
import 'iap_backend_service.dart';


class IapApiRepo{
  Future<ServerResponse> verifyPurchase(Map<String, dynamic> map)async{
    final purchaseResponse = await locator<IAPBackendService>().validatePurchase(map);
    if(purchaseResponse.success){
      return ServerResponse(success: true,message: "تم بنجاح ",data: purchaseResponse.data);
    }else{
      return ServerResponse(success: false, message: purchaseResponse.message ?? 'purchase Failed.',data: purchaseResponse.data,statusCode: purchaseResponse.statusCode);
    }
  }
}
