import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/View/mainPage/pages/profilePage/OtherProfileMainPage.dart';
import 'package:zefaf/help/hive/localStorage.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../help/myprovider.dart';
import '../../../../model/home_api.dart';
import '../../widgets/coinWidget.dart';
import '../../widgets/userState.dart';


class UsersMainPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> ScaffoldKey;
  const UsersMainPage({Key? key,required this.ScaffoldKey}) : super(key: key);

  @override
  State<UsersMainPage> createState() => _UsersMainPageState();
}

class _UsersMainPageState extends State<UsersMainPage> {

  var selectedIndex = 1;
  List mainList = [];

  @override
  void initState() {
    super.initState();
    LocalStorage().getValue("gender") == 1 ? selectedIndex = 0 : LocalStorage().getValue("gender") == 2 ? selectedIndex = 1 : selectedIndex = 2;
    LocalStorage().setValue("globalGender",selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMain(context,LocalStorage().getValue("gender"));
    });
  }



  getMain(context,gender){
    HomeApi(context).mainApi(gender: gender).then((value){
      if(value != false){
        setState((){
          mainList = value["data"];
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
        toolbarHeight: 100,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Image(image: AssetImage("assets/logo/logo.png"),height: 30,color: Colors.white,),
                      CoinWidget(),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap:(){
                            widget.ScaffoldKey.currentState!.openDrawer();
                          },
                          child: const Icon(Icons.menu,color: Colors.white,)),
                      ToggleSwitch(
                        initialLabelIndex: selectedIndex,
                        activeBgColor: const [Color(0xffc52278)],
                        inactiveBgColor: Colors.white,
                        labels: const ['ذكور', 'اناث', 'عشوائي'],
                        onToggle: (index) {
                          if(selectedIndex != index){
                            setState((){
                              selectedIndex = index!;
                              LocalStorage().setValue("globalGender",selectedIndex == 0 ? 1 : selectedIndex == 1 ? 2 : 3);
                              getMain(context,selectedIndex == 0 ? 1 : selectedIndex == 1 ? 2 : 3);
                            });
                          }else{}
                        },
                      ),
                      const Icon(Icons.menu,color: Colors.transparent,),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Provider.of<AppProvide>(context).loading ? Container() : mainList.isEmpty && !Provider.of<AppProvide>(context).loading ? RefreshIndicator(
        onRefresh: ()async => getMain(context,selectedIndex == 0 ? 1 : selectedIndex == 1 ? 2 : 3),
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
        onRefresh: ()async => getMain(context,selectedIndex == 0 ? 1 : selectedIndex == 1 ? 2 : 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(mainList.length, (index) => GestureDetector(
                  onTap: (){
                    mainList[index]["user_status_id"] == 2 ? null : Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) {
                          return OtherProfileMainPage(otherProfileData: mainList[index],from: 2,);
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
                  child: Container(
                      height: 175,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          )
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Positioned(
                            bottom: 30,
                            child: Opacity(
                                opacity: 0.05,
                                child: Image(image: AssetImage("assets/logo/logo.png"),height: 70,)),
                          ),
                         ! mainList[index]["trusted"] ? Container() : const Positioned(
                            bottom: 10,
                            left: 15,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.lightBlue,
                                child: Icon(Icons.check,color: Colors.white,size: 17,),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              SizedBox(
                                child: mainList[index]["images"] == null ? CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: const Color(0xffc52278),
                                  child: CircleAvatar(
                                    radius: 38.0,
                                    backgroundColor: const Color(0xffc52278),
                                    backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: UserState(id: mainList[index]["id"],size: 15.0,radius: 10.0),
                                    ),
                                  ),
                                )
                                    :
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundColor: const Color(0xffc52278),
                                  child: CircleAvatar(
                                    radius: 38.0,
                                    backgroundColor: const Color(0xffc52278),
                                    backgroundImage: NetworkImage(mainList[index]["images"]),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: UserState(id: mainList[index]["id"],size: 15.0,radius: 10.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text("${mainList[index]["userName"]}", style: const TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 15.0,),),
                              Text("العمر : ${mainList[index]["age"]}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                              Text("${mainList[index]["countryName"]}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                              const SizedBox(height: 10,),
                            ],
                          ),
                        ],
                      )
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
