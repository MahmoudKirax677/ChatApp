import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/View/Search/ResearchResults.dart';
import '../../../../help/globals.dart' as globals;
import '../../auth/widgets/iso.dart';
import '../../help/hive/localStorage.dart';
import '../../help/loadingClass.dart';
import '../../help/myprovider.dart';
import '../mainPage/pages/profilePage/widgets/ProfileList.dart';
import 'package:intl/intl.dart' as i;
import '../../model/profile_api.dart';
import '../../model/search_api.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final Color _accentColor = const Color(0xffc52278);
  late TextEditingController userNameController;
  late TextEditingController ageController;
  late TextEditingController hairColourController;
  late TextEditingController eyeColourController;
  late TextEditingController statusController;
  late TextEditingController moneyController;
  FocusNode fu = FocusNode();
  FocusNode fu1 = FocusNode();
  FocusNode fu2 = FocusNode();
  FocusNode fu3 = FocusNode();
  FocusNode fu4 = FocusNode();
  FocusNode fu5 = FocusNode();
  bool isEditable = false;
  Map searchMap = {"hairColorId": null,"eyeColorId": null,"socialStatuseId": null,"financialstatuseId": null,"age": null,"countryId": null,"gender" : null};
  var selectedIndex = 1;
  var selectedIndexG = 1;



  @override
  void initState() {
    userNameController = TextEditingController(text: "ليلى عبدالكريم");
    ageController = TextEditingController();
    hairColourController = TextEditingController(text: "لون الشعر");
    eyeColourController = TextEditingController(text: "لون العين");
    statusController = TextEditingController(text: "الحالة الاجتماعية");
    moneyController = TextEditingController(text: "الحالة المادية");
    super.initState();
    LocalStorage().getValue("gender") == 1 ? selectedIndex = 1 : LocalStorage().getValue("gender") == 2 ? selectedIndex = 0 : selectedIndex = 3;
    LocalStorage().getValue("gender") == 1 ? selectedIndexG = 2 : LocalStorage().getValue("gender") == 2 ? selectedIndexG = 1 : selectedIndexG = 3;
    searchMap["gender"] = selectedIndexG;
  }

  @override
  void dispose() {
    userNameController.dispose();
    ageController.dispose();
    hairColourController.dispose();
    eyeColourController.dispose();
    statusController.dispose();
    moneyController.dispose();
    super.dispose();
  }



  showList({context, title, dataList, from}){
    BlurryDialog  alert = BlurryDialog(title,dataList,(id,name){
      setState((){
        switch(from){
          case 1:
            hairColourController.text = name;
            searchMap["hairColorId"] = id;
            break;
          case 2:
            eyeColourController.text = name;
            searchMap["eyeColorId"] = id;
            break;
          case 3:
            statusController.text = name;
            searchMap["socialStatuseId"] = id;
            break;
          case 4:
            moneyController.text = name;
            searchMap["financialstatuseId"] = id;
            break;
        }
      });
      Navigator.of(context).pop();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                        children: [
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
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) {
                          return const Countries();
                        },
                        transitionsBuilder: (context, animation1, animation2, child) {
                          return FadeTransition(
                            opacity: animation1,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(microseconds: 250),
                      ),
                    ).then((value){
                      setState((){
                        searchMap["countryId"] = globals.nameMyIsoId;
                      });
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: ToggleSwitch(
                          initialLabelIndex: selectedIndex,
                          customWidths: [85,85,85],
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
                      const SizedBox(height: 20,),
                      const Text("الدولة", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                      Row(
                        children:  [
                          Text(globals.dialCodeMyIso,textDirection: TextDirection.rtl,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Colors.white),strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,)),
                          const SizedBox(width: 5),
                          Image(height: 15, image: globals.flagMyIso),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                    ],
                  ),
                ),

                const SizedBox(height: 30,),
                Column(

                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("العمر", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                        GestureDetector(
                          onTap: (){
                            fu1.requestFocus();
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: EditableText(
                                  focusNode: fu1,
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.dark,
                                  expands: false,
                                  maxLines: 1,
                                  onSubmitted: (text) {
                                    setState((){
                                      searchMap["age"] = ageController.text;
                                    });
                                  },
                                  cursorColor: Colors.white,
                                  backgroundCursorColor: Colors.black,
                                  controller: ageController,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                ),
                              ),
                              const Icon(Icons.edit,color: Colors.white,)
                            ],
                          ),
                        ),
                        Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("لون الشعر", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu2,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: hairColourController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 1).then((value){
                              if(value != false){
                                showList(
                                    from: 1,
                                    title: "لون الشعر",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("لون العين", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu3,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: eyeColourController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 2).then((value){
                              if(value != false){
                                showList(
                                    from: 2,
                                    title: "لون العين",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("الحالة الاجتماعية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu4,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: statusController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 3).then((value){
                              if(value != false){
                                showList(
                                    from: 3,
                                    title: "الحالة الاجتماعية",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("الحالة المادية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu5,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: moneyController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 4).then((value){
                              if(value != false){
                                showList(
                                    from: 4,
                                    title: "الحالة المادية",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                  ],
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
                              var newValue = [];

                              newValue = value["data"];
                              List indexOfItems = [];
                              for(var i in newValue){
                                if(Provider.of<AppProvide>(context,listen: false).onlineMap[i["id"].toString()] == 0){
                                  i["user_status_id"] = 0;
                                  indexOfItems.add(i);
                                }else{
                               //   indexOfItems.add(newValue.indexOf(i));
                                  i["user_status_id"] = i["user_status_id"] == 2 ? 2 : 1;
                                }
                              }
                              newValue.sort((a, b) => (a['user_status_id']).compareTo(b['user_status_id']));

                              indexOfItems.isEmpty ? AlertController.show("تم", "لا يوجد نتائج للبحث !", TypeAlert.warning) : Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) {
                                    return ResearchResults(searchData: indexOfItems);
                                  },
                                  transitionsBuilder: (context, animation1, animation2, child) {
                                    return FadeTransition(
                                      opacity: animation1,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(seconds: 1),
                                ),
                              );
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
