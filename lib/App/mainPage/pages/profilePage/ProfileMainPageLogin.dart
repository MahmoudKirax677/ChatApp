import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefaf/App/mainPage/pages/profilePage/widgets/ProfileList.dart';
import '../../../../help/globals.dart' as globals;
import '../../../../model/profile_api.dart';
import 'package:intl/intl.dart' as i;


class ProfileMainPageLogin extends StatefulWidget {
  const ProfileMainPageLogin({Key? key}) : super(key: key);

  @override
  State<ProfileMainPageLogin> createState() => _ProfileMainPageLoginState();
}

class _ProfileMainPageLoginState extends State<ProfileMainPageLogin> {

  final Color _accentColor = const Color(0xffc52278);
  late TextEditingController userNameController;
  late TextEditingController ageController;
  late TextEditingController hairColourController;
  late TextEditingController eyeColourController;
  late TextEditingController statusController;
  late TextEditingController moneyController;
  FocusNode fu = FocusNode();
  FocusNode fu1 = FocusNode();
  FocusNode fu2 = FocusNode();
  FocusNode fu3 = FocusNode();
  FocusNode fu4 = FocusNode();
  FocusNode fu5 = FocusNode();
  bool isEditable = false;
  Map editMap = {"hairColorId": null,"eyeColorId": null,"socialStatuseId": null,"financialstatuseId": null,"birthday": null};
  Map profileListData = {};
  late File _image2;
  late String base64Image2;
  final picker = ImagePicker();

  @override
  void initState() {
    userNameController = TextEditingController();
    ageController = TextEditingController();
    hairColourController = TextEditingController();
    eyeColourController = TextEditingController();
    statusController = TextEditingController();
    moneyController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfile(context);
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
    ageController.dispose();
    hairColourController.dispose();
    eyeColourController.dispose();
    statusController.dispose();
    moneyController.dispose();
    super.dispose();
  }


  showList({context, title, dataList, from}){
    BlurryDialog  alert = BlurryDialog(title,dataList,(id,name){
      setState((){
        switch(from){
          case 1:
            hairColourController.text = name;
            editMap["hairColorId"] = id;
            break;
          case 2:
            eyeColourController.text = name;
            editMap["eyeColorId"] = id;
            break;
          case 3:
            statusController.text = name;
            editMap["socialStatuseId"] = id;
            break;
          case 4:
            moneyController.text = name;
            editMap["financialstatuseId"] = id;
            break;
        }
      });
      Navigator.of(context).pop();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  Future getImage2(ImageSource imageSource,context) async {
    final pickedFile = await picker.pickImage(
        source: imageSource,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75, // <- Reduce Image quality
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);
    if (pickedFile != null) {
      ProfileApi(context).editProfileImage(imagePath: pickedFile.path).then((value){
        if(value != false){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            getProfile(context);
          });
        }else{}
      });
    } else {}
  }

  getProfile(context){
    ProfileApi(context).getProfile().then((value){
      if(value != false){
        setState((){
          profileListData = value["data"];
          value["data"]["name"] == null ? null : userNameController.text = value["data"]["name"];
          value["data"]["birthday"] == null ? null : ageController.text = value["data"]["birthday"];
          value["data"]["hairColor"] == null ? null : hairColourController.text = value["data"]["hairColor"];
          value["data"]["eyeColor"] == null ? null : eyeColourController.text = value["data"]["eyeColor"];
          value["data"]["socialStatus"] == null ? null : statusController.text = value["data"]["socialStatus"];
          value["data"]["financialStatus"] == null ? null : moneyController.text = value["data"]["financialStatus"];
          editMap = {"hairColorId": value["data"]["hairColor"],"eyeColorId": value["data"]["eyeColor"],"socialStatuseId": value["data"]["socialStatus"],"financialstatuseId": value["data"]["financialStatus"],"birthday": value["data"]["birthday"]};
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
                                //Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),

                          const Text("الملف الشخصي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),

                          const Icon(Icons.menu,color: Colors.transparent,),
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
                Row(
                  children: [
                    profileListData["images"] == null ? SizedBox(
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundColor: const Color(0xffc52278),
                        child: CircleAvatar(
                          radius: 42.0,
                          backgroundColor: const Color(0xffc52278),
                          backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12.0,
                              child: GestureDetector(
                                onTap: (){
                                  showDialog<bool>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('صورة ملف الشخصي',style: TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                        actions: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImage2(ImageSource.gallery,this.context);
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                height: 50,
                                                width: 120,
                                                child: const Center(
                                                  child: Text('استديو', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImage2(ImageSource.camera,this.context);
                                            },
                                            child: const Material(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: 50,
                                                width: 120,
                                                child: Center(
                                                  child: Text('كاميرة', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        content: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffc52278)),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('اغلاق',style: TextStyle(color: Colors.white,fontSize: 17)),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text('يرجى اختيار الصورة من ؟',style: TextStyle(fontFamily: "Tajawal",color: Color(0xffc52278)),),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.image,
                                  size: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        :
                    SizedBox(
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundColor: const Color(0xffc52278),
                        child: CircleAvatar(
                          radius: 42.0,
                          backgroundColor: const Color(0xffc52278),
                          backgroundImage: NetworkImage(profileListData["images"]),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12.0,
                              child: GestureDetector(
                                onTap: (){
                                  showDialog<bool>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('صورة ملف الشخصي',style: TextStyle(fontFamily: "Tajawal",color: Colors.black54),),
                                        actions: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImage2(ImageSource.gallery,this.context);
                                            },
                                            child: const Material(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: 50,
                                                width: 120,
                                                child: Center(
                                                  child: Text('استديو', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getImage2(ImageSource.camera,this.context);
                                            },
                                            child: const Material(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: 50,
                                                width: 120,
                                                child: Center(
                                                  child: Text('كاميرة', style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        content: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffc52278)),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('اغلاق',style: TextStyle(color: Colors.white,fontSize: 17)),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text('يرجى اختيار الصورة من ؟',style: TextStyle(fontFamily: "Tajawal",color: Color(0xffc52278)),),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.image,
                                  size: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * .5,
                          child: EditableText(
                            focusNode: fu,
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            keyboardAppearance: Brightness.dark,
                            expands: false,
                            maxLines: 1,
                            onSubmitted: (text) {},
                            cursorColor: Colors.white,
                            backgroundCursorColor: Colors.black,
                            controller: userNameController,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(globals.nameMyIso, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     fu.requestFocus();
                    //   },
                    //   child: const Icon(Icons.edit,color: Colors.white,),
                    // )
                  ],
                ),



                const SizedBox(height: 30,),
                Column(

                  children: [
                    Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("المواليد", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu1,
                                    readOnly: true,
                                    keyboardType: TextInputType.number,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    maxLines: 1,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: ageController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(1950, 1, 1),
                              maxTime: DateTime(2004, 1, 1),
                              currentTime: DateTime.now(),
                              locale: LocaleType.ar,
                              onConfirm: (date) {
                                final i.DateFormat formatter = i.DateFormat('yyyy-MM-dd');
                                final String formatted = formatter.format(date);
                                setState((){
                                  ageController.text = formatted;
                                  editMap["birthday"] = formatted;
                                });
                              },
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),)
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("لون الشعر", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu2,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: hairColourController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 1).then((value){
                              if(value != false){
                                showList(
                                    from: 1,
                                    title: "لون الشعر",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("لون العين", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu3,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: eyeColourController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 2).then((value){
                              if(value != false){
                                showList(
                                    from: 2,
                                    title: "لون العين",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("الحالة الاجتماعية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu4,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: statusController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 3).then((value){
                              if(value != false){
                                showList(
                                    from: 3,
                                    title: "الحالة الاجتماعية",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("الحالة المادية", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.0,),),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: EditableText(
                                    focusNode: fu5,
                                    readOnly: true,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.text,
                                    keyboardAppearance: Brightness.dark,
                                    expands: false,
                                    selectionColor: Colors.red,
                                    onSubmitted: (text) {},
                                    cursorColor: Colors.white,
                                    backgroundCursorColor: Colors.black,
                                    controller: moneyController,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,fontFamily: "Tajawal",letterSpacing: 0,decorationThickness: 0.001,),
                                  ),
                                ),
                                const Icon(Icons.edit,color: Colors.white,)
                              ],
                            ),
                            Container(color: Colors.white,height: 1,width: MediaQuery.of(context).size.width * .75,),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            ProfileApi(context).getOptionApi(from: 4).then((value){
                              if(value != false){
                                showList(
                                    from: 4,
                                    title: "الحالة المادية",
                                    dataList: value["data"],
                                    context: context
                                );
                              }else{}
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.black12.withOpacity(0.0001),

                          ),
                        )
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30,),
                SizedBox(
                  width: 300,
                  height: 50,
                  child:  MaterialButton(
                    elevation: 5.0,
                    onPressed: (){
                      if(editMap["birthday"] == null){
                        AlertController.show("خطأ", "خطأ يرجى اختيار المواليد !", TypeAlert.warning);
                      }else if(editMap["hairColorId"] == null){
                        AlertController.show("خطأ", "خطأ يرجى اختيار لون الشعر !", TypeAlert.warning);
                      }else if(editMap["eyeColorId"] == null){
                        AlertController.show("خطأ", "خطأ يرجى اختيار لون العين !", TypeAlert.warning);
                      }else if(editMap["socialStatuseId"] == null){
                        AlertController.show("خطأ", "خطأ يرجى اختيار الحالة الاجتماعية !", TypeAlert.warning);
                      }else if(editMap["financialstatuseId"] == null){
                        AlertController.show("خطأ", "خطأ يرجى الحالة المادية !", TypeAlert.warning);
                      }else{
                        ProfileApi(context).editApiForLogin(editMap: editMap).then((value){});
                      }
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
        ),
      ],
    );
  }
}
