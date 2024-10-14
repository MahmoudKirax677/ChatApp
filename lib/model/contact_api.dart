import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zefaf/auth/pinCode.dart';
import '../View/mainPage/AppMainPage.dart';
import '../help/hive/localStorage.dart';
import '../url/url.dart';
import '../help/loadingClass.dart';


extension Contact on BuildContext{

  Future contactApi({contactMap})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${LocalStorage().getValue("token")}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/contact-us",data: json.encode(contactMap));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        AlertController.show("تم", "تم إرسال رسالتك إلى إدارة التطبيق وسيتم الرد عليك في أقصر وقت", TypeAlert.success);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية الارسال !", TypeAlert.warning);
      return false;
    }
  }


  }


