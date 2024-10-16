import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';

import '../../help/loadingClass.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "حول التطبيق"),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("نشكرك على استخدام التطبيق , ونتمنى دوماً ان ننال رضاكم , نرجو منكم مشاركة وتقيم التطبيق.", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 15.0,),),
                ),
                const SizedBox(height: 20,),
                Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child:  MaterialButton(
                        elevation: 5.0,
                        onPressed: (){
                          StoreRedirect.redirect(androidAppId: "com.zefaf.zefaf", iOSAppId: "585027354");
                        },
                        color: const Color(0xffc52278),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text('تقييم التطبيق', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child:  MaterialButton(
                        elevation: 5.0,
                        onPressed: ()async{
                          LoadingDialog().showDialogBox(context);
                          await FlutterShare.share(
                              title: 'ليالينا زفاف',
                              text: 'حمل تطبيق ليالينا زفاف',
                              linkUrl: "https://play.google.com/store/apps/details?id=com.zefaf.zefaf&pli=1",
                              chooserTitle: 'ليالينا : مشاركة التطبيق'
                          ).then((value){
                            LoadingDialog().hideDialog(context);
                          }).whenComplete((){
                            LoadingDialog().hideDialog(context);
                          }).catchError((e){
                            LoadingDialog().hideDialog(context);
                            AlertController.show("خطأ", 'حدث خطأ يرجى اعادة المحاولة', TypeAlert.error);
                          });
                        },
                        color: const Color(0xffc52278),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text('مشاركة التطبيق', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    InkWell(
                        child: const Text('موقعنا الالكتروني', style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                        onTap: () => launch('https://layalinachat.com/')
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
        ),
      ],
    );
  }
}




