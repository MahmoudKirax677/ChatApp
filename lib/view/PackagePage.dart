import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefaf/controller/PackageController.dart';
import 'package:zefaf/view/webview.dart';

class PackagePage extends GetView<PackageController> {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // تأخير التنقل إلى WebViewScreen لمدة ثانية واحدة
    Future.delayed(const Duration(seconds: 1), () {
      Get.to(() => const WebViewScreen(
            link: 'https://lialinaapp.com/',
          ));
    });

    // عرض شاشة فارغة (أو شاشة تحميل مؤقتة) أثناء التأخير
    return Scaffold(
      backgroundColor: Colors.white, // شاشة فارغة بيضاء
      body: Center(
        child:
            CircularProgressIndicator(), // مؤشر تحميل يمكن استخدامه كخيار بديل
      ),
    );
  }
}
