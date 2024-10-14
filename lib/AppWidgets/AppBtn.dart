import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Btn extends StatefulWidget {
  Function btnFunction;
  String btnText;
  Btn({Key? key,required this.btnFunction,required this.btnText}) : super(key: key);

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child:  MaterialButton(
        elevation: 5.0,
        onPressed: widget.btnFunction(),
        color: Colors.red,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(widget.btnText, style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
