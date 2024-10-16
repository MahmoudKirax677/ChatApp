import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/url/url.dart';
import '../help/hive/localStorage.dart';
import '../help/myprovider.dart';
import 'BuyCoinsApi.dart';

class CallCoinsApi{


  Future sendCoins({amount,userId})async{
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    Map sendCoinsMap = {
     'amount' : amount,
     'userId' : userId
    };
    try{
      var response = await dio.request("/send-coins",data: jsonEncode(sendCoinsMap));
      if(response.statusCode == 200){
        return true;
      }else {
        return Future.error("error");
      }
    }on DioError catch(e){
      return Future.error("error");
    }
  }


}