import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../help/globals.dart' as globals;
import '../widgets/iso.dart';
import '../../model/login_api.dart';

class ChangePassword extends StatefulWidget {
  final PageController pagecontroller;
  const ChangePassword({Key? key,required this.pagecontroller}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController newPasswordController;
  late TextEditingController passwordController;
  var viewPassword = true;

  @override
  void initState() {
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    newPasswordController.dispose();
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
                  const Text("ادخل رمز السري الجديد", textAlign: TextAlign.center, style: TextStyle(color: Color(0xffc52278), fontWeight: FontWeight.normal, fontSize: 12.0),),
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
                              controller: newPasswordController,
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorColor: const Color(0xFF26242e),
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                              validator: (value) => value!.isEmpty || value.length < 6 ? 'خطأ في الرمز السري' : null,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(fontSize: 12,),
                                  errorStyle: const TextStyle(height: 0.7,color: Colors.transparent),
                                  suffixIcon: const Icon(Icons.phone_enabled, color: Colors.transparent,),
                                  hintText: 'رمز السري',
                                  counterText: "",
                                  fillColor: const Color(0xffffffff).withOpacity(0.5),
                                  filled: true
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
                          LoginApi(context).newPassword(passwordMap: {
                            "token": globals.tokenForPin,
                            "password": newPasswordController.text,
                          }).then((value){
                            if(value != false){
                              Navigator.of(context).pop();
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
                        child: Text('تغيير الرمز', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
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
