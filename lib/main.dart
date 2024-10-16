import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/App/Coin/webview.dart';
import 'package:zefaf/services/binding/PackageBinding.dart';
import 'package:zefaf/services/service_locator.dart';
import 'App/mainPage/AppMainPage.dart';
import 'auth/login.dart';
import 'help/GetStorage.dart';
import 'help/error.dart';
import 'help/hive/localStorage.dart';
import 'help/myprovider.dart';
import 'help/translation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

//flutter build apk --split-per-abi
//flutter build appbundle
//flutter pub run flutter_launcher_icons:main
//flutter pub pub run flutter_native_splash:create

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 500));
  final Directory appDocumentDirectory =
      await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('local_storage');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xffc52278),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  await GetStorage.init();
  await setupLocator();
  LocalStorage().setValue("lang", "ar");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterScreenshotSwitcher.disableScreenshots();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppProvide(),
        builder: (context, _) {
          return GetMaterialApp(
            title: 'Zefaf',
            // initialBinding: PackageBinding(),
            theme: ThemeData(
                visualDensity: VisualDensity.comfortable,
                fontFamily: "Tajawal",
                useMaterial3: true),
            builder: (context, widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return CustomError(errorDetails: errorDetails);
              };
              return Directionality(
                textDirection: LocalStorage().getValue("lang") == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(
                  children: [
                    widget!,
                    const Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownAlert()),
                  ],
                ),
              );
            },
            //home: pinCode(),
            home: LocalStorage().getValue("login") == true
                ? const AppMainPage()
                : box.read('login') != null
                    ? const AppMainPage()
                    : const Login(),
            debugShowCheckedModeBanner: false,
            translations: TRANSLATION(),
            locale: Locale(LocalStorage().getValue("lang")),
            fallbackLocale: Locale(LocalStorage().getValue("lang")),
          );
        });
  }
}
