import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  late WebViewController _controller;
  final PurchaseController purchaseController = Get.put(PurchaseController());
  bool isLoading = true;
  bool showLoadingForFiveSeconds = true; // Control minimum loading time

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
          onWebResourceError: (WebResourceError error) {
            print('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('onNavigationRequest');
            //I first had this line to prevent redirection to anywhere on the internet via hrefs
            //but this prevented ANYTHING from being displayed
            // return NavigationDecision.prevent;

            return NavigationDecision
                .navigate; //changed it to this, and it works now
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showLoadingForFiveSeconds = false; // Disable after 5 seconds
      });
    });
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
        body: Stack(
      children: [
        SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
        if (isLoading ||
            showLoadingForFiveSeconds) // Show loading if page is loading or during the first 5 seconds
          Center(
              child: sp.SpinKitCircle(
            size: 50.0,
            color: Colors.red,
          )),
      ],
    ));
  }
}
