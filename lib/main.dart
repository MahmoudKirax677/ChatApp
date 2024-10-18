import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import WebView
import 'package:zefaf/view/PackagePage.dart';
import 'package:zefaf/view/webview.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://14678d368c817431689437c7ec461cba@o4507961846136832.ingest.us.sentry.io/4508134887981056';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        options.profilesSampleRate = 1.0;
      },
      appRunner: () => runApp(const MyApp()),
    );
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
