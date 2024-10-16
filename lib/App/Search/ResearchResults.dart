import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/App/mainPage/pages/profilePage/OtherProfileMainPage.dart';
import '../../../../help/globals.dart' as globals;
import '../mainPage/widgets/userState.dart';




class ResearchResults extends StatefulWidget {
  List searchData = [];
  ResearchResults({Key? key,required this.searchData}) : super(key: key);

  @override
  State<ResearchResults> createState() => _ResearchResultsState();
}

class _ResearchResultsState extends State<ResearchResults> {
  final Color _accentColor = const Color(0xffc52278);

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),

                          const Text("نتائج البحث", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),

                          const Icon(Icons.menu,color: Colors.transparent,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(widget.searchData.length, (index) => widget.searchData[index]["user_status_id"] != 0 ? Container() : GestureDetector(
                    onTap: (){
                     widget.searchData[index]["user_status_id"] == 2 ? null : Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return OtherProfileMainPage(otherProfileData: widget.searchData[index],from: 2,);
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
                            ! widget.searchData[index]["trusted"] ? Container() : const Positioned(
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
                                  child: widget.searchData[index]["images"] == null ? CircleAvatar(
                                    radius: 40.0,
                                    backgroundColor: const Color(0xffc52278),
                                    child: CircleAvatar(
                                      radius: 38.0,
                                      backgroundColor: const Color(0xffc52278),
                                      backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: widget.searchData[index]["id"],size: 15.0,radius: 10.0),
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
                                      backgroundImage: NetworkImage(widget.searchData[index]["images"]),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: widget.searchData[index]["id"],size: 15.0,radius: 10.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text("${widget.searchData[index]["userName"]}", style: const TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 15.0,),),
                                Text("العمر : ${widget.searchData[index]["age"]}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                                Text("${widget.searchData[index]["countryName"]}", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12.0,),),
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
      ],
    );
  }
}
