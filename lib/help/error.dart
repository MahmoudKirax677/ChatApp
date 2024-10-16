import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const CustomError({Key? key, required this.errorDetails,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pixeltrue-error.png'),
            const Text('Oups! Something went wrong!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kDebugMode ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
            const SizedBox(height: 12),
            const Text("نأسف عن هذا الخطأ يرجى مراسلة الادارة لحل هذا المشكلة , شكراً لأهتمامكم",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}