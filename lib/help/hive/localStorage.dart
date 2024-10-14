import 'package:hive/hive.dart';

class LocalStorage {
  Box<dynamic> params = Hive.box('local_storage');

  void setValue(String key, dynamic value) {
    params.put(key, value);
  }

  dynamic getValue(String key) {
    return params.get(key);
  }

  dynamic deleteValue(String key) {
    return params.delete(key);
  }

}


/// App Key
// login -> bool -> login or not
