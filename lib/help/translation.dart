import 'package:get/get.dart';
import '../utils/ar.dart';
import '../utils/en.dart';
import '../utils/tr.dart';

class TRANSLATION extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': ar,
    'en': en,
    'tr': tr
  };
}