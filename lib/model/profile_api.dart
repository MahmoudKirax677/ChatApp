import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:provider/provider.dart';
import '../App/Search Online/SearchOnline.dart';
import '../App/mainPage/AppMainPage.dart';
import '../help/hive/localStorage.dart';
import '../help/myprovider.dart';
import '../url/url.dart';
import '../help/loadingClass.dart';


extension ProfileApi on BuildContext{

  Future editApiForLogin({editMap})async{
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
      var response = await dio.request("/update-user-profile",data: json.encode(editMap));
      if(response.statusCode == 200){
        LocalStorage().setValue("login", true);
        AlertController.show("تم", "تم تحديث البيانات بنجاح", TypeAlert.success);
        //print(response.data);
        // LocalStorage().setValue("hairColor", response.data["data"]["hairColor"]);
        // LocalStorage().setValue("eyeColor", response.data["data"]["eyeColor"]);
        // LocalStorage().setValue("financialStatus", response.data["data"]["financialStatus"]);
        // LocalStorage().setValue("socialStatus", response.data["data"]["socialStatus"]);
        // LocalStorage().setValue("birthday", response.data["data"]["birthday"]);
       // LoadingDialog().hideDialog(this);
        Navigator.push(
          this,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) {
              return const AppMainPage();
            },
            transitionsBuilder: (context, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: child,
              );
            },
            transitionDuration: const Duration(microseconds: 250),
          ),
        );
        Navigator.push(
          this,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) {
              return const SearchOnline();
            },
            transitionsBuilder: (context, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: child,
              );
            },
            transitionDuration: const Duration(microseconds: 250),
          ),
        );
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



  Future getOptionApi({from})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "GET";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request(from == 1 ? "/hair-colors" : from == 2 ? "/eye-colors" : from == 3 ? "/social-status" : "/financial-status");
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

  Future getProfile()async{
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
      var response = await dio.request("/profile");
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        Provider.of<AppProvide>(this,listen: false).coins = int.parse(response.data["data"]["total_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).audio = int.parse(response.data["data"]["audio_coins"].toString());
        Provider.of<AppProvide>(this,listen: false).video = int.parse(response.data["data"]["video_coins"].toString());
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


  Future editApiForProfile({editMap})async{
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
      var response = await dio.request("/update-user-profile",data: json.encode(editMap));
      if(response.statusCode == 200){
        AlertController.show("تم", "تم تحديث البيانات بنجاح", TypeAlert.success);
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


  Future editProfileImage({imagePath})async{
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
    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        imagePath,
        filename: "image.jpg",
      )
    });
    try{
      var response = await dio.request("/update-user-profile",data: data);
      if(response.statusCode == 200){
        AlertController.show("تم", "تم تحديث البيانات بنجاح", TypeAlert.success);
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


  }


