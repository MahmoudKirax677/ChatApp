import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvide with ChangeNotifier{

  int _selected = 0;
  int get selected => _selected;
  set selected(int selected){
    _selected = selected;
    notifyListeners();
  }

  String _dayInfo = "";
  String get dayInfo => _dayInfo;
  set dayInfo(String dayInfo){
    _dayInfo = dayInfo;
    notifyListeners();
  }

  List _carouselImage = [
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
    "https://ik.imagekit.io/ionicfirebaseapp/getflutter/tr:dpr-auto,tr:w-auto/2020/02/GFCarousel@2x--1--1.png",
  ];
  List get carouselImage => _carouselImage;
  set carouselImage(List carouselImage){
    _carouselImage = carouselImage;
    notifyListeners();
  }

  int _carousel = 0;
  int get carousel => _carousel;
  set carousel(int carousel){
    _carousel = carousel;
    notifyListeners();
  }


  Map _onlineMap = {};
  Map get onlineMap => _onlineMap;
  set onlineMap(Map onlineMap){
    _onlineMap = onlineMap;
    notifyListeners();
  }

  int _coins = 0;
  int get coins => _coins;
  set coins(int coins){
    _coins = coins;
    notifyListeners();
  }

  int _audio = 0;
  int get audio => _audio;
  set audio(int audio){
    _audio = audio;
    notifyListeners();
  }

  int _video = 0;
  int get video => _video;
  set video(int video){
    _video = video;
    notifyListeners();
  }


  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading){
    _loading = loading;
    notifyListeners();
  }


  bool _viewProfile = false;
  bool get viewProfile => _viewProfile;
  set viewProfile(bool loading){
    _viewProfile = loading;
    notifyListeners();
  }


  List _mainList = [];
  List get mainList => _mainList;
  set mainList(List mainList){
    _mainList = mainList;
    notifyListeners();
  }


}




