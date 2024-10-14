import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';
import '../View/mainPage/pages/profilePage/ProfileMainPageLogin.dart';
import '../help/PinCodeFields.dart';
import '../help/hive/localStorage.dart';
import '../model/login_api.dart';
import '../../help/globals.dart' as globals;

class PinCode extends StatefulWidget {
  var token;
  var phone;
  PinCode({Key? key,this.token,this.phone}) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> with SingleTickerProviderStateMixin {

  late TextEditingController inputController;
  var timerIsFinshed = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final CustomTimerController controller = CustomTimerController();
  final Color _accentColor = const Color(0xFF164CA2);


  void showDialogPin() async{
    await Future.delayed(const Duration(seconds: 3)).then((value){
      controller.start();
    });
  }



  @override
  void initState() {
    inputController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.start());
  }

  @override
  void dispose() {
   // inputController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "رمز التحقق"),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: ListView(
            children: [
              Align(
                alignment: const Alignment(0,-0.1),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 175.0,),
                      const Text("تحقق", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 25.0,),),
                      const SizedBox(height: 10.0,),
                      Text("تم ارسال رمز التفعيل الى الرقم\n${widget.phone}",textDirection: TextDirection.ltr,textAlign: TextAlign.center, style: const TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.normal, fontSize: 12.0),),

                      const SizedBox(height: 20.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('6-ارقام لتفعيل الحساب',style: TextStyle(fontSize: 15,color: Color(0xffc52278))),
                          Column(
                            children: [
                              CustomTimer(
                                controller: controller,
                                from: const Duration(minutes: 1),
                                to: const Duration(),
                                builder: (time) {
                                  return Text("${time.minutes}:${time.seconds}", style: const TextStyle(fontSize: 15,color: Color(0xffc52278)));
                                },
                                onFinish: (){
                                  setState(() {
                                    timerIsFinshed = true;
                                  });
                                },
                              ),
                            ],
                          )

                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: PinCodeFields(
                          length: 6,
                          fieldBorderStyle: FieldBorderStyle.Square,
                          responsive: false,
                          fieldHeight: 45,
                          fieldWidth: 45,
                          borderWidth: 1,
                          margin: const EdgeInsets.all(1),
                          activeBorderColor: const Color(0xffc52278),
                          activeBackgroundColor: const Color(0xffc52278).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                          keyboardType: TextInputType.number,
                          autoHideKeyboard: false,
                          autofocus: true,
                          controller: inputController,
                          fieldBackgroundColor: Colors.white,
                          borderColor: const Color(0xffc52278),
                          textStyle: TextStyle(fontSize: 30.0, fontFamily: "RobotoMono",fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.6)),
                          onComplete: (output) {
                            FocusScope.of(context).unfocus();
                           // print(output);
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      SizedBox(
                        width: 325,
                        height: 50,
                        child: MaterialButton(
                          elevation: 5.0,
                          onPressed: (){
                            Map pinMap = {
                              "code": inputController.text,
                              "token": widget.token
                            };
                            LoginApi(context).pinApi(pinMap: pinMap).then((value){
                              if(value != false){
                                globals.viewSearch = true;
                              }else{}
                            });
                          },
                          color: const Color(0xffc52278),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text("تحقق", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      !timerIsFinshed ?
                      Column(
                        children: const [],
                      ) : Column(
                        children: const [
                          SizedBox(height: 30.0,),
                          Text("لم تستلم رمز التفعيل ؟", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.normal, fontSize: 15.0,),),
                          SizedBox(height: 10.0,),
                          Text("اعادة الارسال", style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.bold, fontSize: 20.0,),),
                        ],
                      ),

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
