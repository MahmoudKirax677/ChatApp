import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lottie;


class CoinsOverlay extends StatefulWidget {
  static final GlobalKey<_CoinsOverlayState> staticGlobalKey = GlobalKey<_CoinsOverlayState>();
  final Offset offset;
  CoinsOverlay({Key? key,required this.offset}) : super(key: staticGlobalKey);

  @override
  _CoinsOverlayState createState() => _CoinsOverlayState();
}

class _CoinsOverlayState extends State<CoinsOverlay>  with AutomaticKeepAliveClientMixin<CoinsOverlay>{

  var open = true;
  late Offset position;
  @override
  void initState() {
    super.initState();
    position = widget.offset;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        if(position.dy.toInt() + details.delta.dy.toInt() > MediaQuery.of(context).size.height - 235.toInt()){
                          position = Offset(position.dx, position.dy);
                        }else if(position.dy.toInt() + details.delta.dy.toInt() < 3){
                          position = Offset(position.dx, position.dy);
                        }else{
                          position = Offset(position.dx, position.dy + details.delta.dy);
                        }
                      });
                    },
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        setState(() {
                          open = !open;
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 150,
                        height: 35,
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 250),
                              curve: open ? Curves.linear : Curves.easeInOut,
                              width: 150,
                              height: 35,
                              right: open ? 0 : -110,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 150,
                                height: 35,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: open ? const Color(0xffF7F7F7) : const Color(0xffc00d1e),
                                    boxShadow: [BoxShadow(blurRadius: 10, color: open ? Colors.black12 : Colors.transparent, spreadRadius: 2)],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(40.0),
                                      bottomLeft: Radius.circular(40.0),
                                    ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Icon(open ? Icons.add_circle_outline : Icons.monetization_on,size: open ? 15 : 22,color: open ? null : Colors.white,),
                                    ),
                                    SizedBox(
                                      width: 115,
                                      height: 25,
                                      child: Center(
                                        child: DefaultTextStyle(
                                          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,letterSpacing: 1,color: open ? const Color(0xff512E70) : Colors.transparent),
                                          child: AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: [
                                              FlickerAnimatedText('50 Coins'),
                                              FlickerAnimatedText('50 Coins'),
                                              FlickerAnimatedText("50 Coins"),
                                            ],
                                            onTap: () {
                                              setState(() {
                                                open = !open;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}

