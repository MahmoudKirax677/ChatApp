import 'package:flutter/material.dart';
import 'package:zefaf/help/hive/localStorage.dart';

class MessageNum extends StatefulWidget {
  final id;
  const MessageNum({Key? key,this.id}) : super(key: key);

  @override
  State<MessageNum> createState() => _MessageNumState();
}

class _MessageNumState extends State<MessageNum> {


  @override
  Widget build(BuildContext context) {
    return LocalStorage().getValue("${widget.id}") == null ? Container() :
    Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const Icon(Icons.lens,color: Colors.black38,size: 25,),
        Text("${LocalStorage().getValue("${widget.id}")}",style: const TextStyle(color: Colors.white),)
      ],
    );
  }
}
