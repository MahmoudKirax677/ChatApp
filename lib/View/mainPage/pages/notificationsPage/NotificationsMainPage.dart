import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../help/myprovider.dart';
import '../../../../model/notification_api.dart';
import '../../widgets/coinWidget.dart';
import '../profilePage/OtherProfileMainPage.dart';



class NotificationsMainPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> ScaffoldKey;
  const NotificationsMainPage({Key? key,required this.ScaffoldKey}) : super(key: key);

  @override
  State<NotificationsMainPage> createState() => _NotificationsMainPageState();
}

class _NotificationsMainPageState extends State<NotificationsMainPage> {

  List notificationList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getNotifications(context);
    });
  }

  getNotifications(context){
    NotificationApi(context).getNotifications().then((value){
      if(value != false){
        setState((){
          notificationList = value["data"];
        });
      }else{}
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                      const Text("الاشعارات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),

                      const CoinWidget(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Provider.of<AppProvide>(context).loading ? Container() : notificationList.isEmpty && !Provider.of<AppProvide>(context).loading ? RefreshIndicator(
        onRefresh: ()async => getNotifications(context),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Center(
                child: SizedBox(
                  height: 500,
                  width:350,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 200),
                    child: EmptyWidget(
                        image : null,
                        packageImage: PackageImage.Image_1,
                        title: 'لا يوجد بيانات',
                        //subTitle: 'انت غير مسجل دخولك الى التطبيق',
                        titleTextStyle: Theme.of(context).typography.dense.bodyText1?.copyWith(fontFamily: 'Tajawal',color: const Color(0xff9da9c7)),
                        subtitleTextStyle: Theme.of(context).typography.dense.bodyText2?.copyWith(fontFamily: 'Tajawal',color: const Color(0xffabb8d6))
                    ),
                  ),
                )
            ),
          ),
        ),
      ) : RefreshIndicator(
        onRefresh: ()async => getNotifications(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (BuildContext context, int index) {
            return notificationList[index]["type"] == 1 ? Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Color(0xffc52278),
                        child: CircleAvatar(
                          radius: 23.0,
                          backgroundColor: Colors.white,
                         // backgroundImage: AssetImage("assets/logo/logo.png"),
                          child: ClipOval(
                            child: Image(image: AssetImage("assets/logo/logo.png"),fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("ادارة تطبيق لياليا", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text("◽"+" "+"${notificationList[index]["title"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                      Text("🔸"+" "+"${notificationList[index]["body"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${notificationList[index]["time"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white,),
              ],
            )
            :
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) {
                      return OtherProfileMainPage(otherProfileData: notificationList[index]["user"],from: 2,);
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
              child: Column(
                children: [
                  Row(
                    children: [
                      notificationList[index]["user"]["images"] == null ? const SizedBox(
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color(0xffc52278),
                          child: CircleAvatar(
                            radius: 23.0,
                            backgroundColor: Color(0xffc52278),
                            backgroundImage: AssetImage("assets/icons/userEmptyImage.png"),
                            //backgroundImage: NetworkImage('https://3denerji.com/wp-content/uploads/2019/02/person2-1.jpg'),
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
                            backgroundImage: NetworkImage("${notificationList[index]["user"]["images"]}"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("${notificationList[index]["user"]["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                          Text("${notificationList[index]["user"]["countryName"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("◽"+" "+"${notificationList[index]["title"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                        Text("🔸"+" "+"${notificationList[index]["body"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${notificationList[index]["time"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white,),
                ],
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}
