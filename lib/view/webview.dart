import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart'; // Add Sentry import
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
  WebViewController? _controller;
  bool isLoading = true;
  String linkUrl = 'https://weareoryx.com/about-us';

  @override
  void initState() {
    super.initState();

    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = false;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
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
      ..loadRequest(Uri.parse(linkUrl));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller!),
        ],
      ),
    );
  }
}
