import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix_native/phoenix_native.dart';
import 'package:zefaf/App/AboutApp/AboutApp.dart';
import 'package:zefaf/App/Coin/CoinMainPage.dart';
import 'package:zefaf/App/ConnectUs/ConnectUs.dart';
import 'package:zefaf/App/MyInterestList/InterestedList.dart';
import 'package:zefaf/App/MyInterestList/MyInterestList.dart';
import 'package:zefaf/App/Search/Search.dart';
import 'package:zefaf/App/SuccessStories/SuccessStories.dart';
import '../../../auth/login.dart';
import '../../../help/GetStorage.dart';
import '../../../help/globals.dart' as globals;
import '../../../help/hive/localStorage.dart';
import '../../../services/binding/PackageBinding.dart';
import '../../BlockedUsers/BlockedUsers.dart';
import '../../Coin/PackagePage.dart';
import '../../Search Online/SearchOnline.dart';
import 'coinWidget.dart';
import '../../../model/login_api.dart';

class AppDrawer extends StatelessWidget {
  final String picture;
  final String userName;
  final String id;
  final String company;
  final bool connected;

   const AppDrawer({
    required this.picture,
    required this.connected,
    required this.userName,
    required this.id,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black12.withOpacity(0.0001),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .65,
                  height:  MediaQuery.of(context).size.height - 100,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      spreadRadius: 16,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20.0,
                        sigmaY: 10.0,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width * .65,
                          height:  MediaQuery.of(context).size.height - 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white.withOpacity(0.3),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Image(image: AssetImage("assets/logo/logo.png"),height: 40,),
                                const SizedBox(height: 20),
                                const CoinWidget(),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(globals.dayInfo, style: TextStyle(color: Colors.white.withOpacity(0.75))),
                                        Text(userName, style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                      ],
                                    ),
                                    Icon(Icons.circle, color: connected ? Colors.lightGreen : Colors.white.withOpacity(0.75),size: 15,)
                                  ],
                                ),
                               // const Spacer(),
                                const SizedBox(height: 0),

                                Expanded(
                                  flex: 15,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const Search();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/pngwewring.com.png"),height: 35,),
                                            const SizedBox(width: 5),
                                            Text('البحث', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),


                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const SearchOnline();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/online.png"),height: 25,),
                                            const SizedBox(width: 5),
                                            Text('اون لاين', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const InterestedList();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/—Pngtree—valentine s day 3d engraved_5820356.png"),height: 35,),
                                            const SizedBox(width: 5),
                                            Text('قائمة المهتمين', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const MyInterestList();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/give-love.png"),height: 30,),
                                            const SizedBox(width: 5),
                                            Text('قائمة اهتمامي', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: (){
                                          Get.to(const BlockedUsers());
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/img.png"),height: 30,),
                                            const SizedBox(width: 5),
                                            Text('قائمة المحضورين', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const SuccessStories();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/couple.png"),height: 35,),
                                            const SizedBox(width: 5),
                                            Text('قصص النجاح', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) {
                                                return const ConnectUs();
                                              },
                                              transitionsBuilder: (context, animation1, animation2, child) {
                                                return FadeTransition(
                                                  opacity: animation1,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration: const Duration(microseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage("assets/icons/customer-service.png"),height: 30,),
                                            const SizedBox(width: 5),
                                            Text('تواصل معنا', style: TextStyle(fontSize: 17,color: Colors.white.withOpacity(0.75))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),





                                const Spacer(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text('اعدادات الحساب', style: TextStyle(color: Colors.white.withOpacity(0.75))),
                                //     Icon(Icons.settings, color: Colors.white.withOpacity(0.75),)
                                //   ],
                                // ),
                                // const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1, animation2) {
                                          return const AboutApp();
                                        },
                                        transitionsBuilder: (context, animation1, animation2, child) {
                                          return FadeTransition(
                                            opacity: animation1,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: const Duration(microseconds: 250),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info, color: Colors.white.withOpacity(0.75),size: 15,),
                                      const SizedBox(width: 5),
                                      Text('حول التطبيق', style: TextStyle(color: Colors.white.withOpacity(0.75))),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                GestureDetector(
                                  onTap: ()async{
                                    LocalStorage().setValue("login",null);
                                    box.remove('login');
                                    PhoenixNative.restartApp();
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.exit_to_app, color: Colors.black87.withOpacity(0.75),size: 15,),
                                      const SizedBox(width: 5),
                                      Text('تسجيل الخروج', style: TextStyle(color: Colors.black87.withOpacity(0.75))),
                                    ],
                                  ),
                                ),


                                const SizedBox(height: 40),
                                GestureDetector(
                                  onTap: ()async{
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('حذف الحساب',style: TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                          actions: [
                                            GestureDetector(
                                              onTap: () async{
                                                LoginApi(context).deleteUser().then((value){
                                                  if(value != false){
                                                    LocalStorage().setValue("login",null);
                                                    box.remove('login');
                                                    box.remove('loginBtn');
                                                    Get.off(const Login());
                                                  }else{
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              },
                                              child: const Material(
                                                color: Colors.transparent,
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 120,
                                                  child: Center(
                                                    child: Text('نعم', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Material(
                                                color: Colors.transparent,
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 120,
                                                  child: Center(
                                                    child: Text('لا', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          content: const Text('حذف الحساب بشكل نهائي ؟',style: TextStyle(fontFamily: "Tajawal",color: Color(0xFF164CA2))),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_off_outlined, color: Colors.red.withOpacity(0.9),size: 15),
                                      const SizedBox(width: 5),
                                      Text('حذف الحساب', style: TextStyle(color: Colors.red.withOpacity(0.9),fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}