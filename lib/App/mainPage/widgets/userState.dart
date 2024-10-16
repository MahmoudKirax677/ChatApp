import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../help/globals.dart' as globals;
import '../../../help/myprovider.dart';


class UserState extends StatefulWidget {
 // static final GlobalKey<_UserStateState> staticGlobalKey = GlobalKey<_UserStateState>();
  final id;
  final size;
  final radius;
   UserState({Key? key,this.id,this.size,this.radius}) : super(key: key);

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      //radius: 12.0,
      radius: widget.radius,
      child: Icon(
        Icons.lens,
       // size: 15.0,
        size: widget.size,
        color: Provider.of<AppProvide>(context,listen: true).onlineMap[widget.id.toString()] == 0 ? Colors.green :
        Provider.of<AppProvide>(context,listen: true).onlineMap[widget.id.toString()] == 1 ? Colors.black54 :
        Provider.of<AppProvide>(context,listen: true).onlineMap[widget.id.toString()] == 2 ? Colors.amber :
        Colors.black54,
      ),
    );
  }
}
