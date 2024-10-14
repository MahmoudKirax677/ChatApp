import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zefaf/View/mainPage/pages/profilePage/ProfileMainPage.dart';
import 'package:zefaf/View/mainPage/pages/profilePage/ProfileMainPageLogin.dart';
import 'package:zefaf/auth/pinCode.dart';
import 'package:zefaf/help/GetStorage.dart';
import '../View/Search Online/SearchOnline.dart';
import '../View/mainPage/AppMainPage.dart';
import '../help/hive/localStorage.dart';
import '../url/url.dart';
import '../help/loadingClass.dart';


extension LoginApi on BuildContext{

  Future loginApi({loginMap})async{
    LocalStorage().setValue("hairColor", null);
    LocalStorage().setValue("eyeColor", null);
    LocalStorage().setValue("financialStatus", null);
    LocalStorage().setValue("socialStatus", null);
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/login",data: json.encode(loginMap));
      if(response.statusCode == 200){
       // LoadingDialog().hideDialog(this);
        if(response.data["data"]["userVerify"]){
          //LocalStorage().setValue("login", true);
         // print(response.data["data"]);
          LocalStorage().setValue("token", response.data["access_token"]);
          LocalStorage().setValue("userID", response.data["data"]["id"]);
          LocalStorage().setValue("phone_number", response.data["data"]["mobile"]);
          LocalStorage().setValue("name", response.data["data"]["name"]);
          LocalStorage().setValue("image", response.data["data"]["images"]);
          LocalStorage().setValue("countryName", response.data["data"]["countryName"]);
          LocalStorage().setValue("trusted", response.data["data"]["trusted"]);
          LocalStorage().setValue("total_coins", response.data["data"]["total_coins"]);
          LocalStorage().setValue("gender", response.data["data"]["gender"]);
          if(response.data["data"]["hairColor"] == ""){
            AlertController.show("الملف الشخصي", "يرجى اكمال الملف الشخصي", TypeAlert.warning);
            /// Profile Page
            Navigator.push(
              this,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) {
                  return const ProfileMainPageLogin();
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
          }else{
            LocalStorage().setValue("login", true);
           // AlertController.show("تم", "تم تسجيل الدخول بنجاح", TypeAlert.success);
            LocalStorage().setValue("hairColor", response.data["data"]["hairColor"]);
            LocalStorage().setValue("eyeColor", response.data["data"]["eyeColor"]);
            LocalStorage().setValue("financialStatus", response.data["data"]["financialStatus"]);
            LocalStorage().setValue("socialStatus", response.data["data"]["socialStatus"]);
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
          }
        }else{
         // Get.snackbar("OTP","${response.data["data"]["otp"]}",duration: const Duration(seconds: 20));
          AlertController.show("تم", "يرجى تفعيل الحساب", TypeAlert.success);
          Navigator.push(
            this,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) {
                return PinCode(phone: response.data["data"]["mobile"],token: response.data["access_token"],);
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
        }
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
    //  print(e.response);
    //  print('------------------------------------------------');
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية التسجيل !", TypeAlert.warning);
      return false;
    }
  }



  Future getIso({phoneNumber,firebaseToken})async{
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
      var response = await dio.request("/countries");
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ يرجة المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }

  Future deleteUser()async{
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
      var response = await dio.request("/delete-account");
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        return true;
      }else {
        AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
      return false;
    }
  }

  Future registerApi({registerMap})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/register",data: json.encode(registerMap));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        AlertController.show("تم", "تم التسجيل بنجاح , يرجى تفعيل الحساب", TypeAlert.success);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "${e.response?.data["message"]}", TypeAlert.warning);
      return false;
    }
  }


  Future pinApi({pinMap})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${pinMap["token"]}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    Map any = {
      "code" : pinMap["code"]
    };
    try{
      var response = await dio.request("/confirm-account",data: json.encode(any));
      if(response.statusCode == 200){
       // print(response.data["data"]);
        if(response.data["data"]["userVerify"]){
          //LocalStorage().setValue("login", true);
          LocalStorage().setValue("token", pinMap["token"]);
          LocalStorage().setValue("userID", response.data["data"]["id"]);
          LocalStorage().setValue("phone_number", response.data["data"]["mobile"]);
          LocalStorage().setValue("name", response.data["data"]["name"]);
          LocalStorage().setValue("image", response.data["data"]["images"]);
          LocalStorage().setValue("countryName", response.data["data"]["countryName"]);
          LocalStorage().setValue("trusted", response.data["data"]["trusted"]);
          LocalStorage().setValue("total_coins", response.data["data"]["total_coins"]);
          LocalStorage().setValue("gender", response.data["data"]["gender"]);
          if(response.data["data"]["hairColor"] == ""){
            LoadingDialog().hideDialog(this);
            AlertController.show("الملف الشخصي", "يرجى اكمال الملف الشخصي", TypeAlert.warning);
            /// Profile Page
            Navigator.push(
              this,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) {
                  return const ProfileMainPageLogin();
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
          }else{
            LocalStorage().setValue("login", true);
            AlertController.show("تم", "تم تسجيل الدخول بنجاح", TypeAlert.success);
            LocalStorage().setValue("hairColor", response.data["data"]["hairColor"]);
            LocalStorage().setValue("eyeColor", response.data["data"]["eyeColor"]);
            LocalStorage().setValue("financialStatus", response.data["data"]["financialStatus"]);
            LocalStorage().setValue("socialStatus", response.data["data"]["socialStatus"]);
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
          }
        }else{
          LoadingDialog().hideDialog(this);
          Get.snackbar("OTP","${response.data["data"]["otp"]}",duration: const Duration(seconds: 10));
          AlertController.show("تم", "يرجى تفعيل الحساب", TypeAlert.success);
          Navigator.push(
            this,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) {
                return PinCode(phone: response.data["data"]["mobile"],token: response.data["access_token"],);
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
        }
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
     // print(e.response);
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية التحقق !", TypeAlert.warning);
      return false;
    }
  }





  /// Forget Password
  Future forgetPasswordPhoneNumber({data})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
   // print(json.encode(data));
    try{
      var response = await dio.request("/forgetPassword",data: json.encode(data));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        AlertController.show("تم", "تم ارسال الرمز الى\n ${data["mobile"]}", TypeAlert.success);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية التحقق !", TypeAlert.warning);
      return false;
    }
  }



  Future pinApiForForget({pinMap})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${pinMap["token"]}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/confirmPasswordCode",data: json.encode({
        "code":pinMap["code"]
      }));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        AlertController.show("تم", "تم التحقق بنجاح", TypeAlert.success);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية التحقق !", TypeAlert.warning);
      return false;
    }
  }



  Future newPassword({passwordMap})async{
  //  print(passwordMap);
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.headers["authorization"] = "Bearer ${passwordMap["token"]}";
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/updatePassword",data: json.encode({
        "password":passwordMap["password"]
      }));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        AlertController.show("تم", "تم تغيير الرمز بنجاح", TypeAlert.success);
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
     // print(e.response);
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "حدث خطأ اثناء عملية التغيير !", TypeAlert.warning);
      return false;
    }
  }





  Future fastRegisterApi({registerMap})async{
    LoadingDialog().showDialogBox(this);
    Dio dio = Dio();
    dio.options.baseUrl = Url.api_url;
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.method = "POST";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.responseType = ResponseType.json;
    try{
      var response = await dio.request("/registerwithName",data: json.encode(registerMap));
      if(response.statusCode == 200){
        LoadingDialog().hideDialog(this);
        LocalStorage().setValue("token", response.data["access_token"]);
        LocalStorage().setValue("userID", response.data["data"]["id"]);
        LocalStorage().setValue("phone_number", response.data["data"]["mobile"]);
        LocalStorage().setValue("name", response.data["data"]["name"]);
        LocalStorage().setValue("image", response.data["data"]["images"]);
        LocalStorage().setValue("countryName", response.data["data"]["countryName"]);
        LocalStorage().setValue("trusted", response.data["data"]["trusted"]);
        LocalStorage().setValue("total_coins", response.data["data"]["total_coins"]);
        LocalStorage().setValue("gender", response.data["data"]["gender"]);
        LocalStorage().setValue("login", true);
        box.write('login', true);
        box.write('loginBtn', true);
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
        return response.data;
      }else {
        return false;
      }
    }on DioError catch(e){
      LoadingDialog().hideDialog(this);
      AlertController.show("خطأ", "${e.response?.data["message"]}", TypeAlert.warning);
      return false;
    }
  }

  //box.read('login');


  }


