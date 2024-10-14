import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../help/globals.dart' as globals;
import '../../help/myprovider.dart';
import '../mainPage/pages/profilePage/OtherProfileMainPage.dart';
import '../../model/interest_api.dart';


class InterestedList extends StatefulWidget {
  const InterestedList({Key? key}) : super(key: key);

  @override
  State<InterestedList> createState() => _InterestedListState();
}

class _InterestedListState extends State<InterestedList> {
  final Color _accentColor = const Color(0xffc52278);
  List otherInterestList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInterest(context);
    });
  }

  getInterest(context){
    InterestApi(context).interestApi().then((value){
      if(value != false){
        setState((){
          otherInterestList = value["data"];
        });
      }else{}
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
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),

                          const Text("قائمة المهتمين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),

                          const Icon(Icons.menu,color: Colors.transparent,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Provider.of<AppProvide>(context).loading ? Container() : otherInterestList.isEmpty && !Provider.of<AppProvide>(context).loading ? RefreshIndicator(
            onRefresh: ()async => getInterest(context),
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
            onRefresh: ()async => getInterest(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: ListView.builder(
                itemCount: otherInterestList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Map newMap = otherInterestList[index];
                      newMap['id'] = newMap['userId'];
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return OtherProfileMainPage(otherProfileData: newMap,);
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
                            otherInterestList[index]["images"] == null ? const SizedBox(
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
                                  backgroundImage: NetworkImage(otherInterestList[index]["images"]),
                                  // child: ClipOval(
                                  //   child: Image(image: NetworkImage(otherInterestList[index]["images"]),fit: BoxFit.cover,),
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
                                Text("${otherInterestList[index]["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12.0,),),
                                Text("${otherInterestList[index]["countryName"]}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 10.0,),),
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
                                  title: Text('اضافة ${otherInterestList[index]["name"]} الى قائمة اهتمامي ؟',style: const TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        InterestApi(this.context).addToMyInterestApi(partnerId: otherInterestList[index]["userId"],name: otherInterestList[index]["name"]).then((value){
                                          if(value != false){
                                            WidgetsBinding.instance.addPostFrameCallback((_) => getInterest(this.context));
                                          }else{
                                            Navigator.of(context).pop();
                                          }
                                        }).whenComplete(() => Navigator.of(context).pop());
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.sports_handball,color: Colors.white,),
                                Text("اضافة الى قائمة اهتمامي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 10.0,),)
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
