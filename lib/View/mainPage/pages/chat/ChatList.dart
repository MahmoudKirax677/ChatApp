import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:provider/provider.dart';
import 'package:zefaf/View/mainPage/pages/chat/Chat.dart';
import 'package:zefaf/View/mainPage/pages/chat/widgets/messageNum.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../help/hive/localStorage.dart';
import '../../../../help/myprovider.dart';
import '../profilePage/OtherProfileMainPage.dart';
import '../../../../model/chat_api.dart';
import '../../../../model/home_api.dart';
import '../../widgets/coinWidget.dart';
import '../../widgets/userState.dart';
class ChatList extends StatefulWidget {
  final GlobalKey<ScaffoldState> ScaffoldKey;
  const ChatList({Key? key,required this.ScaffoldKey}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final Color _accentColor = const Color(0xffc52278);
  List chatList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCahtUsers(context);
    });
  }

  Future getCahtUsers(context)async{
    await ChatApi(context).getCahtUsers().then((value){
      if(value != false){
        setState((){
          chatList = value["data"];
        });
      }else{}
    });
  }


  routeToChat(id,context)async{
    await HomeApi(context).mainApiCall3(id: id).then((value){
      if(value != false){
      //  print("----------------------------");
      //  print(value["data"]);
        value["data"]["user_status_id"] == 2 ? AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning) : value["data"]["reciveSms"] ?

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) {
                  return ChatPage(otherProfileData: value["data"],from: 1,);
                },
                transitionsBuilder: (context, animation1, animation2,
                    child) {
                  return FadeTransition(
                    opacity: animation1,
                    child: child,
                  );
                },
                transitionDuration: const Duration(microseconds: 250),
              ),
            ).then((xx){
              setState((){
                LocalStorage().setValue("${value["data"]["id"]}",null);
              });
            }) : AlertController.show("خطأ", "لا يمكنك من مراسلة ${value["data"]["name"]} !", TypeAlert.warning);
        }
    });
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
                              onTap:(){
                                widget.ScaffoldKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.menu,color: Colors.white,)),

                          const Text("المحادثات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),

                          const CoinWidget(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Provider.of<AppProvide>(context).loading ? Container() : chatList.isEmpty && !Provider.of<AppProvide>(context).loading ? RefreshIndicator(
            onRefresh: ()async => getCahtUsers(context),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                    child: SizedBox(
                      height: 500,
                      width:350,
                      child: EmptyWidget(
                          image : null,
                          packageImage: PackageImage.Image_1,
                          title: 'لا يوجد بيانات',
                          //subTitle: 'انت غير مسجل دخولك الى التطبيق',
                          titleTextStyle: Theme.of(context).typography.dense.bodyText1?.copyWith(fontFamily: 'Tajawal',color: const Color(0xff9da9c7)),
                          subtitleTextStyle: Theme.of(context).typography.dense.bodyText2?.copyWith(fontFamily: 'Tajawal',color: const Color(0xffabb8d6))
                      ),
                    )
                ),
              ),
            ),
          ) : RefreshIndicator(
            onRefresh: ()async => getCahtUsers(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (BuildContext context, int index) {
                  return chatList.isEmpty ? Container() : GestureDetector(
                    onTap: ()async{
                      routeToChat(chatList[index]["id"],context);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                chatList[index]["images"] == null ? SizedBox(
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: const Color(0xffc52278),
                                    child: CircleAvatar(
                                      radius: 23.0,
                                      backgroundColor: const Color(0xffc52278),
                                      backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: chatList[index]["id"],size: 10.0,radius: 6.0),
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
                                      backgroundImage: NetworkImage(chatList[index]["images"]),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: chatList[index]["id"],size: 10.0,radius: 6.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${chatList[index]["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                                    Text("لون الشعر : ${chatList[index]["hairColor"]} |  لون العين : ${chatList[index]["eyeColor"]} \n الحالة المادية : ${chatList[index]["financialStatus"]} | الحالة الاجتماعية : ${chatList[index]["socialStatus"]}", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                                  ],
                                ),
                                MessageNum(id: "${chatList[index]["id"]}",)
                              ],
                            ),
                            // CircleAvatar(
                            //   backgroundColor: const Color(0xffc52278),
                            //   radius: 12,
                            //   child: Center(child: Text("${index+1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15.0,),strutStyle: const StrutStyle(height: 1.5),)),
                            // )
                          ],
                        ),
                        const SizedBox(height: 0,),
                        const Divider(color: Colors.white,),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
