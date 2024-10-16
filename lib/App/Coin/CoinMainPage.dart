// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
// import '../../model/coin_api.dart';
//
// class CoinMainPage extends StatefulWidget {
//   const CoinMainPage({Key? key}) : super(key: key);
//
//   @override
//   State<CoinMainPage> createState() => _CoinMainPageState();
// }
//
// class _CoinMainPageState extends State<CoinMainPage> {
//   final Color _accentColor = const Color(0xffc52278);
//
//   List coinListData = [];
//   List coinListDataMonthly = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getCoin(context);
//     });
//   }
//
//   getCoin(context){
//     Coin(context).getCoin().then((value){
//       if(value != false){
//         setState((){
//           coinListData = value["data"];
//           coinListDataMonthly = value["offers"];
//         });
//       }else{}
//     });
//   }
//
//
//   void onGooglePayResult(paymentResult) {
//    // print("----------------------------------------------");
//    // print(jsonEncode(paymentResult));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.pink.shade100,
//               // gradient: LinearGradient(
//               //     begin: FractionalOffset.topCenter,
//               //     end: FractionalOffset.bottomCenter,
//               //     colors: [
//               //       Colors.pink.withOpacity(0.9),
//               //       Colors.pink.withOpacity(0.9)
//               //     ],
//               //     stops: const [
//               //       0.0,
//               //       1.0
//               //     ]
//               // )
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.pink.shade400,
//             toolbarHeight: 50,
//             elevation: 14,
//             automaticallyImplyLeading: false,
//             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(30),
//                 bottomLeft: Radius.circular(30))),
//             centerTitle: true,
//             title: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   const Opacity(
//                       opacity: 0.3,
//                       child: Image(image: AssetImage("assets/logo/logo.png"),height: 250,)),
//                   Column(
//                     children: [
//                       // const Image(image: AssetImage("assets/logo/logo.png"),height: 30,color: Colors.white,),
//                       // const SizedBox(height: 10,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children:  [
//                           GestureDetector(
//                               onTap: (){
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
//
//                           const Text("متجر الكوينز", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,),),
//
//                           const Icon(Icons.menu,color: Colors.transparent,),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//
//           ///coinListDataMonthly
//
//
//           body: Column(
//             children: [
//               coinListDataMonthly.isEmpty ? Container() : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//                 child: GestureDetector(
//                   onTap: (){
//                     // Navigator.push(
//                     //   context,
//                     //   PageRouteBuilder(
//                     //     pageBuilder: (context, animation1, animation2) {
//                     //       return Chat();
//                     //     },
//                     //     transitionsBuilder: (context, animation1, animation2, child) {
//                     //       return FadeTransition(
//                     //         opacity: animation1,
//                     //         child: child,
//                     //       );
//                     //     },
//                     //     transitionDuration: const Duration(microseconds: 250),
//                     //   ),
//                     // );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 0),
//                     child: AnimatedContainer(
//                       duration: const Duration(seconds: 2),
//                       curve: Curves.decelerate,
//                       height: 155,
//                       width: MediaQuery.of(context).size.width - 30,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(15),
//                         ),
//                         gradient: LinearGradient(
//                             begin: FractionalOffset.topCenter,
//                             end: FractionalOffset.bottomCenter,
//                             colors: [
//                               _accentColor,
//                               _accentColor.withOpacity(0.5),
//                               _accentColor
//                             ],
//                             stops: const [
//                               0.0,
//                               0.5,
//                               1.0
//                             ]
//                         ),
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//
//
//
//
//
//
//
//                           Positioned(
//                             top: 10,
//                             child: Container(
//                               height: 110,
//                               width: MediaQuery.of(context).size.width - 60,
//                               decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(15),
//                                   ),
//                                   gradient: LinearGradient(
//                                       begin: FractionalOffset.topCenter,
//                                       end: FractionalOffset.bottomCenter,
//                                       colors: [
//                                         Colors.grey,
//                                         Colors.white
//                                       ],
//                                       stops: [
//                                         0.0,
//                                         1.0
//                                       ]
//                                   )
//                               ),
//                             ),
//                           ),
//
//                           Positioned(
//                             left: 20,
//                             top: 25,
//                             child: Image.asset(
//                               'assets/icons/dollar.png',
//                               height: 90,
//                             ),
//                           ),
//
//
//
//                           Positioned(
//                             right: 20,
//                             child: Column(
//                               children: [
//                                 Text(
//                                   'قطع الكوينز',
//                                   style:
//                                   Theme.of(context).textTheme.headline6!.copyWith(
//                                     fontSize: 15,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${coinListDataMonthly[0]["coinsAmount"]} قطعة',
//                                   style:
//                                   Theme.of(context).textTheme.headline6!.copyWith(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: _accentColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           Positioned(
//                             // right: 20,
//                             bottom: 5,
//                             child: SizedBox(
//                               width: MediaQuery.of(context).size.width - 75,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     'الباقة الاسبوعية',
//                                     style:
//                                     Theme.of(context).textTheme.headline6!.copyWith(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${coinListDataMonthly[0]["price"]}\$',
//                                     style:
//                                     Theme.of(context).textTheme.subtitle2!.copyWith(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//
//
//
//
//
//
//
//
//
//
//
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: coinListData.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: (){
//
//                           // Navigator.push(
//                           //   context,
//                           //   PageRouteBuilder(
//                           //     pageBuilder: (context, animation1, animation2) {
//                           //       return Chat();
//                           //     },
//                           //     transitionsBuilder: (context, animation1, animation2, child) {
//                           //       return FadeTransition(
//                           //         opacity: animation1,
//                           //         child: child,
//                           //       );
//                           //     },
//                           //     transitionDuration: const Duration(microseconds: 250),
//                           //   ),
//                           // );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: AnimatedContainer(
//                             duration: const Duration(seconds: 2),
//                             curve: Curves.decelerate,
//                             height: 208,
//                             width: MediaQuery.of(context).size.width - 30,
//                             decoration: BoxDecoration(
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(15),
//                               ),
//                               gradient: LinearGradient(
//                                 begin: FractionalOffset.topCenter,
//                                 end: FractionalOffset.bottomCenter,
//                                 colors: coinListData[index]["name"] == "الباقة الذهبية" ? [
//                                   const Color(0xffb9830b),
//                                   const Color(0xffffe823).withOpacity(0.5),
//                                   const Color(0xffe0aa02)
//                                 ]
//                                   :
//                                 coinListData[index]["name"] == "الباقة الفضية" ? [
//                                     const Color(0xff939392),
//                                     const Color(0xffffffff).withOpacity(0.5),
//                                     const Color(0xff939392)
//                                   ] :
//                                 [
//                                   const Color(0xff3d0300),
//                                   const Color(0xff939392).withOpacity(0.5),
//                                   const Color(0xff672206)
//                                 ],
//                                 stops: const [
//                                   0.0,
//                                   0.5,
//                                   1.0
//                                 ]
//                             ),
//                             ),
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//
//
//
//
//
//
//
//                                 Positioned(
//                                   top: 10,
//                                   child: Container(
//                                     height: 160,
//                                     width: MediaQuery.of(context).size.width - 60,
//                                     decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(15),
//                                         ),
//                                         gradient: LinearGradient(
//                                             begin: FractionalOffset.topCenter,
//                                             end: FractionalOffset.bottomCenter,
//                                             colors: [
//                                               Colors.white,
//                                               Colors.grey
//                                             ],
//                                             stops: [
//                                               0.0,
//                                               1.0
//                                             ]
//                                         )
//                                     ),
//                                   ),
//                                 ),
//
//                                 Positioned(
//                                   left: 20,
//                                   child: Image.asset(
//                                     'assets/icons/dollar.png',
//                                     height: 120,
//                                   ),
//                                 ),
//
//
//
//                                 Positioned(
//                                   right: 20,
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         'قطع الكوينز',
//                                         style:
//                                         Theme.of(context).textTheme.headline6!.copyWith(
//                                           fontSize: 20,
//                                           color: Colors.black87,
//                                         ),
//                                       ),
//                                       Text(
//                                         '${coinListData[index]["coinsAmount"]} قطعة',
//                                         style:
//                                         Theme.of(context).textTheme.headline6!.copyWith(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold,
//                                           color: _accentColor,
//                                         ),
//                                       ),
//                                       GooglePayButton(
//                                         paymentConfigurationAsset: 'gPay.json',
//                                         paymentItems: const [
//                                           PaymentItem(
//                                             label: 'Total',
//                                             amount: '2',
//                                             status: PaymentItemStatus.final_price,
//                                           )
//                                         ],
//                                         width: 135,
//                                         style: GooglePayButtonStyle.flat,
//                                         type: GooglePayButtonType.pay,
//                                         margin: const EdgeInsets.only(top: 15.0),
//                                         onPaymentResult: onGooglePayResult,
//                                         loadingIndicator: const Center(
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 Positioned(
//                                  // right: 20,
//                                   bottom: 5,
//                                   child: SizedBox(
//                                     width: MediaQuery.of(context).size.width - 75,
//                                     child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: <Widget>[
//                                         Text(
//                                           '${coinListData[index]["name"]}',
//                                           style:
//                                           Theme.of(context).textTheme.headline6!.copyWith(
//                                             fontSize: 20,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${coinListData[index]["price"]}\$',
//                                           style:
//                                           Theme.of(context).textTheme.subtitle2!.copyWith(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//
//
//                                /* Positioned(
//                                   right: 45,
//                                   bottom: 15,
//                                   child: SizedBox(
//                                     width: 75,
//                                     height: 40,
//                                     child:  MaterialButton(
//                                       elevation: 5.0,
//                                       onPressed: (){},
//                                       color: const Color(0xffc52278),
//                                       shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(Radius.circular(10.0))
//                                       ),
//                                       child: const Padding(
//                                         padding: EdgeInsets.only(top: 5),
//                                         child: Text('شراء الان', style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),),
//                                       ),
//                                     ),
//                                   ),
//                                 ),*/
//
//
//
//
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
