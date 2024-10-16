import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../help/hive/localStorage.dart';
import '../../../../help/loadingClass.dart';
import '../../../../help/myprovider.dart';
import '../../../../model/report_api.dart';
import '../../../Call/callPage.dart';
import '../../widgets/userState.dart';
import '../chat/Chat.dart';
import '../../../../model/interest_api.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../model/profile_api.dart';
import '../../../../model/home_api.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';


class OtherProfileMainPage extends StatefulWidget {
  static final GlobalKey<_OtherProfileMainPageState> staticGlobalKey = GlobalKey<_OtherProfileMainPageState>();
  Map otherProfileData = {};
  var from;
  OtherProfileMainPage({Key? key,required this.otherProfileData,this.from}) : super(key: staticGlobalKey);

  @override
  State<OtherProfileMainPage> createState() => _OtherProfileMainPageState();
}

class _OtherProfileMainPageState extends State<OtherProfileMainPage> {
  final Color _accentColor = const Color(0xffc52278);
  Map profileListData = {};

  late List<ItemModel> menuItems;
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController feeController;

  @override
  void initState() {
    feeController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMain(context,LocalStorage().getValue("globalGender"));
    });
    menuItems = [
      ItemModel(' ابلاغ عن ${widget.otherProfileData["name"]} ', Icons.verified_user_outlined),
    ];
  }


  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  pageState(){
    setState((){});
  }


  bool isBlocked = true;

  getMain(context,gender){
    HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
      if(value != false){
        setState((){
          widget.otherProfileData = value["data"];
          isBlocked = value["data"]["IsBlock"];
        });
        Provider.of<AppProvide>(context,listen: false).viewProfile = value["data"]["viewAccount"];
      }else{}
    });
    setState((){});
  }


  blockUserM(context){
    HomeApi(context).blockUser(partnerId: widget.otherProfileData["id"]).then((value){
      if(value != false){
        getMain(context,LocalStorage().getValue("globalGender"));
      }else{}
    });
    setState((){});
  }

  getProfile(context,callType){
    ProfileApi(context).getProfile().then((value){
      if(value != false){
        if(callType == 'call'){
          if(Provider.of<AppProvide>(context,listen: false).coins < Provider.of<AppProvide>(context,listen: false).audio){
            AlertController.show("خطأ", "رصيدك غير كافي , يرجى اضافة كوينز لاجراء الاتصال !", TypeAlert.warning);
          }else{
            doCall(context,callType,value);
          }
        }else if(callType == 'videoCall'){
          if(Provider.of<AppProvide>(context,listen: false).coins < Provider.of<AppProvide>(context,listen: false).video){
            AlertController.show("خطأ", "رصيدك غير كافي , يرجى اضافة كوينز لاجراء الاتصال !", TypeAlert.warning);
          }else{
            doCall(context,callType,value);
          }
        }else{}
      }else{}
    });
  }

  doCall(context,callType,value){
    setState((){
      profileListData = value["data"];
    });
    const String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    String callChannel = getRandomString(15);
    globals.socket.emit("commingCall",[{
      "id" : widget.otherProfileData["id"],
      "profileListData" : profileListData,
      "callType" : callType,
      "callChannel" : callChannel
    }]);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return CallPage(id: callChannel,otherProfileData: widget.otherProfileData,from: 1,caller: 1,callType: callType,);
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
  }


  @override
  void dispose() {
    feeController.dispose();
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
                        children: [
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
                          widget.from == 1 ? const Text("في قائمة اهتمامي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),) :
                          widget.from == 3 ? const Text("في قصص النجاح", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),) : widget.otherProfileData["addFav"] ? GestureDetector(
                            onTap: (){
                              showDialog<bool>(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text('اضافة ${widget.otherProfileData["name"]} الى قائمة اهتمامي ؟',style: const TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                    actions: [
                                      GestureDetector(
                                        onTap: () async{
                                          await HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                                            if(value != false){
                                              setState((){
                                                widget.otherProfileData = value["data"];
                                              });
                                            }else{}
                                          }).whenComplete((){
                                            if(widget.otherProfileData["addFav"]){
                                              Navigator.of(context).pop();
                                              InterestApi(this.context).addToMyInterestApi(partnerId: widget.from == 2 ? widget.otherProfileData["id"] : widget.otherProfileData["userId"],name: widget.otherProfileData["name"]).then((value){});
                                            }else{
                                              Navigator.of(context).pop();
                                              AlertController.show("خطأ", "لا يمكنك من اضافة ${widget.otherProfileData["name"]} !", TypeAlert.warning);
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
                                  //  content: const Text('اضافة الى قائمة اهتمامي',style: TextStyle(fontFamily: "Tajawal",color: Color(0xFF164CA2))),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.sports_handball,color: Colors.white,),
                                Text("مهتم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                              ],
                            ),
                          ) : Container(),

                          Row(
                            children: [
                              const Text("البروفايل", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                              GestureDetector(
                                onTap: (){
                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: const Text('ادوات المستخدم'),
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(title: Text(!isBlocked ? 'حضر المستخدم' : 'فتح الحضر',style: const TextStyle(color: Colors.redAccent)), onPressed: (x) {
                                        blockUserM(context);
                                        Get.back();
                                      }),
                                      BottomSheetAction(title: const Text('تبليغ عن المستخدم'), onPressed: (x) {
                                        showDialog<bool>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: const Text('تبليغ',style: TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if(_formState.currentState!.validate()){
                                                      LoadingDialog().showDialogBox(context);
                                                      Report().addReport(data: {
                                                        "id": widget.otherProfileData["id"],
                                                        "reason" : feeController.text
                                                      }).then((value) {
                                                        LoadingDialog().hideDialog(context);
                                                        if (value != false) {
                                                          feeController.clear();
                                                          AlertController.show("تم", "تم ارسال التبليغ بنجاح", TypeAlert.success);
                                                        }else {
                                                        }
                                                      }).whenComplete((){
                                                        Navigator.pop(context);
                                                      });
                                                    }else{
                                                      AlertController.show("خطأ", "يرجى كتابة التبليغ !", TypeAlert.warning);
                                                    }
                                                  },
                                                  child: const Material(
                                                    color: Colors.transparent,
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 120,
                                                      child: Center(
                                                        child: Text('ارسال التبيلغ', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    feeController.clear();
                                                  },
                                                  child: const Material(
                                                    color: Colors.transparent,
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 120,
                                                      child: Center(
                                                        child: Text('اغلاق', style: TextStyle(color: Colors.redAccent,fontSize: 15,fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              content: Form(
                                                key: _formState,
                                                child: Column(
                                                  children: <Widget>[
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            // height: 50,
                                                            child: Material(
                                                              elevation: 1.0,
                                                              color: Colors.white70,
                                                              borderRadius: BorderRadius.circular(5),
                                                              child: TextFormField(
                                                                controller: feeController,
                                                                textAlignVertical: TextAlignVertical.bottom,
                                                                minLines: 3,
                                                                maxLines: 3,
                                                                cursorColor: const Color(0xFF26242e),
                                                                style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                                                validator: (value) => value!.isEmpty ? 'يرجى كتابة التبليغ' : null,
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    borderSide: const BorderSide(
                                                                      width: 0,
                                                                      style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                  hintStyle: const TextStyle(fontSize: 12),
                                                                  errorStyle: const TextStyle(height: 0.7),
                                                                  hintText: 'نص التبليغ ...',
                                                                  fillColor: const Color(0xffffffff),
                                                                  //filled: true
                                                                ),
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
                                          },
                                        );
                                      }),
                                    ],
                                    cancelAction: CancelAction(title: const Text('الغاء')),// onPressed parameter is optional by default will dismiss the ActionSheet
                                  );
                                },
                                child: const Icon(Icons.more_vert, color: Colors.white),
                              )
                            ],
                          ),

                          //Icon(Icons.menu,color: Colors.transparent,),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        widget.otherProfileData["images"] == null ? SizedBox(
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundColor: const Color(0xffc52278),
                            child: CircleAvatar(
                              radius: 42.0,
                              backgroundColor: const Color(0xffc52278),
                              backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: UserState(id: widget.otherProfileData["id"],size: 15.0,radius: 10.0),
                              ),
                            ),
                          ),
                        )
                            :
                        SizedBox(
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundColor: const Color(0xffc52278),
                            child: CircleAvatar(
                              radius: 42.0,
                              backgroundColor: const Color(0xffc52278),
                              backgroundImage: NetworkImage(widget.otherProfileData["images"]),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: UserState(id: widget.otherProfileData["id"],size: 15.0,radius: 10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("${widget.otherProfileData["countryName"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.otherProfileData["trusted"] ? const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.check,color: Colors.white,size: 17,),
                    ) : Container(),
                  ],
                ),



                const SizedBox(height: 30,),
                /// TODO Is Blocked
                isBlocked ? Container() :
                widget.otherProfileData["user_status_id"] != 2 ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: ()async{
                          await HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                            if(value != false){
                              setState((){
                                widget.otherProfileData = value["data"];
                                isBlocked = value["data"]["IsBlock"];
                              });
                            }else{}
                          }).whenComplete((){
                            widget.otherProfileData["user_status_id"] == 2 || isBlocked ? AlertController.show("خطأ", "لا يمكنك من مراسلة ${widget.otherProfileData["name"]} !", TypeAlert.warning) : widget.otherProfileData["reciveSms"] ? Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) {
                                  return ChatPage(from: 1,otherProfileData: widget.otherProfileData);
                                },
                                transitionsBuilder: (context, animation1, animation2, child) {
                                  return FadeTransition(
                                    opacity: animation1,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(microseconds: 250),
                              ),
                            ) : AlertController.show("خطأ", "لا يمكنك من مراسلة ${widget.otherProfileData["name"]} !", TypeAlert.warning);
                          });
                        },
                        child: const Icon(Icons.message_outlined,color: Colors.white,size: 30)),



                    GestureDetector(
                        onTap: ()async{
                          await HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                            if(value != false){
                              setState((){
                                widget.otherProfileData = value["data"];
                                isBlocked = value["data"]["IsBlock"];
                              });
                            }else{}
                          }).whenComplete((){
                            widget.otherProfileData["user_status_id"] == 2 || isBlocked ? AlertController.show("خطأ", "لا يمكنك اتصال بـ ${widget.otherProfileData["name"]} !", TypeAlert.warning) : widget.otherProfileData["reciveVideo"] ?
                            getProfile(context,"videoCall")
                                :
                            AlertController.show("خطأ", "لا يمكنك اتصال بـ ${widget.otherProfileData["name"]} !", TypeAlert.warning);
                          });
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.video_camera_front,color: Colors.white,size: 30),
                            const SizedBox(height: 5),
                            Text('${Provider.of<AppProvide>(context,listen: false).video}\nكوينز للدقيقة',textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 10))
                          ],
                        )),





                    GestureDetector(
                        onTap: ()async{
                          await HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                            if(value != false){
                              setState((){
                                widget.otherProfileData = value["data"];
                                isBlocked = value["data"]["IsBlock"];
                              });
                            }else{}
                          }).whenComplete((){
                            widget.otherProfileData["user_status_id"] == 2 || isBlocked ? AlertController.show("خطأ", "لا يمكنك اتصال بـ ${widget.otherProfileData["name"]} !", TypeAlert.warning) : widget.otherProfileData["reciveCall"] ?
                            getProfile(context,"call")
                                :
                            AlertController.show("خطأ", "لا يمكنك اتصال بـ ${widget.otherProfileData["name"]} !", TypeAlert.warning);
                          });
                        },child: Column(
                          children: [
                            const Icon(Icons.call,color: Colors.white,size: 30),
                            const SizedBox(height: 5),
                            Text('${Provider.of<AppProvide>(context,listen: false).audio}\nكوينز للدقيقة',textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 10))
                          ],
                        )),




                  ],
                ) : Container(),






                const SizedBox(height: 30,),
                /// TODO Is Blocked
                isBlocked ? Container() :
                Provider.of<AppProvide>(context,listen: true).viewProfile ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("نبذة تعريفية", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
                      const SizedBox(height: 30,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("المواليد", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Text("${widget.otherProfileData["birthday"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .5,),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("لون الشعر", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Text("${widget.otherProfileData["hairColor"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .5,),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("لون العين", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Text("${widget.otherProfileData["eyeColor"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .5,),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الحالة الاجتماعية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Text("${widget.otherProfileData["socialStatus"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .5,),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("الحالة المادية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Text("${widget.otherProfileData["financialStatus"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .5,),
                        ],
                      ),
                    ],
                  ),
                ) : Container(),

              ],
            ),
          ),
        ),
      ],
    );
  }
}


class ItemModel {
  String title;
  IconData icon;
  ItemModel(this.title, this.icon);
}