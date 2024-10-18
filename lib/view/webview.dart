import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zefaf/binding/PackageBinding.dart';
import 'package:zefaf/controller/purchase_controller.dart';
import 'package:zefaf/view/PurchaseScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as sp;

class WebViewScreen extends StatefulWidget {
  final String link;

  const WebViewScreen({Key? key, required this.link}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final PurchaseController purchaseController = Get.put(PurchaseController());
  InAppWebViewController? _controller;
  bool isLoading = true;
  bool showLoadingForFiveSeconds = true;

  @override
  void initState() {
    super.initState();
    
    // Disable the loading indicator after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showLoadingForFiveSeconds = false;
      });
    });
  }

  Future<void> _checkForSuccess(String url) async {
    String? pageContent = await _controller?.evaluateJavascript(source: "document.body.innerText");

    if (pageContent != null && pageContent.contains('Success505')) {
      RegExp emailPattern = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
      String? email = emailPattern.stringMatch(pageContent);

      if (email != null && email.isNotEmpty) {
        purchaseController.saveEmail(email);

        Get.to(PurchaseScreen(),
            binding: PurchaseBinding(),
            duration: const Duration(milliseconds: 150));
      }
    } else {
      print('Success505 not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.link)),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });
                await _checkForSuccess(url.toString());
              },
              onLoadError: (controller, url, code, message) {
                print("Error loading page: $message");
              },
            ),
          ),
          if (isLoading || showLoadingForFiveSeconds)
            Center(
              child: sp.SpinKitCircle(
                size: 50.0,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
