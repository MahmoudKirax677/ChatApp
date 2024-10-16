import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/App/Call/callPage.dart';
import 'package:zefaf/App/mainPage/pages/chat/Chat.dart';
import 'package:zefaf/App/mainPage/pages/chat/ChatList.dart';
import 'package:zefaf/App/mainPage/pages/notificationsPage/NotificationsMainPage.dart';
import 'package:zefaf/App/mainPage/pages/profilePage/OtherProfileMainPage.dart';
import 'package:zefaf/App/mainPage/pages/profilePage/ProfileMainPage.dart';
import 'package:zefaf/App/mainPage/pages/settingsPage/SettingsMainPage.dart';
import 'package:zefaf/App/mainPage/pages/usersPage/UsersMainPage.dart';
import 'package:zefaf/App/mainPage/widgets/appDrawer.dart';
import 'package:zefaf/App/mainPage/widgets/userState.dart';
import 'package:zefaf/help/hive/localStorage.dart';
import '../../help/globals.dart' as globals;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../../help/chatStream.dart';
import '../../help/myprovider.dart';
import '../../model/BuyCoinsApi.dart';
import '../Call/callPage.dart';
import '../Call/callPage.dart';
import '../../../../model/home_api.dart';
import '../Search Online/SearchOnline.dart';



class AppMainPage extends StatefulWidget {
  const AppMainPage({Key? key}) : super(key: key);

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> with TickerProviderStateMixin{

  List<bool> isSelected = [false,true,false];
  final Color _accentColor = const Color(0xffc52278);
  late PageController pageViewController;
  late TabController tapPageViewController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var selectedIndex = 1;
  final socketServer = "http://45.138.39.93:8383";
  var connected = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  List selectedList = [0];
  var selected = 0 ;

  @override
  void initState() {
    pageViewController = PageController(initialPage: 0,viewportFraction: 1);
    tapPageViewController = TabController(length: 5, vsync: this);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      greeting();
      getMyProfile(context);
    });
   // permissionHandler(context);
  }




  permissionHandler(context)async{
    if (await Permission.camera.isDenied) {
      openAlertBox(context);
    }else if (await Permission.storage.isDenied) {
      openAlertBox(context);
    }else if (await Permission.microphone.isDenied) {
      openAlertBox(context);
    }
  }



  openAlertBox(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text("صلاحيات الوصول", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
                    ],
                  ),




                  const SizedBox(height: 10.0),
                  const Divider(color: Colors.grey, height: 4.0),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Text("بالضغط على زر موافق سوف تقوم بتفعيل صلاحيات المطلوبة ادناه , يسمح لك بأجراء المكالمات الصوتية والمرئية وتغير صورة الملف الشخصي.",textAlign: TextAlign.justify,textDirection: TextDirection.rtl, style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 5.0),



                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: const [
                        ListTile(
                          title: Text("صلاحية الكاميرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم اثناء المكالمات و تغير صورة الملف الشخصي."),
                          leading: Icon(Icons.camera,color: Color(0xffc52278),),
                        ),
                        ListTile(
                          title: Text("صلاحية الذاكرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم في تغير صورة الملف الشخصي."),
                          leading: Icon(Icons.memory,color: Color(0xffc52278),),
                        ),
                        ListTile(
                          title: Text("صلاحية الكاميرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم اثناء المكالمات الصوتية والمرئية."),
                          leading: Icon(Icons.mic,color: Color(0xffc52278),),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 10.0),

                  GestureDetector(
                    onTap: ()async{
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.camera,
                        Permission.storage,
                        Permission.microphone,
                      ].request();
                      if (await Permission.storage.isPermanentlyDenied || await Permission.storage.isDenied) {
                        openAppSettings();
                      }else if (await Permission.camera.isPermanentlyDenied || await Permission.camera.isDenied) {
                        openAppSettings();
                      }else if (await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) {
                        openAppSettings();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffc52278),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: const Text("موافق", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }



  getMyProfile(context)async{
    BuyCoinsApi().getProfile(context);
    await HomeApi(context).mainApiCall(id: LocalStorage().getValue("userID")).then((value){
      if(value != false){
        initSocket(context,value["data"]["user_status_id"]);
      }else{}
    });
  }


  inCallDialog(context){
    AlertController.show("Call", "inCall", TypeAlert.success);
      AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Dialog Title',
          desc: 'Dialog description here.............',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
    ).show();
  }


  initSocket(context,onlineId){
      globals.socket = IO.io(socketServer, OptionBuilder().setTransports(['websocket']).setQuery({
        "id": LocalStorage().getValue("userID"),
        "onlineId" : onlineId
      }).build());
    globals.socket.onConnect((_) {
      setState(() {
        connected = true;
      });
    });
    globals.socket.onDisconnect((_) => print('disconnect'));


    globals.socket.on('commingCall', (data){
      //AlertController.show("Call", "${data["callChannel"]}", TypeAlert.success);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return CallPage(id: data["callChannel"],otherProfileData: data["profileListData"],from: 1,caller: 0,callType: data["callType"],);
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
    });


      globals.socket.on('cancel', (data){
        if(data["message"]){
         AlertController.show("مشغول", "العميل في الاتصال الان", TypeAlert.warning);
         CallPage.staticGlobalKey.currentState?.stopSound();
        }else{}
        CallPage.staticGlobalKey.currentState?.onBack(context);
      });

      globals.socket.on('ansser', (data){
        CallPage.staticGlobalKey.currentState?.init();
      });

      globals.socket.on('online', (data){
        List indexOfItems = [];
        Provider.of<AppProvide>(context,listen: false).onlineMap = data;
        for(var i in Provider.of<AppProvide>(context,listen: false).mainList){
          if(Provider.of<AppProvide>(context,listen: false).onlineMap[i["id"].toString()] == 0){
            i["user_status_id"] = 0;
          }else{
            indexOfItems.add(Provider.of<AppProvide>(context,listen: false).mainList.indexOf(i));
            i["user_status_id"] = i["user_status_id"] == 2 ? 2 : 1;
          }
        }
        Provider.of<AppProvide>(context,listen: false).mainList.sort((a, b) => (a['user_status_id']).compareTo(b['user_status_id']));

        
/*        print(data);
          Provider.of<AppProvide>(context,listen: false).onlineMap = data;
          data.keys.forEach((id){
            var index = Provider.of<AppProvide>(context,listen: false).mainList.indexWhere((element) => element["id"].toString() == id);
            if(index > -1) Provider.of<AppProvide>(context,listen: false).mainList[index]["user_status_id"] = data[id];
          });
        Provider.of<AppProvide>(context,listen: false).mainList.sort((a, b) => (a['user_status_id']).compareTo(b['user_status_id']));*/
        
        
        
      });


      globals.socket.on('chat', (data){

        data["senderId"] != LocalStorage().getValue("userID") ?  globals.userId == data["senderId"] ? null : AlertController.show("${data["name"]}", data["type"] ? "رسالة جديدة" : "${data["message"]}", TypeAlert.success) : null;

        setState((){
          data["senderId"] != LocalStorage().getValue("userID") ?  globals.userId == data["senderId"] ? null :
          LocalStorage().getValue("${data["senderId"]}") == null ? LocalStorage().setValue("${data["senderId"]}",1) :
          LocalStorage().setValue("${data["senderId"]}", LocalStorage().getValue("${data["senderId"]}") +1 ): null;
        });



        data["senderId"] != LocalStorage().getValue("userID") ?
       FlutterRingtonePlayer.play(
         fromAsset: "assets/call/message.mp3",
         looping: false, // Android only - API >= 28
         asAlarm: false, // Android only - all APIs
       ): null;
        ChatPage.staticGlobalKey.currentState?.addToList(data);
      });



      globals.socket.on('gf', (data){
        data["senderId"] != LocalStorage().getValue("userID") ?
        FlutterRingtonePlayer.play(
          fromAsset: "assets/call/gift.mp3",
          looping: false, // Android only - API >= 28
          asAlarm: false,
        ) : null;
        ChatPage.staticGlobalKey.currentState?.addGift(data);
      });

      globals.socket.on('vf', (data){
        data["senderId"] != LocalStorage().getValue("userID") ?
        FlutterRingtonePlayer.play(
          fromAsset: "assets/call/gift.mp3",
          looping: false, // Android only - API >= 28
          asAlarm: false,
        ) : null;
        addGift(data);
      });


    globals.socket.connect();
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



  onBack({selected}){
    final providerValue = Provider.of<AppProvide>(context,listen: false);
    setState(() {
      selectedList.length == 1 ? providerValue.selected = 0 : selectedList.removeAt(selectedList.length - 1);
      this.selected = selectedList.last;
      selectedList.last == 0 ?  providerValue.selected = 0 :  providerValue.selected = 2;
      //selectedList[selectedList.length -1] == 0 ?  providerValue.selected = 0 :  providerValue.selected = 2;
    });
    tapPageViewController.animateTo(selectedList.last);
    pageViewController.jumpToPage(selectedList.last);
  }



  @override
  void dispose() {
    pageViewController.dispose();
    globals.socket.disconnect();
    globals.socket.destroy();
    globals.socket.dispose();
    super.dispose();
  }

  Future greeting() async{
    var hour = DateTime.now().hour;
    if (hour < 5) {
      globals.dayInfo = 'ليلة سعيدة';
    } // ليل
    else if (hour < 12 && hour > 5) {
      globals.dayInfo = 'صباح الخير';
    } // صباح الخير
    else if (hour < 20 && hour > 12) {
      globals.dayInfo = 'مساء الخير';
    } // مساء الخير
    else{
      globals.dayInfo = 'ليلة سعيدة';
    } // ليل
    setState(() {

    });
    return globals.dayInfo;
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
        WillPopScope(
          onWillPop: () async => selectedList.isEmpty ? false : onBack(selected: selectedList.last),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _key,
            drawer:  AppDrawer(connected: connected,company: 'الامير ميديا', userName: '${LocalStorage().getValue("name")}', picture: 'https://3denerji.com/wp-content/uploads/2019/02/person2-1.jpg', id: '1',),
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: _accentColor,
              cornerRadius: 10,
              controller: tapPageViewController,
              items: const [
                TabItem(icon: Icons.home_filled, title: 'الرئيسية'),
                TabItem(icon: Icons.supervised_user_circle, title: 'ملفي'),
                TabItem(icon: Icons.message_outlined, title: 'الدردشة'),
                TabItem(icon: Icons.notifications, title: 'الاشعارات'),
                TabItem(icon: Icons.settings, title: 'الاعدادات'),
              ],
              initialActiveIndex: selected,
              style: TabStyle.fixedCircle,
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
              ),
              onTap: (i){
                i == selected ? null : setState((){
                  Provider.of<AppProvide>(context,listen: false).selected = i;
                  pageViewController.jumpToPage(i);
                  tapPageViewController.animateTo(i);
                  selected = i;
                  selectedList.add(selected);
                });
              },
            ),
            body: PageView(
              controller: pageViewController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                UsersMainPage(ScaffoldKey: _key),
                ProfileMainPage(ScaffoldKey: _key),
                ChatList(ScaffoldKey: _key),
                NotificationsMainPage(ScaffoldKey: _key),
                SettingsMainPage(ScaffoldKey: _key),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
