import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/url/url.dart';
import '../help/hive/localStorage.dart';
import '../help/myprovider.dart';

class BuyCoinsApi{
  Future buyCoin({packageId,binNumber})async{
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    Map buyCoinsMap = {
      "package_id": packageId,
      "binNumber": binNumber
    };
    try{
      var response = await dio.request("/buy-coins",data: jsonEncode(buyCoinsMap));
      if(response.statusCode == 200){
        return response.data;
      }else {
        return Future.error("error");
      }
    }on DioError catch(e){
      return Future.error("error");
    }
  }


  Future getProfile(context)async{
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/profile");
      if(response.statusCode == 200){
        Provider.of<AppProvide>(context,listen: false).coins = int.parse(response.data["data"]["total_coins"]);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      return false;
    }
  }

}