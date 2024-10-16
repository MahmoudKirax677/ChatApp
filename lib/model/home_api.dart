import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/auth/pinCode.dart';
import '../App/mainPage/AppMainPage.dart';
import '../help/hive/localStorage.dart';
import '../help/myprovider.dart';
import '../url/url.dart';
import '../help/loadingClass.dart';


extension HomeApi on BuildContext{

  Future mainApi({gender})async{
    LoadingDialog().showDialogBox(this);
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
      var response = await dio.request("/home?gender=$gender");
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }



  Future mainApi2({id})async{
   // LoadingDialog().showDialogBox(this);
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
      var response = await dio.request("/details-profile?id=$id");
      //LoadingDialog().hideDialog(this);
      if(response.statusCode == 200){
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      //LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }

  Future mainApiCall({id})async{
    LoadingDialog().showDialogBox(this);
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
      var response = await dio.request("/details-profile?id=$id");
      LoadingDialog().hideDialog(this);
      if(response.statusCode == 200){
       // Provider.of<AppProvide>(this,listen: false).coins = int.parse(response.data["data"]["total_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).audio = int.parse(response.data["data"]["audio_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).video = int.parse(response.data["data"]["video_coins"].toString());
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
     // AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }





  Future blockUser({partnerId})async{
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
    Map blockUserMap = {
      "partnerId": partnerId
    };
    try{
      var response = await dio.request("/add-remove-block",data: jsonEncode(blockUserMap));
      LoadingDialog().hideDialog(this);
      if(response.statusCode == 200){
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      return false;
    }
  }



  Future mainApiCall3({id})async{
   // LoadingDialog().showDialogBox(this);
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
      var response = await dio.request("/details-profile?id=$id");
     // LoadingDialog().hideDialog(this);
      if(response.statusCode == 200){
     //   Provider.of<AppProvide>(this,listen: false).coins = int.parse(response.data["data"]["total_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).audio = int.parse(response.data["data"]["audio_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).video = int.parse(response.data["data"]["video_coins"].toString());
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
    //  LoadingDialog().hideDialog(this);
      // AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }


  }


