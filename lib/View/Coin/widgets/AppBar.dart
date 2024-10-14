import 'package:flutter/material.dart';

import '../../mainPage/widgets/coinWidget.dart';
import '../../mainPage/widgets/coinWidget2.dart';

PreferredSizeWidget appBar(context){
  return AppBar(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  CoinWidget2(),
                  const Text("متجر الكوينز", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_forward,color: Colors.white,)),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}