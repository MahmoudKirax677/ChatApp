import 'package:get/get.dart';
import 'package:zefaf/services/purchase_controller.dart';
import '../controller/PaymentController.dart';


class PackageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(()=> PaymentController());
    //Get.put(PaymentController);
  }
}

class PurchaseBinding extends Bindings {
  @override
  void dependencies() {
    // يتم إنشاء PurchaseController وربطه عند استدعاء الشاشة المرتبطة
    Get.lazyPut<PurchaseController>(() => PurchaseController());
  }
}