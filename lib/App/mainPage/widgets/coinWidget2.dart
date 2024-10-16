import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../../help/myprovider.dart';
import '../../../services/binding/PackageBinding.dart';
import '../../Coin/CoinMainPage.dart';
import '../../Coin/PackagePage.dart';

class CoinWidget2 extends StatelessWidget {
  const CoinWidget2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(const PackagePage(),binding: PackageBinding(),duration: const Duration(milliseconds: 150));
      },
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
           // width: 130,
            height: 30,
            clipBehavior: Clip.antiAlias,
            decoration:  BoxDecoration(
                color: const Color(0xffF7F7F7),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.transparent, spreadRadius: 2)],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    const Color(0xffffe823).withOpacity(0.5),
                    const Color(0xffe0aa02)
                  ],
                  stops: const [
                    0.0,
                    1.0
                  ]
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 22,
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 12,letterSpacing: 1,color: Colors.black87),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        pause: const Duration(milliseconds: 150),
                        animatedTexts: [
                          FlickerAnimatedText('${Provider.of<AppProvide>(context).coins} كوينز '),
                          FlickerAnimatedText('${Provider.of<AppProvide>(context).coins} كوينز '),
                          FlickerAnimatedText('${Provider.of<AppProvide>(context).coins} كوينز '),
                          FlickerAnimatedText('${Provider.of<AppProvide>(context).coins} كوينز '),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
