import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingDialog{
  showDialogBox(){
    Get.dialog(
      barrierDismissible: false,
      useSafeArea: true,
      WillPopScope(
        onWillPop: ()async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
              builder: (BuildContext _, StateSetter setState) {
                return Center(
                  child: Container(
                    height: 75,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinKitFadingCircle(
                          size: 30,
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven ? Colors.black : Colors.black12,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        Text("loading".tr,style: const TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
  hideDialog(){
    Get.back();
  }
}
