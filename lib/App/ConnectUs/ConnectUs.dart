import 'package:flutter/material.dart';
import '../../model/contact_api.dart';
import 'package:zefaf/auth/widgets/authAppBar.dart';

class ConnectUs extends StatefulWidget {
  const ConnectUs({Key? key}) : super(key: key);

  @override
  State<ConnectUs> createState() => _ConnectUsState();
}

class _ConnectUsState extends State<ConnectUs> {


  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController emailTitleController;
  late TextEditingController emailTextController;



  @override
  void initState() {
    emailController = TextEditingController();
    emailTitleController = TextEditingController();
    emailTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailTitleController.dispose();
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "تواصل معنا"),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [

                Form(
                  key: _formState,
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
                        child: Card(
                          color: const Color(0xffc52278),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: emailController,
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorColor: const Color(0xFF26242e),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                              validator: (input) => input!.isValidEmail() ? null : 'خطأ في البريد الالكتروني',
                             // validator: (value) => value!.isEmpty || value.length < 8 ? 'خطأ في البريد الالكتروني' : null,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(fontSize: 12,),
                                  errorStyle: const TextStyle(height: 1.2,color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  suffixIcon: const Icon(Icons.email_outlined, color: Color(0xFF26242e),),
                                  hintText: 'البريد الالكتروني',
                                  fillColor: const Color(0xffffffff).withOpacity(0.5),
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
                        child: Card(
                          color: const Color(0xffc52278),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: emailTitleController,
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorColor: const Color(0xFF26242e),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                              validator: (value) => value!.isEmpty || value.length < 3 ? 'خطأ في عنوان الرسالة' : null,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(fontSize: 12,),
                                  errorStyle: const TextStyle(height: 1.2,color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  suffixIcon: const Icon(Icons.title, color: Color(0xFF26242e),),
                                  hintText: 'عنوان الرسالة',
                                  fillColor: const Color(0xffffffff).withOpacity(0.5),
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 0),
                        child: Card(
                          color: const Color(0xffc52278),
                          child: SizedBox(
                            //height: 50,
                            child: TextFormField(
                              controller: emailTextController,
                              textAlignVertical: TextAlignVertical.bottom,
                              cursorColor: const Color(0xFF26242e),
                              keyboardType: TextInputType.text,
                              minLines: 3,
                              maxLines: 3,
                              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 0,color: Color(0xff363636)),
                              validator: (value) => value!.isEmpty || value.length < 8 ? 'خطأ في نص الرسالة' : null,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(fontSize: 12,),
                                  errorStyle: const TextStyle(height: 1.2,color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  suffixIcon: const Icon(Icons.textsms_outlined, color: Color(0xFF26242e),),
                                  hintText: 'نص الرسالة',
                                  fillColor: const Color(0xffffffff).withOpacity(0.5),
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 20,),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child:  MaterialButton(
                          elevation: 5.0,
                          onPressed: (){
                            if(_formState.currentState!.validate()){

                              Map contactMap = {
                                "email": emailController.text,
                                "title": emailTitleController.text,
                                "message": emailTextController.text
                              };

                              Contact(context).contactApi(contactMap: contactMap).then((value){
                                if(value != false){
                                  setState((){
                                    emailController.clear();
                                    emailTitleController.clear();
                                    emailTextController.clear();
                                  });
                                }else{}
                              });
                            }else{

                            }
                          },
                          color: const Color(0xffc52278),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text('ارسال', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ],
                  ),
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




extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}