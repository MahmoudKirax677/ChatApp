import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialog extends StatefulWidget {

  String title;
  List apiData;

  Function continueCallBack;


  BlurryDialog(this.title,this.apiData,this.continueCallBack(id,name), {Key? key}) : super(key: key);

  @override
  State<BlurryDialog> createState() => _BlurryDialogState();
}

class _BlurryDialogState extends State<BlurryDialog> {
  TextStyle textStyle = const TextStyle (color: Color(0xffc52278),fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(backgroundColor: Colors.white.withOpacity(0.6),
          title: Center(child: Text('${widget.title}\n------------------------------',style: textStyle,textAlign: TextAlign.center,)),
         // content: Text(content, style: textStyle,),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: List.generate(widget.apiData.length, (index) => SizedBox(
                //height: 20,
                  child: GestureDetector(
                    onTap: (){
                      widget.continueCallBack(widget.apiData[index]["id"],widget.apiData[index]["title"]);
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0.001),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${widget.apiData[index]["title"]}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              const Icon(Icons.arrow_forward,color: Color(0xffc52278),)
                            ],
                          ),
                          const Divider(color: Colors.black87,)
                        ],
                      ),
                    ),
                  ))),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 75,
              height: 40,
              child:  MaterialButton(
                elevation: 5.0,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                color: const Color(0xffc52278),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('اغلاق', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ));
  }
}