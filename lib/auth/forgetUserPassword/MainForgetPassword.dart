import 'package:flutter/material.dart';
import '../widgets/authAppBar.dart';
import 'ChangePassword.dart';
import 'PhonePage.dart';
import 'PinPage.dart';

class MainForgetPassword extends StatefulWidget {
  const MainForgetPassword({Key? key}) : super(key: key);

  @override
  State<MainForgetPassword> createState() => _MainForgetPasswordState();
}

class _MainForgetPasswordState extends State<MainForgetPassword> {
  late PageController pagecontroller;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  var viewPassword = true;
  final Color _accentColor = const Color(0xFF164CA2);

  @override
  void initState() {
    pagecontroller = PageController(initialPage: 0);
    phoneNumberController = TextEditingController(text: "05454880902");
    super.initState();
  }

  @override
  void deactivate() {
    pagecontroller.dispose();
    phoneNumberController.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(barText: "كلمة المرور"),
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pagecontroller,
          children: [
            PhonePage(pagecontroller: pagecontroller),
            PinPage(pagecontroller: pagecontroller),
            ChangePassword(pagecontroller: pagecontroller),
          ],
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
