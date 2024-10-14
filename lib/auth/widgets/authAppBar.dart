import 'package:flutter/material.dart';


class AppBarWidget extends StatefulWidget {
  String barText;
  AppBarWidget({Key? key,required this.barText}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.height * .8).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: AuthAppBar(const Color(0xffc52278),const Color(0xffc52278)),
          ),
          Positioned(
            top: -15,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.height * .78).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: AuthAppBar(const Color(0xffbf508b),const Color(0xffffffff)),
            ),
          ),
          Positioned(
            top: 40,
            child: Column(
              children: [
                const Image(image: AssetImage("assets/logo/logo.png"),height: 30,),
                const SizedBox(height: 10,),
                Text(widget.barText,style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class AuthAppBar extends CustomPainter{
  var color;
  var color2;
  AuthAppBar(this.color,this.color2);
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint0 = Paint()
      ..color = color
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          color,
          color,
          color,
          color,
          color2,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;


    Path path0 = Path();
    path0.moveTo(0,size.height*0.3779154);
    path0.quadraticBezierTo(size.width*0.0364400,size.height*0.2841691,size.width*0.1099400,size.height*0.2765487);
    path0.cubicTo(size.width*0.1789400,size.height*0.2836775,size.width*0.1520200,size.height*0.3353786,size.width*0.2090200,size.height*0.3375910);
    path0.cubicTo(size.width*0.2790200,size.height*0.3280039,size.width*0.2286200,size.height*0.2570010,size.width*0.3101000,size.height*0.2521927);
    path0.cubicTo(size.width*0.3863600,size.height*0.2584562,size.width*0.3620400,size.height*0.2996264,size.width*0.4317000,size.height*0.3050934);
    path0.cubicTo(size.width*0.5149600,size.height*0.3013864,size.width*0.4741400,size.height*0.2156834,size.width*0.5491400,size.height*0.2134710);
    path0.cubicTo(size.width*0.6326400,size.height*0.2119961,size.width*0.6264400,size.height*0.3258604,size.width*0.6976800,size.height*0.3326254);
    path0.cubicTo(size.width*0.7867400,size.height*0.3297148,size.width*0.7535800,size.height*0.2238643,size.width*0.8240800,size.height*0.2243559);
    path0.cubicTo(size.width*0.8860800,size.height*0.2317306,size.width*0.8731400,size.height*0.2662340,size.width*0.9300800,size.height*0.2706096);
    path0.quadraticBezierTo(size.width*0.9628200,size.height*0.2716912,size.width,size.height*0.2514454);
    path0.lineTo(size.width,0);
    path0.lineTo(0,0);
    path0.lineTo(0,size.height*0.3779154);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}