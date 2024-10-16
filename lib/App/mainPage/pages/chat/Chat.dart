import 'dart:math';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/App/mainPage/pages/chat/widgets/message_bar.dart';
import '../../../../../../help/globals.dart' as globals;
import '../../../../help/hive/localStorage.dart';
import '../../../../help/myprovider.dart';
import '../../../Call/callPage.dart';
import '../../widgets/userState.dart';
import '../../../../../../model/profile_api.dart';
import '../../../../model/home_api.dart';
import '../../../../model/chat_api.dart';
import '../../../../model/stickers_api.dart';
import 'package:intl/intl.dart' as initl;

class ChatPage extends StatefulWidget {
  static final GlobalKey<_ChatPageState> staticGlobalKey = GlobalKey<_ChatPageState>();

  var from;
  Map otherProfileData = {};
  ChatPage({Key? key,this.from,required this.otherProfileData}):super(key: staticGlobalKey);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Color _accentColor = const Color(0xffc52278);
  List chatList = [];
  List stickersList = [];
  Map profileListData = {};
  ScrollController chatListController = ScrollController();
  int count = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCahtMessage(context,count);
    });
    globals.userId = widget.otherProfileData["id"];
    globals.chatOpen = true;
    chatListController = ScrollController()..addListener(handleScrolling);
  }

  @override
  void dispose() {
    super.dispose();
    globals.chatOpen = false;
    globals.userId = -88;
    LocalStorage().setValue("${widget.otherProfileData["id"]}",null);
  }

  void handleScrolling() {
    if (chatListController.offset <= chatListController.position.minScrollExtent) {
      setState(() {
        count += 10;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatList.length < 10 ? null : getCahtMessage(context,count);
      });
    }
  }

  Future getCahtMessage(context,limit)async{
    await ChatApi(context).getCahtMessage(id: widget.otherProfileData["id"],offset: 0,limit: limit).then((value){
      if(value != false){
        setState((){
          chatList = value["data"];
          Iterable inReverse = chatList.reversed;
          chatList = inReverse.toList();
         // print(chatList);
        });
      }else{}
    }).whenComplete((){
      limit == 10 ? chatListController.jumpTo(chatListController.position.maxScrollExtent + 65) : null;
      limit == 10 ? chatListController.jumpTo(chatListController.position.maxScrollExtent + 65) : null;
    });
  }


  Future getCahtMessage2(context)async{
    // print("============================");
    // print(chatList.length);
    setState(() {
      count += 10;
    });
    await ChatApi(context).getCahtMessage(id: widget.otherProfileData["id"],offset: 0,limit: count).then((value){
      if(value != false){
        setState((){
          chatList = value["data"];
          Iterable inReverse = chatList.reversed;
          chatList = inReverse.toList();
        });
      }else{}
    }).whenComplete((){
      count == 10 ? chatListController.jumpTo(chatListController.position.maxScrollExtent + 75) : null;
    });
  }


  getDateTime({datetime,socket}){
    if(socket == null){
      var time = datetime;
      var format = initl.DateFormat('yyyy-MM-dd');
      var format2 = initl.DateFormat().add_jm();
      return '${format.format(DateTime.parse(time))}   ${format2.format(DateTime.parse(time).add(const Duration(hours: 3)))}';
    }else{
      if(!socket) {
        var time = datetime;
        var format = initl.DateFormat('yyyy-MM-dd');
        var format2 = initl.DateFormat().add_jm();
        return '${format.format(DateTime.parse(time))}   ${format2.format(DateTime.parse(time).add(const Duration(hours: 3)))}';
      }else {
        var dt = DateTime.fromMillisecondsSinceEpoch(datetime);
        return initl.DateFormat('yyyy-MM-dd  hh:mm a').format(dt);
      }
    }
  }

  addGift(data){
    data["senderId"] != LocalStorage().getValue("userID") ? null : Navigator.of(context).pop();
    showOverlay(context: context,assetName: 'gf',sec: 4,data: data);
  }




  ///==================================================================================
  showOverlay({context, assetName,sec,data}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: NetworkImage(data["image"]),height: 75,),
            SizedBox(
              height: 400,width: 400,
              child: Lottie.asset(
                'assets/icons/$assetName.json',
                height: 400,
                animate: true,
                repeat: false,
              ),
            ),
          ],
        ),
      ),
    );
    overlayState?.insert(overlayEntry);
    await Future.delayed(Duration(seconds: sec));
    overlayEntry.remove();
    showOverlay2(context: this.context,assetName: 'cc',sec: 3500);
  }
  ///==================================================================================
  ///
  ///==================================================================================
  showOverlay2({context, assetName,sec}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => SizedBox(
        height: 200,width: 100,
        child: Lottie.asset(
          'assets/icons/$assetName.json',
          height: 200,
          animate: true,
          repeat: true,
        ),
      ),

    );
    overlayState?.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: sec));
    overlayEntry.remove();
  }
  ///==================================================================================




  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));




  addToList(data){
    setState((){
      widget.otherProfileData["id"] == data["senderId"] ? chatList.add(data) : null;
      widget.otherProfileData["id"] == data["id"] ? chatList.add(data) : null;
    });
    globals.userId == data["senderId"] ? chatListController.jumpTo(chatListController.position.maxScrollExtent + 75) : null;
    globals.userId == data["id"] ? chatListController.jumpTo(chatListController.position.maxScrollExtent + 75) : null;
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
            toolbarHeight: 75,
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
                          Row(
                            children: [
                              widget.otherProfileData["images"] == null ? SizedBox(
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: const Color(0xffc52278),
                                  child: CircleAvatar(
                                    radius: 23.0,
                                    backgroundColor: const Color(0xffc52278),
                                    backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: UserState(id: widget.otherProfileData["id"],size: 10.0,radius: 7.0),
                                    ),
                                  ),
                                ),
                              )
                                  :
                              SizedBox(
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: const Color(0xffc52278),
                                  child: CircleAvatar(
                                    radius: 23.0,
                                    backgroundColor: const Color(0xffc52278),
                                    backgroundImage: NetworkImage(widget.otherProfileData["images"]),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: UserState(id: widget.otherProfileData["id"],size: 10.0,radius: 7.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                                ],
                              ),
                            ],
                          ),
                          widget.from == 1 ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                                      if(value != false){
                                            setState((){
                                              widget.otherProfileData = value["data"];
                                            });
                                            if(value["data"]["reciveVideo"] && value["data"]["user_status_id"] != 2){
                                              getProfile(context,"videoCall");
                                            }else{
                                              AlertController.show("خطأ", "لا يمكنك من اتمام المكالمة !", TypeAlert.warning);
                                            }
                                      }else{}
                                    });
                                  },
                                  child: const Icon(Icons.video_camera_front,color: Colors.white,size: 30)),
                              const SizedBox(width: 15,),
                              GestureDetector(
                                  onTap: (){
                                    HomeApi(context).mainApiCall(id: widget.otherProfileData["id"]).then((value){
                                      if(value != false){
                                            setState((){
                                              widget.otherProfileData = value["data"];
                                            });
                                            if(value["data"]["reciveCall"] && value["data"]["user_status_id"] != 2){
                                              getProfile(context,"call");
                                            }else{
                                              AlertController.show("خطأ", "لا يمكنك من اتمام المكالمة !", TypeAlert.warning);
                                            }
                                      }else{}
                                    });
                                  },
                                  child: const Icon(Icons.call,color: Colors.white,size: 30)),
                            ],
                          ) : Container(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


















          body: Column(
            children: [

              Expanded(
                child: RefreshIndicator(
                  onRefresh: ()async => chatList.length < 10 ? null : getCahtMessage2(context),
                  child: ListView(
                    controller: chatListController,
                    children: List.generate(chatList.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: chatList.isEmpty ? Container() : chatList[index]["type"] ? Align(
                          alignment: chatList[index]["senderId"] != LocalStorage().getValue("userID") ? Alignment.centerLeft : Alignment.centerRight,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Image(image: NetworkImage(chatList[index]["message"]),height: 150,),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(getDateTime(datetime: chatList[index]["created_at"],socket: chatList[index]["socket"]),style: const TextStyle(fontSize: 10,color: Colors.white),),
                              )
                            ],
                          )) : Column(
                            children: [
                              BubbleSpecialThree(
                        text: "${chatList[index]["message"]}",
                        //sent: true,
                        color: chatList[index]["senderId"] != LocalStorage().getValue("userID") ? const Color(0xffc52278) : Colors.white,
                        isSender: chatList[index]["senderId"] == LocalStorage().getValue("userID") ? true : false,
                        textStyle: TextStyle(
                                color: chatList[index]["senderId"] != LocalStorage().getValue("userID") ? Colors.white : Colors.black87,
                                fontSize: 16
                        ),
                      ),
                              Align(
                                  alignment: chatList[index]["senderId"] != LocalStorage().getValue("userID") ? Alignment.centerLeft : Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(getDateTime(datetime: chatList[index]["created_at"],socket: chatList[index]["socket"]),style: const TextStyle(fontSize: 10,color: Colors.white),),
                                  ))
                            ],
                          ),
                    )),
                  ),
                ),
              ),
              MessageBar(
                onSend: (_)async{
                 // await ChatApi(context).getCahtUsers2().then((value)async{
                  await HomeApi(context).mainApi2(id: widget.otherProfileData["id"]).then((value)async{
                    if(value != false){
                          if(value["data"]["IsBlock"]){
                            AlertController.show("خطأ", "تم حضرك من قبل المستخدم ${value["data"]["name"]}", TypeAlert.error);
                          }else{
                            if(value["data"]["user_status_id"] == 2){
                              AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning);
                            }else if(value["data"]["reciveSms"] == false){
                              AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning);
                            }else{
                              await ChatApi(context).storeMessage(chatData: {
                                "id" : widget.otherProfileData["id"],
                                "type" : 0,
                                "message" : _
                              }).then((value){
                                if(value != false){
                                  globals.socket.emit("chat",[{
                                    "message": _,
                                    "id": widget.otherProfileData["id"],
                                    "name" : LocalStorage().getValue("name"),
                                    "type" : false,
                                    "socket" : true,
                                    "created_at": DateTime.now().millisecondsSinceEpoch,
                                    "senderId": LocalStorage().getValue("userID"),
                                  }]);
                                }else{
                                  AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                }
                              });
                            }
                          }
                    }else{
                      AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                    }
                  });
                },
                sendButtonColor: const Color(0xffc52278),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: const Image(image: AssetImage("assets/images/200w.gif"),height: 30,),
                      onTap: () async{
                        StickersApi(context).getStickers().then((value){
                          if(value != false){
                            setState((){
                              stickersList = value["data"];
                            });
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => Material(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * .7,
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: List.generate(stickersList.length, (index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Image(image: NetworkImage(stickersList[index]["image"]),height: 100,),
                                            const SizedBox(height: 10,),
                                            Text("${stickersList[index]["amount"]} كوينز", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                                            const SizedBox(height: 5,),
                                            SizedBox(
                                              width: 75,
                                              height: 40,
                                              child:  MaterialButton(
                                                elevation: 5.0,
                                                onPressed: ()async{
                                                  await HomeApi(context).mainApi2(id: widget.otherProfileData["id"]).then((value)async{
                                                    if(value != false){
                                                          if(value["data"]["user_status_id"] == 2){
                                                            AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning);
                                                          }else if(value["data"]["reciveSms"] == false){
                                                            AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning);
                                                          }else{
                                                            await StickersApi(context).sendStickers(stickersData: {
                                                              "partnerId" : widget.otherProfileData["id"],
                                                              "stickerId" : stickersList[index]["id"]
                                                            }).then((value)async{
                                                              if(value != false){
                                                                await ChatApi(context).storeMessage(chatData: {
                                                                  "id" : widget.otherProfileData["id"],
                                                                  "type" : 1,
                                                                  "message" : stickersList[index]["image"]
                                                                }).then((value) {
                                                                  if(value != false){
                                                                    globals.socket.emit("gf", [{
                                                                      "image": stickersList[index]["image"],
                                                                      "socket" : true,
                                                                      "created_at": DateTime.now().millisecondsSinceEpoch,
                                                                      "id": widget.otherProfileData["id"],
                                                                      "senderId": LocalStorage().getValue("userID"),
                                                                    }
                                                                    ]);

                                                                    globals.socket.emit("chat",[{
                                                                      "message": stickersList[index]["image"],
                                                                      "id": widget.otherProfileData["id"],
                                                                      "socket" : true,
                                                                      "name" : LocalStorage().getValue("name"),
                                                                      "created_at": DateTime.now().millisecondsSinceEpoch,
                                                                      "type" : true,
                                                                      "senderId": LocalStorage().getValue("userID"),
                                                                    }]);
                                                                  }else{
                                                                    AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                                                  }
                                                                });
                                                              }else{
                                                                AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                                              }
                                                            });
                                                          }
                                                    }else{
                                                      AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                                    }
                                                  });
                                                },
                                                color: const Color(0xffc52278),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.only(top: 5),
                                                  child: Text('ارسال', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
