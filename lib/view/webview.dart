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
  final PurchaseController purchaseController = Get.put(PurchaseController());
  bool isLoading = true;
  bool showLoadingForFiveSeconds = true; // Control minimum loading time

  @override
  void initState() {
    super.initState();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Working Loading'),
        backgroundColor: Colors.red,
      ),
    );
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
            debugPrint('Page finished loading: $url');
            setState(() {
              isLoading = false;
            });
            _checkForSuccess(url);

            // Show success Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Page loaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
                Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
              ''');

            // Capture web resource error in Sentry
            Sentry.captureException(
              Exception('Web resource error: ${error.description}'),
              stackTrace: error.description,
            );

            // Show error Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            print('onNavigationRequest');
            //I first had this line to prevent redirection to anywhere on the internet via hrefs
            //but this prevented ANYTHING from being displayed
            // return NavigationDecision.prevent;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('gggg!'),
                backgroundColor: Colors.green,
              ),
            );
            return NavigationDecision
                .navigate; //changed it to this, and it works now
          },
        ),
      )
      ..loadRequest(Uri.parse('https://lialinaapp.com'));

    setState(() {
      showLoadingForFiveSeconds = false; // Disable after 5 seconds
    });
  }

  Future<void> _checkForSuccess(String url) async {
    try {
      debugPrint('Checking for success on: $url');
      var emailObject = await _controller!
          .runJavaScriptReturningResult("document.body.innerText");

      String pageContent = emailObject.toString();
      debugPrint('Page content: $pageContent');

      if (pageContent.contains('Success505')) {
        debugPrint('Success505 found in the content');

        String emailPattern = r'[\w\.-]+@[\w\.-]+\.\w+';
        RegExp regExp = RegExp(emailPattern);
        String? email = regExp.stringMatch(pageContent);

        if (email != null && email.isNotEmpty) {
          debugPrint('Email extracted: $email');
          purchaseController.saveEmail(email);

          Get.to(PurchaseScreen(),
              binding: PurchaseBinding(),
              duration: const Duration(milliseconds: 150));
        } else {
          debugPrint('Failed to extract email');
        }
      } else {
        debugPrint('Success505 not found in the content');
      }
    } catch (error, stackTrace) {
      debugPrint('Error checking for success: $error');
      Sentry.captureException(error,
          stackTrace: stackTrace); // Capture exception to Sentry
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: WebViewWidget(controller: _controller!),
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
