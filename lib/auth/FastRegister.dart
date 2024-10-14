import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefaf/auth/pinCode.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';
import 'package:zefaf/auth/widgets/iso.dart';
import 'package:advanced_icon/advanced_icon.dart';
import '../../help/globals.dart' as globals;
import 'login.dart';
import '../model/login_api.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class FastRegister extends StatefulWidget {
  var from;
  FastRegister({Key? key,this.from}) : super(key: key);

  @override
  State<FastRegister> createState() => _FastRegisterState();
}

class _FastRegisterState extends State<FastRegister> {

  var link = "http://layalinachat.com/termDetails/%D8%B3%D9%8A%D8%A7%D8%B3%D9%8A%D8%A9%20%D8%A7%D9%84%D8%AE%D8%B5%D9%88%D8%B5%D9%8A%D8%A9";
  final CustomPopupMenuController _controller1 = CustomPopupMenuController();
  final CustomPopupMenuController _controller2 = CustomPopupMenuController();
  final CustomPopupMenuController _controller3 = CustomPopupMenuController();
  final CustomPopupMenuController _controller4 = CustomPopupMenuController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  //late TextEditingController password2Controller;
  //late TextEditingController regionController;
  var viewPassword = true;
  var viewPassword2 = true;
  final Color _accentColor = const Color(0xFF164CA2);
  List roleTypes = [1,2];
  List roleTypesName = ["ذكر","انثى"];
  var selected = 0;
  var phoneError = false;
  var password = false;
  var firstName = false;
  var lastName = false;
  late List<ItemModel> menuItems1;
  late List<ItemModel> menuItems2;
  late List<ItemModel> menuItems3;
  late List<ItemModel> menuItems4;
  var _state = true;

  @override
  void initState() {
   // phoneNumberController = TextEditingController(text: "05454880902");
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState((){
        _state = false;
      });
    });
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "تسجيل سريع"),
        Scaffold(
          backgroundColor: Colors.transparent,
          //resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // const SizedBox(height: 150.0,),
                      // const Text("حساب جديد", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 25.0,),),
                      // const SizedBox(height: 10.0,),
                      // const Text("يرجى ملئ جميع المعلومات المطلوبة لانشاء حساب", textAlign: TextAlign.center, style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.normal, fontSize: 12.0),),
                      // const SizedBox(height: 20.0,),



                      Form(
                        key: _formState,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Card(
                                   color: const Color(0xffc52278),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        onTap: (){
                                          setState(() {
                                            firstName = false;
                                          });
                                        },
                                        controller: firstNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: const Color(0xFF26242e),
                                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            setState(() {
                                              menuItems3 = [
                                                ItemModel('خطأ في الاسم الاول', Icons.verified_user_outlined),
                                              ];
                                              firstName = true;
                                            });
                                            return "";
                                          }else{}
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(fontSize: 12,),
                                            errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                            prefixIcon: firstName ? CustomPopupMenu(
                                                menuBuilder: () => ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                    color: const Color(0xFF4C4C4C),
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: menuItems3.map((item) => GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            _controller3.hideMenu();
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(item.icon, size: 15, color: Colors.white),
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.only(left: 10),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pressType: PressType.singleClick,
                                                verticalMargin: -17,
                                                controller: _controller3,
                                                child: Container(
                                                  padding: const EdgeInsets.all(3),
                                                  child: const SizedBox(
                                                      height: 12,
                                                      width: 12,
                                                      child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                                )) : null,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                            hintText: 'الاسم الاول',
                                            fillColor: const Color(0xffffffff).withOpacity(0.5),
                                            filled: true
                                        ),
                                      ),
                                    ),
                                  ),


                                  const SizedBox(height: 10),




                                  Card(
                                    color: const Color(0xffc52278),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        onTap: (){
                                          setState(() {
                                            lastName = false;
                                          });
                                        },
                                        controller: lastNameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        cursorColor: const Color(0xFF26242e),
                                        style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            setState(() {
                                              menuItems4 = [
                                                ItemModel('خطأ في الاسم الاخير', Icons.verified_user_outlined),
                                              ];
                                              lastName = true;
                                            });
                                            return "";
                                          }else{}
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(fontSize: 12,),
                                            errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                            prefixIcon: lastName ? CustomPopupMenu(
                                                menuBuilder: () => ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                    color: const Color(0xFF4C4C4C),
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: menuItems4.map((item) => GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            _controller4.hideMenu();
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(item.icon, size: 15, color: Colors.white),
                                                                Expanded(
                                                                  child: Container(
                                                                    margin: const EdgeInsets.only(left: 10),
                                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                                    child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                pressType: PressType.singleClick,
                                                verticalMargin: -17,
                                                controller: _controller4,
                                                child: Container(
                                                  padding: const EdgeInsets.all(3),
                                                  child: const SizedBox(
                                                      height: 12,
                                                      width: 12,
                                                      child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                                )) : null,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                            hintText: 'الاسم الاخير',
                                            fillColor: const Color(0xffffffff).withOpacity(0.5),
                                            filled: true
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: Get.width *.85,
                              height: 50,
                              child:  MaterialButton(
                                elevation: 0,
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) {
                                        return const Countries();
                                      },
                                      transitionsBuilder: (context, animation1, animation2, child) {
                                        return FadeTransition(
                                          opacity: animation1,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(microseconds: 250),
                                    ),
                                  ).then((value){
                                    setState((){});
                                  });
                                },
                                color: Colors.grey.shade300,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('اختار البلد', style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:  [
                                          Text(globals.dialCodeMyIso,textDirection: TextDirection.ltr,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Colors.black),strutStyle: const StrutStyle(forceStrutHeight: true,height: 1,)),
                                          const SizedBox(width: 5),
                                          Image(
                                            height: 15,
                                            image: globals.flagMyIso,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),




                      const SizedBox(height: 20),





                      Padding(
                        padding: const EdgeInsets.only(right: 0,top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: (){
                                setState(() {
                                  _state = !_state;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: AdvancedIcon(
                                  secondaryIcon: Icons.add, //change this icon as per your requirement.
                                  icon: Icons.check, //change this icon as per your requirement.
                                  state: !_state ? AdvancedIconState.secondary : AdvancedIconState.primary,
                                  secondaryColor: Colors.transparent,
                                  size: 18,
                                  effect: AdvancedIconEffect.bubbleFade, //change effect as per your requirement.
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'اوافق على ',
                                    style: const TextStyle(color: Colors.black54,fontFamily: "Tajawal",fontSize: 12),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      setState(() {
                                        _state = !_state;
                                      });
                                    },
                                  ),
                                  TextSpan(
                                      text: 'الشروط والأحكام وسياسة الخصوصية',
                                      style: TextStyle(color: _accentColor,fontFamily: "Tajawal",fontSize: 12),
                                       recognizer:  TapGestureRecognizer()..onTap = () {
                                         launch(link, forceWebView: false, forceSafariVC: false);
                                       }
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 20),



                      SizedBox(
                        width: 300,
                        height: 50,
                        child:  MaterialButton(
                          elevation: 5.0,
                          onPressed: (){
                            FocusScope.of(context).unfocus();
                            if(_formState.currentState!.validate()){

                              if(_state){
                                Map registerMap = {
                                  "userName": "${firstNameController.text} ${lastNameController.text}",
                                  "countryId": globals.nameMyIsoId
                                };
                                LoginApi(context).fastRegisterApi(registerMap: registerMap).then((value){
                                  if(value != false){

                                  }else{}
                                });
                              }else{
                                AlertController.show("خطأ", "يرجى الموافقة على الشروط والأحكام وسياسة الخصوصية", TypeAlert.warning);
                              }



                            }else{

                            }
                          },
                          color: const Color(0xffc52278),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text('تسجيل حساب سريع', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),



                      const SizedBox(height: 30.0,),


                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('بضغطك على انشاء الحساب فأنت توافق على',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,letterSpacing: 0,color: Colors.white)),
                              const SizedBox(width: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('سياسة الخصوصية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,letterSpacing: 0,color: Colors.white)),
                                  Text(' & ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,letterSpacing: 0,color: Colors.white)),
                                  Text('الشروط والاحكام',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,letterSpacing: 0,color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),



                    ],
                  )
                ],
              ),
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
