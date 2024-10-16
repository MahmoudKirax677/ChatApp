// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:flutter_dropdown_alert/alert_controller.dart';
// import 'package:flutter_dropdown_alert/model/data_alert.dart';
// import 'package:provider/provider.dart';
// import 'package:spincircle_bottom_bar/modals.dart';
// import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
// import 'package:toggle_switch/toggle_switch.dart';
// import 'package:zefaf/App/Chat/Chat.dart';
// import 'package:zefaf/App/Chat/ChatList.dart';
// import 'package:zefaf/App/mainPage/pages/notificationsPage/NotificationsMainPage.dart';
// import 'package:zefaf/App/mainPage/pages/profilePage/OtherProfileMainPage.dart';
// import 'package:zefaf/App/mainPage/pages/profilePage/ProfileMainPage.dart';
// import 'package:zefaf/App/mainPage/pages/settingsPage/SettingsMainPage.dart';
// import 'package:zefaf/App/mainPage/pages/usersPage/UsersMainPage.dart';
// import 'package:zefaf/App/mainPage/widgets/appDrawer.dart';
// import 'package:zefaf/help/hive/localStorage.dart';
// import '../../help/globals.dart' as globals;
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';
// import '../../help/chatStream.dart';
// import '../../help/myprovider.dart';
// import '../Chat/callPage.dart';
//
// class AppMainPage extends StatefulWidget {
//   const AppMainPage({Key? key}) : super(key: key);
//
//   @override
//   State<AppMainPage> createState() => _AppMainPageState();
// }
//
// class _AppMainPageState extends State<AppMainPage> {
//
//   List<bool> isSelected = [false,true,false];
//   final Color _accentColor = const Color(0xffc52278);
//   late PageController pageViewController;
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   var selectedIndex = 1;
//   final socketServer = "http://45.138.39.93:8383";
//   var connected = false;
//
//
//   @override
//   void initState() {
//     pageViewController = PageController(initialPage: 0,viewportFraction: 1);
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       greeting();
//     });
//     initSocket(context);
//   }
//
//
//   initSocket(context){
//     globals.socket = IO.io(socketServer, OptionBuilder().setTransports(['websocket']).setQuery({"id": LocalStorage().getValue("userID")}).build());
//     globals.socket.onConnect((_) {
//       setState(() {
//         connected = true;
//       });
//     });
//     globals.socket.onDisconnect((_) => print('disconnect'));
//
//
//     globals.socket.on('commingCall', (data){
//       //AlertController.show("Call", "$data", TypeAlert.success);
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation1, animation2) {
//             return CallPage(id: 0,otherProfileData: data["profileListData"],from: 1,caller: 0,callType: data["callType"],);
//           },
//           transitionsBuilder: (context, animation1, animation2, child) {
//             return FadeTransition(
//               opacity: animation1,
//               child: child,
//             );
//           },
//           transitionDuration: const Duration(microseconds: 250),
//         ),
//       );
//     });
//
//
//     globals.socket.on('cancel', (data){
//       if(data["message"]){
//         AlertController.show("Call", "inCall", TypeAlert.success);
//       }else{}
//       CallPage.staticGlobalKey.currentState?.onBack(context);
//     });
//
//     globals.socket.on('ansser', (data){
//       CallPage.staticGlobalKey.currentState?.init();
//     });
//
//     globals.socket.on('online', (data){
//       setState((){
//         globals.onlineList = data;
//       });
//       OtherProfileMainPage.staticGlobalKey.currentState?.pageState();
//     });
//
//     globals.socket.on('offline', (data){
//       setState((){
//         globals.onlineList = data;
//       });
//       OtherProfileMainPage.staticGlobalKey.currentState?.pageState();
//     });
//
//     globals.socket.on('chat', (data){
//       ChatPage.staticGlobalKey.currentState?.addToList(data);
//     });
//
//
//
//
//     globals.socket.connect();
//   }
//
//
//
//   @override
//   void dispose() {
//     pageViewController.dispose();
//     globals.socket.disconnect();
//     globals.socket.destroy();
//     globals.socket.dispose();
//     super.dispose();
//   }
//
//   Future greeting() async{
//     var hour = DateTime.now().hour;
//     if (hour < 5) {
//       globals.dayInfo = 'ليلة سعيدة';
//     } // ليل
//     else if (hour < 12 && hour > 5) {
//       globals.dayInfo = 'صباح الخير';
//     } // صباح الخير
//     else if (hour < 20 && hour > 12) {
//       globals.dayInfo = 'مساء الخير';
//     } // مساء الخير
//     else{
//       globals.dayInfo = 'ليلة سعيدة';
//     } // ليل
//     setState(() {
//
//     });
//     return globals.dayInfo;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: FractionalOffset.topCenter,
//                   end: FractionalOffset.bottomCenter,
//                   colors: [
//                     _accentColor.withOpacity(0.5),
//                     _accentColor
//                   ],
//                   stops: const [
//                     0.0,
//                     1.0
//                   ]
//               )
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           key: _key,
//           drawer:  AppDrawer(connected: connected,company: 'الامير ميديا', userName: '${LocalStorage().getValue("name")}', picture: 'https://3denerji.com/wp-content/uploads/2019/02/person2-1.jpg', id: '1',),
//           body: SpinCircleBottomBarHolder(
//             bottomNavigationBar: SCBottomBarDetails(
//                 circleColors: [Colors.white, Colors.orange, const Color(0xffc52278)],
//                 iconTheme: const IconThemeData(color: Colors.black45),
//                 activeIconTheme: const IconThemeData(color: Color(0xffc52278)),
//                 backgroundColor: Colors.white,
//                 titleStyle: const TextStyle(color: Colors.black45,fontSize: 12),
//                 activeTitleStyle: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),
//                 actionButtonDetails: SCActionButtonDetails(
//                     color: const Color(0xffc52278),
//                     icon: const Icon(
//                       Icons.expand_less,
//                       color: Colors.white,
//                     ),
//                     elevation: 2),
//                 elevation: 2.0,
//                 items: [
//                   // Suggested count : 4
//                   SCBottomBarItem(icon: Icons.home_filled, title: "الرئيسية", onPressed: () {pageViewController.jumpToPage(0);}),
//                   SCBottomBarItem(icon: Icons.supervised_user_circle, title: "ملفي", onPressed: () {pageViewController.jumpToPage(1);}),
//                   SCBottomBarItem(icon: Icons.notifications, title: "الاشعارات", onPressed: () {pageViewController.jumpToPage(2);}),
//                   SCBottomBarItem(icon: Icons.settings, title: "الاعدادات", onPressed: () {pageViewController.jumpToPage(3);}),
//                 ],
//                 circleItems: [
//                   //Suggested Count: 3
//                   SCItem(icon: const Icon(Icons.add), onPressed: () {pageViewController.jumpToPage(0);}),
//                   SCItem(icon: const Icon(Icons.print), onPressed: () {pageViewController.jumpToPage(0);}),
//                   SCItem(icon: const Icon(Icons.message_outlined), onPressed: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation1, animation2) {
//                           return const ChatList();
//                         },
//                         transitionsBuilder: (context, animation1, animation2, child) {
//                           return FadeTransition(
//                             opacity: animation1,
//                             child: child,
//                           );
//                         },
//                         transitionDuration: const Duration(microseconds: 250),
//                       ),
//                     );//
//                   }),
//                 ],
//                 bnbHeight: 80 // Suggested Height 80
//             ),
//             child: PageView(
//               controller: pageViewController,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 UsersMainPage(ScaffoldKey: _key),
//                 ProfileMainPage(ScaffoldKey: _key),
//                 NotificationsMainPage(ScaffoldKey: _key),
//                 SettingsMainPage(ScaffoldKey: _key),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
