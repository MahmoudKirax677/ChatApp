import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/App/Search/ResearchResults.dart';
import '../../../../help/globals.dart' as globals;
import '../../auth/widgets/iso.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../../help/myprovider.dart';
import '../mainPage/pages/profilePage/widgets/ProfileList.dart';
import 'package:intl/intl.dart' as i;
import '../../model/profile_api.dart';
import '../../model/search_api.dart';


class SearchOnline extends StatefulWidget {
  const SearchOnline({Key? key}) : super(key: key);

  @override
  State<SearchOnline> createState() => _SearchOnlineState();
}

class _SearchOnlineState extends State<SearchOnline> {

  final Color _accentColor = const Color(0xffc52278);



  Map searchMap = {"hairColorId": null,"eyeColorId": null,"socialStatuseId": null,"financialstatuseId": null,"age": null,"countryId": null,"gender" : null};
  var selectedIndex = 1;
  var selectedIndexG = 1;



  @override
  void initState() {
    super.initState();
    LocalStorage().getValue("gender") == 1 ? selectedIndex = 1 : LocalStorage().getValue("gender") == 2 ? selectedIndex = 0 : selectedIndex = 3;
    LocalStorage().getValue("gender") == 1 ? selectedIndexG = 2 : LocalStorage().getValue("gender") == 2 ? selectedIndexG = 1 : selectedIndexG = 3;
    searchMap["gender"] = selectedIndexG;
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    _accentColor.withOpacity(0.5),
                    _accentColor
                  ],
                  stops: const [
                    0.0,
                    1.0
                  ]
              )
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.pink.shade400,
            toolbarHeight: 50,
            elevation: 14,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Opacity(
                      opacity: 0.3,
                      child: Image(image: AssetImage("assets/logo/logo.png"),height: 250,)),
                  Column(
                    children: [
                      // const Image(image: AssetImage("assets/logo/logo.png"),height: 30,color: Colors.white,),
                      // const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),

                          const Text("البحث", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),

                          const Icon(Icons.menu,color: Colors.transparent,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: ListView(
              children: [



                const SizedBox(height: 30,),
                Center(
                  child: ToggleSwitch(
                    initialLabelIndex: selectedIndex,
                    customWidths: const [85,85,85],
                    activeBgColor: const [Color(0xffc52278)],
                    inactiveBgColor: Colors.white,
                    labels: const ['ذكور', 'اناث', 'عشوائي'],
                    onToggle: (index) {
                      setState((){
                        selectedIndex = index!;
                        selectedIndex == 0 ? selectedIndexG = 1 : selectedIndex == 1 ? selectedIndexG = 2 : selectedIndexG = 3;
                        searchMap["gender"] = selectedIndexG;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  width: 300,
                  height: 50,
                  child:  MaterialButton(
                    elevation: 5.0,
                    onPressed: ()async{
                      OverlayState? overlayState = Overlay.of(context);
                      OverlayEntry overlayEntry = OverlayEntry(
                        builder: (context) => Center(
                          child: Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height,
                            child: SizedBox(
                             // height: 400,width: 400,
                              child: Lottie.asset(
                                'assets/icons/se.json',
                               // height: 400,
                                animate: true,
                                repeat: true,
                              ),
                            ),
                          ),
                        ),
                      );
                     overlayState?.insert(overlayEntry);
                      LoadingDialog().showDialogBox(context);
                      SearchApi(context).searchApi(searchMap: searchMap).then((value)async{
                        await Future.delayed(const Duration(seconds: 1)).then((xx){
                          LoadingDialog().hideDialog(context);
                         overlayEntry.remove();
                          if(value != false){
                            if(value["data"].isNotEmpty){
                              List onlineData = [];
                              for(var i in value["data"]){
                                Provider.of<AppProvide>(context,listen: false).onlineMap[i["id"].toString()] == 0 ? onlineData.add(i) : null;
                              }
                              onlineData.isNotEmpty ? Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) {
                                    return ResearchResults(searchData: onlineData);
                                  },
                                  transitionsBuilder: (context, animation1, animation2, child) {
                                    return FadeTransition(
                                      opacity: animation1,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(seconds: 1),
                                ),
                              ) : AlertController.show("تم", "لا يوجد متواجدين في الوقت الحالي !", TypeAlert.warning);
                            }else{
                              AlertController.show("تم", "لا يوجد نتائج للبحث !", TypeAlert.warning);
                            }
                          }else{}
                        });
                      });
                    },
                    color: const Color(0xffc52278),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('ابحث', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }
}
