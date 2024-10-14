import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../help/globals.dart' as globals;
import '../../help/myprovider.dart';
import '../mainPage/pages/profilePage/OtherProfileMainPage.dart';
import '../../model/interest_api.dart';
import '../../model/blockedUsers_api.dart';
import '../../model/home_api.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({Key? key}) : super(key: key);

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  final Color _accentColor = const Color(0xffc52278);
  List blockedUsersLs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBlockedUsers(context);
    });
  }

  getBlockedUsers(context){
    BlockedUsersApi(context).getBlockedUsersApi().then((value){
      setState((){
        blockedUsersLs = value["data"];
      });
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
                        children:  [
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),

                          const Text("قائمة المحضورين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),

                          const Icon(Icons.menu,color: Colors.transparent,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Provider.of<AppProvide>(context).loading ? Container() : blockedUsersLs.isEmpty && !Provider.of<AppProvide>(context).loading ? RefreshIndicator(
            onRefresh: ()async => getBlockedUsers(context),
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
                          titleTextStyle: Theme.of(context).typography.dense.bodyMedium?.copyWith(fontFamily: 'Tajawal',color: const Color(0xff9da9c7)),
                          subtitleTextStyle: Theme.of(context).typography.dense.bodyMedium?.copyWith(fontFamily: 'Tajawal',color: const Color(0xffabb8d6))
                      ),
                    )
                ),
              ),
            ),
          ) : RefreshIndicator(
            onRefresh: ()async => getBlockedUsers(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: ListView.builder(
                itemCount: blockedUsersLs.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Map newMap = blockedUsersLs[index];
                      newMap['id'] = newMap['partnerId'];
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return OtherProfileMainPage(otherProfileData: newMap,from: 1,);
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
                            blockedUsersLs[index]["images"] == null ? const SizedBox(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Color(0xffc52278),
                                child: CircleAvatar(
                                  radius: 23.0,
                                  backgroundColor: Color(0xffc52278),
                                  child: ClipOval(
                                    child: Image(image: AssetImage("assets/icons/userEmptyImage.png"),fit: BoxFit.cover,),
                                  ),
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
                                  backgroundImage: NetworkImage(blockedUsersLs[index]["images"]),
                                  // child: ClipOval(
                                  //   child: Image(image: NetworkImage(interestList[index]["images"]),fit: BoxFit.cover,),
                                  // ),
                                  //backgroundImage: NetworkImage('https://3denerji.com/wp-content/uploads/2019/02/person2-1.jpg'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${blockedUsersLs[index]["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                                Text("${blockedUsersLs[index]["countryName"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('مسح ${blockedUsersLs[index]["name"]} من قائمة الحضر ؟',style: const TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        HomeApi(context).blockUser(partnerId: blockedUsersLs[index]["partnerId"]).then((value){
                                          if(value != false){
                                            WidgetsBinding.instance.addPostFrameCallback((_) async=> await getBlockedUsers(this.context));
                                          }else{
                                            Navigator.of(context).pop();
                                          }
                                        }).whenComplete(() => Navigator.of(context).pop());
                                        setState((){});
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
                                  // content: const Text('هل انت متأكد من مسح العنوان ؟',style: TextStyle(fontFamily: "Tajawal",color: Color(0xFF164CA2))),
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("❌"+" "+"ازالة من قائمة المحضورين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 10.0,),),
                              ],
                            ),
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
        ),
      ],
    );
  }
}
