import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

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
      home: const HomePage(), // استبدل الصفحة الرئيسية هنا
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.comfortable,
        fontFamily: "Tajawal",
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Zefaf', // النص الترحيبي هنا
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
      ),
    );
  }
}
