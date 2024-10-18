import 'dart:ui';

import 'package:get/get.dart';
import 'package:zefaf/model/PackageModel.dart';
import '../model/PackageData.dart';

class PackageController extends GetxController with StateMixin<PackageModel>{

  final Color accentColor = const Color(0xffc52278);

  getPackages(){
    change(PackageModel.fromJson(packageData),status: RxStatus.success());
  }
  
  @override
  void onInit() {
    super.onInit();
    getPackages();
  }
}