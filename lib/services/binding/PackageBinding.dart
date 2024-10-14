import 'package:get/get.dart';
import '../controller/PaymentController.dart';


class PackageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(()=> PaymentController());
    //Get.put(PaymentController);
  }
}