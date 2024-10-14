import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zefaf/auth/register.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';
import 'package:zefaf/auth/widgets/iso.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import '../../help/globals.dart' as globals;
import '../View/mainPage/AppMainPage.dart';
import '../help/GetStorage.dart';
import '../model/login_api.dart';
import 'FastRegister.dart';
import 'forgetUserPassword/MainForgetPassword.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  var viewPassword = true;
  final Color _accentColor = const Color(0xFF164CA2);
  final CustomPopupMenuController _controller1 = CustomPopupMenuController();
  final CustomPopupMenuController _controller2 = CustomPopupMenuController();
  var phoneError = false;
  var password = false;
  late List<ItemModel> menuItems1;
  late List<ItemModel> menuItems2;


  @override
  void initState() {
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    // phoneNumberController = TextEditingController(text: "1111111111");
    // passwordController = TextEditingController(text: "111111");
    super.initState();
    permissionHandler(context);
  }












  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }




  permissionHandler(context)async{
    if (await Permission.camera.isDenied) {
      openAlertBox(context);
    }else if (await Permission.storage.isDenied) {
      openAlertBox(context);
    }else if (await Permission.microphone.isDenied) {
      openAlertBox(context);
    }
  }



  openAlertBox(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text("صلاحيات الوصول", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
                    ],
                  ),




                  const SizedBox(height: 10.0),
                  const Divider(color: Colors.grey, height: 4.0),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Text("بالضغط على زر موافق سوف تقوم بتفعيل صلاحيات المطلوبة ادناه , يسمح لك بأجراء المكالمات الصوتية والمرئية وتغير صورة الملف الشخصي.",textAlign: TextAlign.justify,textDirection: TextDirection.rtl, style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 5.0),



                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: const [
                        ListTile(
                          title: Text("صلاحية الكاميرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم اثناء المكالمات و تغير صورة الملف الشخصي."),
                          leading: Icon(Icons.camera,color: Color(0xffc52278),),
                        ),
                        ListTile(
                          title: Text("صلاحية الذاكرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم في تغير صورة الملف الشخصي."),
                          leading: Icon(Icons.memory,color: Color(0xffc52278),),
                        ),
                        ListTile(
                          title: Text("صلاحية الكاميرة", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                          subtitle: Text("يستخدم اثناء المكالمات الصوتية والمرئية."),
                          leading: Icon(Icons.mic,color: Color(0xffc52278),),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 10.0),

                  GestureDetector(
                    onTap: ()async{
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.camera,
                        Permission.storage,
                        Permission.microphone,
                      ].request();
                      if (await Permission.storage.isPermanentlyDenied || await Permission.storage.isDenied) {
                        openAppSettings();
                      }else if (await Permission.camera.isPermanentlyDenied || await Permission.camera.isDenied) {
                        openAppSettings();
                      }else if (await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) {
                        openAppSettings();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffc52278),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: const Text("موافق", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }





  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "تسجيل الدخول"),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      const SizedBox(height: 30.0,),
                      const Text("اهلا بك مجدداً", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 25.0,),),
                      const SizedBox(height: 10.0,),
                      const Text("ادخل رقم الهاتف للأستمرار", textAlign: TextAlign.center, style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.normal, fontSize: 12.0),),
                      const SizedBox(height: 20.0,),

                      /// Phone
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Card(
                          color: const Color(0xffc52278),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  onTap: (){
                                    setState(() {
                                      phoneError = false;
                                    });
                                  },
                                  controller: phoneNumberController,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  onChanged: (x){
                                    phoneNumberController.text.startsWith("0") ? phoneNumberController.clear() : null;
                                  },
                                  cursorColor: const Color(0xFF26242e),
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                                  validator: (value){
                                    if(value!.isEmpty || value.length < 8){
                                      setState(() {
                                        menuItems2 = [
                                          ItemModel('خطأ في رقم الهاتف', Icons.verified_user_outlined),
                                        ];
                                        phoneError = true;
                                      });
                                      return "";
                                    }else{}
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintStyle: const TextStyle(fontSize: 12,),
                                      errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                      prefixIcon: phoneError ? CustomPopupMenu(
                                          menuBuilder: () => ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Container(
                                              color: const Color(0xFF4C4C4C),
                                              child: IntrinsicWidth(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: menuItems2.map((item) => GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: () {
                                                      _controller1.hideMenu();
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
                                          controller: _controller1,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            child: const SizedBox(
                                                height: 17,
                                                width: 17,
                                                child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                          )) : null,
                                      suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                      hintText: 'رقم الهاتف',
                                      counterText: "",
                                      fillColor: const Color(0xffffffff).withOpacity(0.5),
                                      filled: true
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                child: GestureDetector(
                                  onTap: (){
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:  [
                                      Text(globals.dialCodeMyIso,textDirection: TextDirection.ltr,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),strutStyle: StrutStyle(forceStrutHeight: true,height: 1,)),
                                      const SizedBox(width: 5),
                                      Image(
                                        height: 15,
                                        image: globals.flagMyIso,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),


                      /// Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
                        child: Card(
                          color: const Color(0xffc52278),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              onTap: (){
                                passwordController.selection = TextSelection.fromPosition(TextPosition(offset: passwordController.text.length));
                                setState(() {
                                  password = false;
                                });
                              },
                              controller: passwordController,
                              textAlignVertical: TextAlignVertical.center,
                              obscureText: viewPassword,
                              cursorColor: const Color(0xFF26242e),
                              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636),),
                              validator: (value){
                                if(value!.isEmpty || value.length < 6){
                                  setState(() {
                                    menuItems1 = [
                                      ItemModel('خطأ, يجب ان لا يقل الرمز السري عن 6 احرف وارقام', Icons.verified_user_outlined),
                                    ];
                                    password = true;
                                  });
                                  return "";
                                }else{}
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(fontSize: 12,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          viewPassword = !viewPassword;
                                        });
                                      },
                                      child: Icon(viewPassword ? Icons.password : Icons.remove_red_eye_outlined, color: const Color(0xFF26242e),)),
                                  hintText: 'رمز السري',
                                  fillColor: const Color(0xffffffff).withOpacity(0.5),
                                  errorStyle: const TextStyle(height: 0.001,color: Colors.transparent),
                                  prefixIcon: password ? CustomPopupMenu(
                                      menuBuilder: () => ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color: const Color(0xFF4C4C4C),
                                          child: IntrinsicWidth(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: menuItems1.map((item) => GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  _controller2.hideMenu();
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
                                      controller: _controller2,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: const SizedBox(
                                            height: 17,
                                            width: 17,
                                            child: Image(image: AssetImage("assets/icons/error.gif"),)),
                                      )) : null,
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) {
                                return const MainForgetPassword();
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 0),
                            child: Text('نسيت كلمة المرور ؟',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,letterSpacing: 0,color: Color(0xFF26242e))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width *.45,
                              height: 50,
                              child:  MaterialButton(
                                elevation: 5.0,
                                onPressed: (){
                                  if(_formState.currentState!.validate()){
                                    Map loginMap = {
                                      "mobile": "0${phoneNumberController.text}",
                                      "countryId": globals.nameMyIsoId,
                                      "password": passwordController.text
                                    };
                                    LoginApi(context).loginApi(loginMap: loginMap).then((value){
                                      if(value != false){
                                        globals.viewSearch = true;
                                      }else{}
                                    });
                                  }else{}
                                },
                                color: const Color(0xffc52278),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text('تسجيل الدخول', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            /// Button
                            SizedBox(
                              width: Get.width * .35,
                              height: 50,
                              child:  MaterialButton(
                                elevation: 0.0,
                                onPressed: box.read('loginBtn') != null ? (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) {
                                        return const AppMainPage();
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
                                } : (){
                                  Get.to(FastRegister(from: 'login',));
                                },
                                color: Colors.grey.shade300,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text('تسجيل سريع', style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),



                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('ليس لديك حساب ؟',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xffc52278))),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onLongPress: (){
                                  // setState((){
                                  //   phoneNumberController.text = "01028822983";
                                  //   passwordController.text = "123456";
                                  // });
                                },
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1, animation2) {
                                          return Register(from: "login");
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
                                  child: const Text('اشترك معنا',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 0,color: Color(0xffc52278))))
                            ],
                          ),
                        ),
                      ),

                      //Btn(btnFunction: (){}, btnText: 'تسجيل الدخول',)

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class ItemModel {
  String title;
  IconData icon;
  ItemModel(this.title, this.icon);
}