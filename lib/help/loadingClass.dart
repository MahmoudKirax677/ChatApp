import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../help/globals.dart' as globals;
import 'myprovider.dart';

class LoadingDialog{
  showDialogBox(context){
    Provider.of<AppProvide>(context,listen: false).loading = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: ()async => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: StatefulBuilder(
                  builder: (BuildContext _, StateSetter setState) {
                    return Center(
                      child: Container(
                        height: 100,
                        width: 130,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpinKitFadingCircle(
                              size: 50,
                              itemBuilder: (_, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven ? Colors.black54 : const Color(0xffc52278),
                                  ),
                                );
                              },
                            ),
                            const Text("جاري التحميل ...")
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        }
    );
  }
  hideDialog(context){
    Provider.of<AppProvide>(context,listen: false).loading = false;
    Navigator.of(context).pop();
  }
}
