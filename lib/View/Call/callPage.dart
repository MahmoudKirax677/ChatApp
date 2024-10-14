import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_audio_manager_plus/flutter_audio_manager_plus.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import '../../help/globals.dart' as globals;
import '../../help/hive/localStorage.dart';
import '../../help/myprovider.dart';
import '../../model/BuyCoinsApi.dart';
import '../../model/CallCoinsApi.dart';
import '../Coin/widgets/TimerApp.dart';
import '../mainPage/pages/chat/Chat.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../../../../../../model/profile_api.dart';
import '../../../../model/home_api.dart';
import '../../../../model/chat_api.dart';
import '../../../../model/stickers_api.dart';
import '../mainPage/widgets/coinWidget2.dart';
import '../mainPage/widgets/userState.dart';



class CallPage extends StatefulWidget{
  static final GlobalKey<_CallPageState> staticGlobalKey = GlobalKey<_CallPageState>();
  var id;
  var from;
  Map otherProfileData = {};
  var caller;
  var callType;
  CallPage({Key? key,this.id,required this.otherProfileData,this.from,this.caller,this.callType}):super(key:staticGlobalKey);
  @override
  State<CallPage> createState() => _CallPageState();
}
class _CallPageState extends State<CallPage> {
  late IO.Socket socket;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  late MediaStream _localStream;
  late RTCPeerConnection pc;
  //final socketServer = "https://162.0.208.80:7373";
  final socketServer = "http://45.138.39.93:4949";
  var connected = false;
  var callAccepted = false;
  final Color _accentColor = const Color(0xffc52278);
  final assetsAudioPlayer = AssetsAudioPlayer();
  AudioInput _currentInput = const AudioInput("unknow", 0);
  List<AudioInput> _availableInputs = [];
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;
  bool res = false;
  bool speaker = false;
  List stickersList = [];
  Timer? timer;
  bool timerStarted = false;



  /* addGift(data){
    data["senderId"] != LocalStorage().getValue("userID") ? null : Navigator.of(context).pop();
    showOverlay(context: context,assetName: 'gf',sec: 4,data: data);
  }




  ///==================================================================================
  showOverlay({context, assetName,sec,data}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: NetworkImage(data["image"]),height: 75,),
            SizedBox(
              height: 400,width: 400,
              child: Lottie.asset(
                'assets/icons/$assetName.json',
                height: 400,
                animate: true,
                repeat: false,
              ),
            ),
          ],
        ),
      ),
    );
    overlayState?.insert(overlayEntry);
    await Future.delayed(Duration(seconds: sec));
    overlayEntry.remove();
    showOverlay2(context: this.context,assetName: 'cc',sec: 3500);
  }
  ///==================================================================================
  ///
  ///==================================================================================
  showOverlay2({context, assetName,sec}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => SizedBox(
        height: 200,width: 100,
        child: Lottie.asset(
          'assets/icons/$assetName.json',
          height: 200,
          animate: true,
          repeat: true,
        ),
      ),

    );
    overlayState?.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: sec));
    overlayEntry.remove();
  }
  ///==================================================================================*/



  @override
  void initState() {
    //init();
    super.initState();
    mounted ? globals.callContext = context : null;
    FlutterRingtonePlayer.play(
      fromAsset: "assets/call/${widget.caller == 1 ?"calling.mp3":"call.mp3"}",
      looping: false,
      asAlarm: false,
    );
    // print("-------------------------------------------------------------");
    // print(widget.id);
    // assetsAudioPlayer.open(
    //     Audio("assets/call/${widget.caller == 1 ?"calling.mp3":"call.mp3"}"),
    //     showNotification: false,
    //     loopMode: LoopMode.single
    // );
  }



  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        callAccepted = true;
        TimerApp.staticGlobalKey.currentState?.startTimer(caller: widget.caller == 1 ? true : false);
        _isNear = (event > 0) ? true : false;
        _isNear ? IncallManager().turnScreenOn() : IncallManager().turnScreenOff();
      });
    });
  }

  soundOutPut()async{
    if (_currentInput.port == AudioPort.receiver) {
      await FlutterAudioManagerPlus.changeToSpeaker();
    } else {
      await FlutterAudioManagerPlus.changeToReceiver();
    }
    await _getInput();
    setState((){
      speaker = !speaker;
    });
  }


  soundOutPut2()async{
    await FlutterAudioManagerPlus.changeToSpeaker();
    await _getInput();
    setState((){
      callAccepted = true;
      speaker = !speaker;
    });
  }

  Future<void> init1() async {
    FlutterAudioManagerPlus.setListener(() async {
     // print("-----changed-------");
      await _getInput();
      setState(() {});
    });

    await _getInput();
    if (!mounted) return;
    setState(() {

    });
  }

  _getInput() async {
    _currentInput = await FlutterAudioManagerPlus.getCurrentOutput();
    _availableInputs = await FlutterAudioManagerPlus.getAvailableInputs();
  }

  Future init() async{
    widget.callType == "call" ? soundOutPut() : soundOutPut2();
    FlutterRingtonePlayer.stop();
    assetsAudioPlayer.stop();
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await initSocket();
    await joinRoom();
    listenSensor();
    init1();
  }

  initSocket(){
    socket = IO.io(socketServer, OptionBuilder().enableForceNewConnection().setTransports(['websocket']).setQuery({"id": widget.id}).build());
    socket.onConnect((_) {
      setState(() {
        connected = true;
      });
    });
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('joined', (data){
      _sendOffer();
    //  print('------------------- joined');
      setState(() {});
    });
    socket.on('offer', (data) async{
      data = jsonDecode(data);
      await _gotOffer(RTCSessionDescription(data['sdp'], data['type']));
      await _sendAnswer();
     // print('------------------- offer');
      setState(() {});
    });
    socket.on('answer', (data){
      data = jsonDecode(data);
      _gotAnswer(RTCSessionDescription(data['sdp'], data['type']));
     // print('------------------- answer');
      setState(() {});
    });
    socket.on('ice', (data)async{
      data = jsonDecode(data);
      _gotIce(RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
     // print('------------------- ice');
      widget.callType == "call" ?  await IncallManager().setSpeakerphoneOn(false) : null;
      widget.caller == 1 ? timerStarted ? null : startTime() : null;
      setState(() {
        timerStarted = true;
      });
    });
    socket.connect();
  }


  startTime(){
    CallCoinsApi().sendCoins(
      amount: widget.callType == 'call' ?
      Provider.of<AppProvide>(globals.callContext,listen: false).audio
          :
      Provider.of<AppProvide>(globals.callContext,listen: false).video,
        userId: widget.otherProfileData["id"]
    ).then((value){
      BuyCoinsApi().getProfile(globals.callContext);
    },onError: (e){
      BuyCoinsApi().getProfile(globals.callContext);
      assetsAudioPlayer.stop();
      timer?.cancel();
      globals.socket.emit("cancel",[{
        "id" : widget.otherProfileData["id"],
      }]);
    });
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t){
      CallCoinsApi().sendCoins(
          amount: widget.callType == 'call' ?
          Provider.of<AppProvide>(globals.callContext,listen: false).audio
              :
          Provider.of<AppProvide>(globals.callContext,listen: false).video,
        userId: widget.otherProfileData["id"]
      ).then((value){
        BuyCoinsApi().getProfile(globals.callContext);
      },onError: (e){
        BuyCoinsApi().getProfile(globals.callContext);
        assetsAudioPlayer.stop();
        timer?.cancel();
        globals.socket.emit("cancel",[{
          "id" : widget.otherProfileData["id"],
        }]);
        FlutterRingtonePlayer.play(
          fromAsset: "assets/call/endCoins.mp3",
          looping: false,
          asAlarm: false,
        );
        AlertController.show("خطأ", "رصيدك غير كافي , يرجى اضافة كوينز لاجراء الاتصال !", TypeAlert.warning);
      });
    });
  }


  Future joinRoom() async{
    final config = {
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
       // {"url": "stun:stun.ekiga.net"},
        // {'url':'stun:stun01.sipphone.com'},
        // {'url':'stun:stun.ekiga.net'},
        // {'url':'stun:stun.fwdnet.net'},
        // {'url':'stun:stun.ideasip.com'},
        // {'url':'stun:stun.iptel.org'},
        // {'url':'stun:stun.rixtelecom.se'},
        // {'url':'stun:stun.schlund.de'},
        // {'url':'stun:stun.l.google.com:19302'},
        // {'url':'stun:stun1.l.google.com:19302'},
        // {'url':'stun:stun2.l.google.com:19302'},
        // {'url':'stun:stun3.l.google.com:19302'},
        // {'url':'stun:stun4.l.google.com:19302'},
        // {'url':'stun:stunserver.org'},
        // {'url':'stun:stun.softjoys.com'},
        // {'url':'stun:stun.voiparound.com'},
        // {'url':'stun:stun.voipbuster.com'},
        // {'url':'stun:stun.voipstunt.com'},
        // {'url':'stun:stun.voxgratia.org'},
      ]
    };
    final sdpConstraints = {
      'mandatory':{
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional':[]
    };
    pc = await createPeerConnection(config, sdpConstraints);
    final mediaConstraints = {
      'audio': true,
      'video': widget.callType == "call" ? false : {'facingMode':'user'}
    };
    _localStream = await Helper.openCamera(mediaConstraints);
    _localStream.getTracks().forEach((track) {
      pc.addTrack(track, _localStream);
    });
    _localRenderer.srcObject = _localStream;
    pc.onIceCandidate = (ice) {
      _sendIce(ice);
    };
    pc.onAddStream = (stream){
      _remoteRenderer.srcObject = stream;
    };
    socket.emit('join');
  }

  Future _sendOffer() async{
   // print('send offer');
    var offer = await pc.createOffer();
    pc.setLocalDescription(offer);
    socket.emit('offer', jsonEncode(offer.toMap()));
  }
  Future _gotOffer(RTCSessionDescription offer) async{
   // print('got offer');
    pc.setRemoteDescription(offer);
  }
  Future _sendAnswer() async{
   // print('send answer');
    var answer = await pc.createAnswer();
    pc.setLocalDescription(answer);
    socket.emit('answer', jsonEncode(answer.toMap()));
  }
  Future _gotAnswer(RTCSessionDescription answer) async{
   // print('got answer');
    pc.setRemoteDescription(answer);
  }
  Future _sendIce(RTCIceCandidate ice) async{
    socket.emit('ice', jsonEncode(ice.toMap()));
  }
  Future _gotIce(RTCIceCandidate ice) async{
    pc.addCandidate(ice);
  }



  bool _isTorchOn = false;


  void _toggleTorch() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final videoTrack = _localStream
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    final has = await videoTrack.hasTorch();
    if (has) {
      setState(() => _isTorchOn = !_isTorchOn);
      await videoTrack.setTorch(_isTorchOn);
    } else {
    }
  }


  var isFirstCam = true;
  var isFirstAudio = true;

  void _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');
    final videoTrack = _localStream
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
    setState(() {
      isFirstCam = !isFirstCam;
    });
  }

  void _toggleAudio() async {
    if (_localStream == null) throw Exception('Stream is not initialized');
    final audioTrack = _localStream.getAudioTracks().firstWhere((track) => track.kind == 'audio');
    Helper.setMicrophoneMute(isFirstAudio, _localStream.getAudioTracks().first);// mute
    setState(() {
      isFirstAudio = !isFirstAudio;
    });
  }

  var toggleEreia = false;
  var isInBack = false;


  Widget firstCam(){
    return GestureDetector(
      onTap: (){
        setState(() {
          // toggleEreia = false;
        });
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width.toDouble(),
            height: MediaQuery.of(context).size.height.toDouble(),
            child: RTCVideoView(_localRenderer,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,mirror: true,),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              width: 100,
              height: 175,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: RTCVideoView(_remoteRenderer,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,mirror: true,)),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondCam(){
    return GestureDetector(
      onTap: (){
        setState(() {
          // toggleEreia = true;
        });
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width.toDouble(),
            height: MediaQuery.of(context).size.height.toDouble(),
            child: RTCVideoView(_remoteRenderer,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,mirror: true,),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              width: 100,
              height: 175,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: RTCVideoView(_localRenderer,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,mirror: true,)),
            ),
          ),
        ],
      ),
    );
  }

  stopSound(){
    FlutterRingtonePlayer.stop();
    assetsAudioPlayer.stop();
  }

  Future<bool> onBack(context)async{
    await assetsAudioPlayer.stop();
    if(isInBack){

    }else{
      setState((){
        isInBack = true;
      });
      FlutterRingtonePlayer.stop();
      assetsAudioPlayer.stop();
      if(connected){
        _streamSubscription.cancel();
        _streamSubscription.pause();
        IncallManager().stop();
        socket.disconnect();
        socket.destroy();
        socket.dispose();
        pc.dispose();
        pc.removeStream;
        pc.removeTrack;
        _localRenderer.dispose();
        _localStream.dispose();
        timer?.cancel();
        Navigator.of(context).pop();
      }else{
        Navigator.of(context).pop();
      }
    }
    return true;
  }

  @override
  void dispose() {
    if(connected){
      _streamSubscription.cancel();
      _streamSubscription.pause();
      IncallManager().stop();
      socket.disconnect();
      socket.destroy();
      socket.dispose();
      pc.dispose();
    }else{}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.callContext = context;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    _accentColor.withOpacity(0.5),
                    _accentColor
                  ],
                  stops: const [
                    0.0,
                    1.0
                  ]
              )
          ),
        ),
        WillPopScope(
          onWillPop: ()async=>false,
          //onWillPop: ()=>onBack(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.pink.shade400,
              toolbarHeight: 75,
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
                        // const Image(image: AssetImage("assets/logo/logo.png"),height: 30,color: Colors.white,),
                        // const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                widget.otherProfileData["images"] == null ? SizedBox(
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: const Color(0xffc52278),
                                    child: CircleAvatar(
                                      radius: 23.0,
                                      backgroundColor: const Color(0xffc52278),
                                      backgroundImage: const AssetImage("assets/icons/userEmptyImage.png"),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: widget.otherProfileData["id"],size: 10.0,radius: 7.0),
                                      ),
                                    ),
                                  ),
                                )
                                    :
                                SizedBox(
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: const Color(0xffc52278),
                                    child: CircleAvatar(
                                      radius: 23.0,
                                      backgroundColor: const Color(0xffc52278),
                                      backgroundImage: NetworkImage(widget.otherProfileData["images"]),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: UserState(id: widget.otherProfileData["id"],size: 10.0,radius: 7.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                connected ? const CircleAvatar(
                                  backgroundColor: Colors.lightGreen,
                                  radius: 6.0,
                                  child: Icon(
                                    Icons.lens,
                                    size: 10.0,
                                    color: Colors.green,
                                  ),
                                )
                                    :
                                const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 6.0,
                                  child: Icon(
                                    Icons.lens,
                                    size: 10.0,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                                   // callAccepted ? TimerApp() : const SizedBox()
                                    TimerApp()
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  const [
                                Icon(Icons.video_camera_front,color: Colors.transparent,size: 30),
                                SizedBox(width: 15,),
                                CoinWidget2(),
                                // widget.from == 1 ? GestureDetector(
                                //     onTap: (){
                                //       Navigator.push(
                                //         context,
                                //         PageRouteBuilder(
                                //           pageBuilder: (context, animation1, animation2) {
                                //             return ChatPage(from: 2,otherProfileData: widget.otherProfileData,);
                                //           },
                                //           transitionsBuilder: (context, animation1, animation2, child) {
                                //             return FadeTransition(
                                //               opacity: animation1,
                                //               child: child,
                                //             );
                                //           },
                                //           transitionDuration: const Duration(microseconds: 250),
                                //         ),
                                //       );
                                //     },
                                //     child: const Icon(Icons.message_outlined,color: Colors.white,size: 30)) : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                ///==================================================================
                ///==================================================================
                ///==================================================================
                ///==================================================================
                ///==================================================================
                ///==================================================================
                ///==================================================================





                widget.callType == "call" ? Container() : toggleEreia ? firstCam() : secondCam(),


                widget.callType == "videoCall" && callAccepted && !isFirstCam ? Positioned(
                  top:20,
                  left: 20,
                  child: GestureDetector(
                      onTap: () async {
                        _toggleTorch();
                      },
                      child:  SizedBox(
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              child: Icon( _isTorchOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline,color: Colors.black87)))
                  ),
                ) : Container(),

                widget.callType == "videoCall" && !callAccepted ? Positioned(
                  bottom: 300,
                  child: Column(
                    children: [
                      WidgetCircularAnimator(
                        outerColor: Colors.white,
                        innerColor: Colors.white,
                        innerAnimation: Curves.linear,size: 150,
                        child: widget.otherProfileData["images"] == null ? Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/icons/userEmptyImage.png"),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ) :
                        Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.otherProfileData["images"]),
                                fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
                      const SizedBox(height: 20),
                      Text(widget.caller == 1 ? "مكالمة فديو صادرة" : "مكالمة فديو واردة", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0,),),
                    ],
                  ),
                ) : widget.callType == "call" && !callAccepted ? Positioned(
                  bottom: 300,
                  child: Column(
                    children: [
                      WidgetCircularAnimator(
                        outerColor: Colors.white,
                        innerColor: Colors.white,
                        innerAnimation: Curves.linear,size: 150,
                        child: widget.otherProfileData["images"] == null ? Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/icons/userEmptyImage.png"),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ) :
                        Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.otherProfileData["images"]),
                                fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
                      const SizedBox(height: 20),
                      Text(widget.caller == 1 ? "مكالمة صوتية صادرة" : "مكالمة صوتية واردة", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0,),),
                    ],
                  ),
                ) : Container(),



                widget.callType == "call" && callAccepted ? Positioned(
                  bottom: 300,
                  child: Column(
                    children: [
                      WidgetCircularAnimator(
                        outerColor: Colors.white,
                        innerColor: Colors.white,
                        innerAnimation: Curves.linear,size: 150,
                        child: widget.otherProfileData["images"] == null ? Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/icons/userEmptyImage.png"),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ) :
                        Container(
                          height: 65,
                          width: 65,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.otherProfileData["images"]),
                                fit: BoxFit.cover
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(100.00)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text("${widget.otherProfileData["name"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
                    ],
                  ),
                ) : Container(),















                widget.caller == 1 && !callAccepted ?
                Positioned(
                  bottom: 20,
                  child: GestureDetector(
                    onTap: (){
                      FlutterRingtonePlayer.stop();
                      assetsAudioPlayer.stop();
                      globals.socket.emit("cancel",[{
                        "id" : widget.otherProfileData["id"],
                      }]);
                    },
                    child: const SizedBox(
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.call_end,color: Colors.white,),
                      ),
                    ),
                  ),
                )


                    :


                Positioned(
                  bottom: 20,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:

                      callAccepted ? widget.callType == "call" ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                _toggleAudio();
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( isFirstAudio ? Icons.mic : Icons.mic_off,color: Colors.black87)))
                          ),
                          GestureDetector(
                              onTap: () async {
                                soundOutPut();
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( speaker ? Icons.voice_over_off : Icons.record_voice_over_outlined,color: Colors.black87)))
                          ),
                          GestureDetector(
                            onTap: (){
                              globals.socket.emit("cancel",[{
                                "id" : widget.otherProfileData["id"],
                              }]);
                            },
                            child: const SizedBox(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.redAccent,
                                child: Icon(Icons.call_end,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      )
                          :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                _toggleCamera();
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( !isFirstCam ? Icons.camera_front : Icons.camera_alt,color: Colors.black87)))
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState((){
                                  toggleEreia = !toggleEreia;
                                });
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( toggleEreia ? Icons.cameraswitch : Icons.cameraswitch_outlined,color: Colors.black87)))
                          ),
                          GestureDetector(
                              onTap: () async {
                                _toggleAudio();
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( isFirstAudio ? Icons.mic : Icons.mic_off,color: Colors.black87)))
                          ),
                          GestureDetector(
                              onTap: () async {
                                soundOutPut();
                              },
                              child:  SizedBox(
                                  child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      child: Icon( speaker ? Icons.voice_over_off : Icons.record_voice_over_outlined,color: Colors.black87)))
                          ),
                          GestureDetector(
                            onTap: (){
                              globals.socket.emit("cancel",[{
                                "id" : widget.otherProfileData["id"],
                              }]);
                            },
                            child: const SizedBox(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.redAccent,
                                child: Icon(Icons.call_end,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      )
                          :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              FlutterRingtonePlayer.stop();
                              assetsAudioPlayer.stop();
                              globals.socket.emit("cancel",[{
                                "id" : widget.otherProfileData["id"],
                              }]);
                            },
                            child: const SizedBox(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.redAccent,
                                child: Icon(Icons.call_end,color: Colors.white,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                callAccepted = true;
                              });
                              globals.socket.emit("ansser",[{
                                "id" : widget.otherProfileData["id"],
                              }]);
                              init();
                            },
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.green,
                                child: Icon(widget.callType != "call" ? Icons.video_camera_front_rounded : Icons.call,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),


                callAccepted ? Positioned(
                    left: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const Image(image: AssetImage("assets/images/200w.gif"),height: 50,),
                        onTap: () async{
                          StickersApi(context).getStickers().then((value){
                            if(value != false){
                              setState((){
                                stickersList = value["data"];
                              });
                              showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => Material(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * .7,
                                    child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: List.generate(stickersList.length, (index){
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Image(image: NetworkImage(stickersList[index]["image"]),height: 100,),
                                              const SizedBox(height: 10,),
                                              Text("${stickersList[index]["amount"]} كوينز", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15.0,),),
                                              const SizedBox(height: 5,),
                                              SizedBox(
                                                width: 75,
                                                height: 40,
                                                child:  MaterialButton(
                                                  elevation: 5.0,
                                                  onPressed: ()async{
                                                    await StickersApi(context).sendStickers(stickersData: {
                                                      "partnerId" : widget.otherProfileData["id"],
                                                      "stickerId" : stickersList[index]["id"]
                                                    }).then((value)async{
                                                      if(value != false){
                                                        await ChatApi(context).storeMessage(chatData: {
                                                          "id" : widget.otherProfileData["id"],
                                                          "type" : 1,
                                                          "message" : stickersList[index]["image"]
                                                        }).then((value) {

                                                          if(value != false){
                                                            globals.socket.emit("vf", [{
                                                              "image": stickersList[index]["image"],
                                                              "socket" : true,
                                                              "created_at": DateTime.now().millisecondsSinceEpoch,
                                                              "id": widget.otherProfileData["id"],
                                                              "senderId": LocalStorage().getValue("userID"),
                                                            }
                                                            ]);
                                                          }else{
                                                            AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                                          }
                                                        });
                                                      }else{
                                                        AlertController.show("خطأ", "خطأ يرجى المحاولة مرة ثانية !", TypeAlert.warning);
                                                      }
                                                    });
                                                  },
                                                  color: const Color(0xffc52278),
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(top: 5),
                                                    child: Text('ارسال', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    )) : Container(),





              ],
            ),
          ),
        ),
      ],
    );
  }
}