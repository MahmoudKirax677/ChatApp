import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:zefaf/App/Coin/PurchaseScreen.dart';
import 'package:zefaf/help/loadingClass.dart';
import 'package:zefaf/services/binding/PackageBinding.dart';
import 'package:zefaf/services/purchase_controller.dart';

class WebViewScreen extends StatefulWidget {
  final String link;

  const WebViewScreen({Key? key, required this.link}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  final PurchaseController purchaseController = Get.put(PurchaseController());
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkForSuccess(
                url); // Check for success page after page finishes loading
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }

  Future<void> _checkForSuccess(String url) async {
    _controller
        .runJavaScriptReturningResult("document.body.innerText")
        .then((emailObject) {
      // تحويل نتيجة JavaScript إلى String
      String pageContent = emailObject.toString();

      // التحقق من وجود success505 في النص
      if (pageContent.contains('Success505')) {
        print('Success505 found in the content');

        // البحث عن البريد الإلكتروني داخل النص
        String emailPattern =
            r'[\w\.-]+@[\w\.-]+\.\w+'; // نمط للتعرف على البريد الإلكتروني
        RegExp regExp = RegExp(emailPattern);
        String? email = regExp.stringMatch(pageContent);

        // التأكد من استخراج البريد الإلكتروني بنجاح
        if (email != null && email.isNotEmpty) {
          purchaseController.saveEmail(email);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Email extracted successfully: $email")),
          // );

          // الانتقال إلى شاشة الشراء
          Get.to(PurchaseScreen(),
              binding: PurchaseBinding(),
              duration: const Duration(milliseconds: 150));
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Failed to extract email")),
          // );
        }
      } else {
        // في حال عدم وجود success505
        print('success505 not found in the content');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Success code not found")),
        // );
      }
    }).catchError((error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error extracting content: $error")),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الدفع"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
        ],
      ),
    );
  }
}
