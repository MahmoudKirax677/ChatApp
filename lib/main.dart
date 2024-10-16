import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import WebView
import 'package:zefaf/view/PackagePage.dart';
import 'package:zefaf/view/webview.dart';
import 'binding/PackageBinding.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xffc52278),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Handle platform-specific initialization for WebView
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }

    runApp(const MyApp());
  } catch (e) {
    print('Error Main: $e');
    debugPrint('Error Main: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Zefaf',
      home: const WebViewScreen(
        link: 'https://lialinaapp.com/',
      ), // Use WebViewScreen directly
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.comfortable,
        fontFamily: "Tajawal",
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
