import 'package:flutter/material.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';
import '../mainPage/pages/profilePage/OtherProfileMainPage.dart';
import '../../model/stories_api.dart';

class SuccessStories extends StatefulWidget {
  const SuccessStories({Key? key}) : super(key: key);

  @override
  State<SuccessStories> createState() => _SuccessStoriesState();
}

class _SuccessStoriesState extends State<SuccessStories> {

  List storiesList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStories(context);
    });
  }

  getStories(context){
    Stories(context).storiesApi().then((value){
      if(value != false){
        setState((){
          storiesList = value["data"];
        });
      }else{}
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        AppBarWidget(barText: "قصص النجاح"),
        Positioned(
          top: MediaQuery.of(context).size.height * .20,
          child: const Image(image: NetworkImage("https://i.pinimg.com/originals/58/cc/71/58cc7199f7dbad559309b985c072ab54.png"),height: 200,),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .37),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                //   child: Text("عدد حالات النجاح 33453 حالة", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("نهنئ جميع المشتركين الذين وفقهم الله بإيجاد نصفهم الاخر عبر هذا التطبيق ونتمنى لهم حياة سعيد , ونرجو من الله التوفيق لجميع الأعضاء في ليالينا.",textAlign: TextAlign.center,style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 15.0,),),
                ),
                const SizedBox(height: 20,),
                storiesList.isEmpty ? Container() : Column(
                  children: List.generate(storiesList.length, (index) => Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (context, animation1, animation2) {
                          //       return OtherProfileMainPage(otherProfileData: storiesList[index],from: 3,);
                          //     },
                          //     transitionsBuilder: (context, animation1, animation2, child) {
                          //       return FadeTransition(
                          //         opacity: animation1,
                          //         child: child,
                          //       );
                          //     },
                          //     transitionDuration: const Duration(microseconds: 250),
                          //   ),
                          // );
                        },
                        child: SizedBox(
                          child: storiesList[index]["image"] == null ? CircleAvatar(
                            radius: 40.0,
                            backgroundColor: const Color(0xffc52278),
                            child: CircleAvatar(
                              radius: 38.0,
                              backgroundColor: const Color(0xffc52278),
                              backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: storiesList[index]["trusted"] ? CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: 12.0,
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: storiesList[index]["trusted"] ? Colors.white : Colors.transparent,
                                  ),
                                ) : Container(),
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
                              backgroundImage: NetworkImage(storiesList[index]["image"]),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: storiesList[index]["trusted"] ? CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  radius: 12.0,
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: storiesList[index]["trusted"] ? Colors.white : Colors.transparent,
                                  ),
                                ) : Container(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          const SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${storiesList[index]["name"]}", style: const TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 15.0,),),
                              const SizedBox(width: 10,),
                              Text("${storiesList[index]["age"]} سنة", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text("${storiesList[index]["text"]}", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
        ),
      ],
    );
  }
}




