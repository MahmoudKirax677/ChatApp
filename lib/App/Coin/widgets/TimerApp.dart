import 'package:flutter/material.dart';
import 'dart:async';


class TimerApp extends StatefulWidget {
  static final GlobalKey<_TimerAppState> staticGlobalKey = GlobalKey<_TimerAppState>();
  TimerApp({Key? key}) : super(key: staticGlobalKey);
  @override
  _TimerAppState createState() => _TimerAppState();
}
class _TimerAppState extends State<TimerApp> {
  var originalMinute = 0;
  int secondsPassed = 0;
  bool isActive = false;
  bool? caller;
  Timer? timer;

  startTimer({caller}){
    /// Call Coins Api
    setState(() {
      this.caller = caller;
      isActive = !isActive;
    });
  }

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
      handleTick();
    });
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);
    if(minutes > originalMinute){
      /// Call Coins Api
    ///  caller! ? print("---------------------- NEED COINS") : print("---------------------- NO NEED COINS");
    ///  print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm    $originalMinute    mmmmmmmmmm $minutes");
      setState((){
        originalMinute = minutes;
      });
    }else{
     /// print("xxxxxxxxxxxxxxxxxxxx $minutes  $secondsPassed");
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hours == 0 ? const SizedBox(width: 0) : Text('${hours.toString().padLeft(2, '0')}:',style: const TextStyle(color: Colors.white,fontSize: 15),),
          Text('${minutes.toString().padLeft(2, '0')}:',style: const TextStyle(color: Colors.white,fontSize: 15),),
          Text(seconds.toString().padLeft(2, '0'),style: const TextStyle(color: Colors.white,fontSize: 15),),
        ],
      ),
    );
  }
}

