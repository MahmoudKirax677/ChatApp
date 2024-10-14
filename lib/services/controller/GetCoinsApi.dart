import 'package:dio/dio.dart';

import '../../url/url.dart';
import 'CoinsModel.dart';

class GetCoinsApi{
  Dio dio = Dio();
  Future<CoinsModel> getCoins()async{
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/package");
      if(response.statusCode == 200){
        return CoinsModel.fromJson(response.data);
      }else {
        return Future.error("error");
      }
    }on DioError catch(e){
      return Future.error("error");
    }
  }
}