import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zefaf/View/mainPage/pages/chat/Chat.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../help/hive/localStorage.dart';
import '../../../../model/userSettings_api.dart';
import '../../../../model/home_api.dart';
import '../../widgets/coinWidget.dart';

class SettingsMainPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> ScaffoldKey;
  const SettingsMainPage({Key? key,required this.ScaffoldKey}) : super(key: key);

  @override
  State<SettingsMainPage> createState() => _SettingsMainPageState();
}

class _SettingsMainPageState extends State<SettingsMainPage> {
  var isSwitched1 = false;
  var isSwitched2 = false;
  var isSwitched3 = false;
  var isSwitched4 = false;
  var isSwitched5 = false;
  var isSwitched6 = false;
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfile(context);
    });
  }

  getProfile(context){
    HomeApi(context).mainApiCall(id: LocalStorage().getValue("userID")).then((value){
      if(value != false){
        setState((){
          value["data"]["user_status_id"] == null ? null : selectedIndex = value["data"]["user_status_id"];
          isSwitched1 = value["data"]["reciveSms"];
          isSwitched2 = value["data"]["reciveVideo"];
          isSwitched3 = value["data"]["reciveCall"];
          isSwitched4 = value["data"]["viewSearch"];
          isSwitched5 = value["data"]["addFav"];
          isSwitched6 = value["data"]["viewAccount"];
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
                      Row(
                        children: [
                          GestureDetector(
                              onTap:(){
                                widget.ScaffoldKey.currentState!.openDrawer();
                              },
                              child: const Icon(Icons.menu,color: Colors.white,)),
                          const SizedBox(width: 5,),
                          const Text("الاعدادات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                        ],
                      ),

                      const CoinWidget(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleSwitch(
                  initialLabelIndex: selectedIndex,
                  minWidth: MediaQuery.of(context).size.width / 3 - 20,
                  activeBgColor: const [Color(0xffc52278)],
                  inactiveBgColor: Colors.white,
                  labels: const ['فعال', 'دخول مخفي', 'عدم إزعاج'],
                  onToggle: (index) {
                    if(index == selectedIndex){

                    }else{
                      setState((){
                        selectedIndex = index!;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Switch(
                  value: isSwitched1,
                  onChanged: (value){
                    setState(() {
                      isSwitched1 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("استقبال الرسائل", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSwitched2,
                  onChanged: (value){
                    setState(() {
                      isSwitched2 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("استقبال اتصال فديو", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSwitched3,
                  onChanged: (value){
                    setState(() {
                      isSwitched3 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("استقبال اتصال صوت", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSwitched4,
                  onChanged: (value){
                    setState(() {
                      isSwitched4 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("ظهور في نتائج البحث", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSwitched5,
                  onChanged: (value){
                    setState(() {
                      isSwitched5 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("امكانية اضافتي الى قائمة الاهتمام", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: isSwitched6,
                  onChanged: (value){
                    setState(() {
                      isSwitched6 = value;
                    });
                  },
                  activeTrackColor: const Color(0xffc52278),
                  activeColor: Colors.amber,
                  inactiveThumbColor: Colors.black87,
                ),
                const Text("اظهار تفاصيل حسابي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
              ],
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 300,
              height: 50,
              child:  MaterialButton(
                elevation: 5.0,
                onPressed: (){
                  UserSettings(context).mySetting(profileSetting: {
                    "user_status_id": selectedIndex,
                    "reciveSms": isSwitched1,
                    "reciveVideo": isSwitched2,
                    "reciveCall": isSwitched3,
                    "viewSearch": isSwitched4,
                    "addFav": isSwitched5,
                    "viewAccount": isSwitched6,
                  }).then((value){
                    if(value != false){
                      globals.socket.emit("myState",[{
                        "onlineId": selectedIndex
                      }]);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        getProfile(context);
                      });
                    }
                  });
                },
                color: const Color(0xffc52278),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('حفظ التغيرات', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
