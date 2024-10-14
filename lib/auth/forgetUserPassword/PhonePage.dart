import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../help/globals.dart' as globals;
import '../widgets/iso.dart';
import '../../model/login_api.dart';

class PhonePage extends StatefulWidget {
  final PageController pagecontroller;
  const PhonePage({Key? key,required this.pagecontroller}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  final CustomPopupMenuController _controller1 = CustomPopupMenuController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  var viewPassword = true;
  var phoneError = false;
  late List<ItemModel> menuItems1;


  @override
  void initState() {
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    phoneNumberController.dispose();
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    menuItems1 = [
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
                                              children: menuItems1.map((item) => GestureDetector(
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
                  const SizedBox(height: 35),


                  /// Button
                  SizedBox(
                    width: 300,
                    height: 50,
                    child:  MaterialButton(
                      elevation: 5.0,
                      onPressed: (){
                        if(_formState.currentState!.validate()){
                          LoginApi(context).forgetPasswordPhoneNumber(data: {
                            "countryId": globals.nameMyIsoId,
                            "mobile": "0${phoneNumberController.text}",
                          }).then((value){
                            if(value != false){
                              setState((){
                                globals.tokenForPin = value["access_token"];
                                globals.phoneForPin = "0${phoneNumberController.text}";
                              });
                              widget.pagecontroller.jumpToPage(1);
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
                        child: Text('ارسال رمز التفعيل', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ItemModel {
  String title;
  IconData icon;
  ItemModel(this.title, this.icon);
}