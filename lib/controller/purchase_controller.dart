// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// // import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class FireworksEffect extends StatefulWidget {
//   @override
//   _FireworksEffectState createState() => _FireworksEffectState();
// }

// class _FireworksEffectState extends State<FireworksEffect>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final List<Particle> _particles = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..addListener(() {
//         setState(() {});
//       });
//     _generateParticles();
//     _controller.forward();
//     // اختفاء الـ Dialog بعد 2.5 ثانية
//     Future.delayed(Duration(milliseconds: 600), () {
//       Navigator.of(context).pop(); // إغلاق الـ Dialog بعد انتهاء التأثير
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _generateParticles() {
//     final random = Random();
//     for (int i = 0; i < 100; i++) {
//       _particles.add(
//         Particle(
//           x: 0,
//           y: 0,
//           size: random.nextDouble() * 4 + 2,
//           color: Colors.primaries[random.nextInt(Colors.primaries.length)],
//           velocityX: random.nextDouble() * 4 - 2,
//           velocityY: random.nextDouble() * 4 - 2,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: FireworksPainter(_particles, _controller.value),
//       size: Size.infinite,
//     );
//   }
// }

// class FireworksPainter extends CustomPainter {
//   final List<Particle> particles;
//   final double animationValue;

//   FireworksPainter(this.particles, this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     for (var particle in particles) {
//       particle.update(animationValue);
//       final position = Offset(
//         center.dx + particle.x * 50,
//         center.dy + particle.y * 50,
//       );
//       final paint = Paint()
//         ..color = particle.color.withOpacity(1 - animationValue)
//         ..style = PaintingStyle.fill;
//       canvas.drawCircle(position, particle.size, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class Particle {
//   double x, y, size;
//   final Color color;
//   final double velocityX, velocityY;

//   Particle({
//     required this.x,
//     required this.y,
//     required this.size,
//     required this.color,
//     required this.velocityX,
//     required this.velocityY,
//   });

//   void update(double animationValue) {
//     x += velocityX * animationValue;
//     y += velocityY * animationValue;
//   }
// }

// class PurchaseController extends GetxController {
//   // var availableProducts = <ProductDetails>[].obs; // Available products
//   var purchasedProduct = ''.obs; // Purchased product ID
//   var isLoading = false.obs;
//   var email = ''.obs; // Store the extracted email

//   @override
//   void onInit() {
//     super.onInit();
//     _initializePurchase();
//   }

//   // Initialize in-app purchase
//   Future<void> _initializePurchase() async {
//     // final bool isAvailable = await InAppPurchase.instance.isAvailable();
//     // if (isAvailable) {
//     //   await getAvailableProducts();
//     // } else {
//     //   print("IAP not available");
//     // }
//   }

//   // Fetch available products from Google Play / Apple Store
//   Future<void> getAvailableProducts() async {
//     isLoading(true);
//     const Set<String> _kIds = {
//       '100coins', // SKU for product 1 (100Coins)
//       '1170coins', // SKU for product 2 (1170Coins)
//       '12100coins', // SKU for product 3 (12100Coins)
//       '2950coins', // SKU for product 4 (2950Coins)
//       '560coins', // SKU for product 5 (560Coins)
//       '6000coins', // SKU for product 6 (6000Coins)
//     };

//     // try {
//     //   final ProductDetailsResponse response =
//     //       await InAppPurchase.instance.queryProductDetails(_kIds);
//     //   if (response.notFoundIDs.isNotEmpty) {
//     //     print('Could not find products: ${response.notFoundIDs}');
//     //   }
//     //   availableProducts.value = response.productDetails;
//     // } catch (e, stackTrace) {
//     //   print(e.toString() + ' ' + stackTrace.toString());
//     // }
//     isLoading(false);
//   }

//   // Save the extracted email from WebView
//   void saveEmail(String extractedEmail) {
//     email.value = extractedEmail;
//   }

//   // Request product purchase
//   // Future<void> purchaseProduct(ProductDetails product, context) async {
//   //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
//   //   try {
//   //     bool success = await InAppPurchase.instance
//   //         .buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
//   //     if (success) {
//   //       print('Purchase success');
//   //     } else {
//   //       print('Purchase failed');
//   //     }
//   //   } catch (e) {
//   //     print('Error purchasing product: $e');
//   //   }
//   // }

//   // Post purchase details to the API including the email
// // Function to extract only the number from a string
//   String _extractNumberFromString(String input) {
//     final RegExp regex = RegExp(r'\d+'); // Regular expression to match digits
//     final match = regex.firstMatch(input); // Find the first match
//     return match != null
//         ? match.group(0)!
//         : '0'; // Return the number or 0 if none found
//   }

//   Future<void> _postPurchaseToAPI(
//       context, String productId, String transactionId) async {
//     // Print all the information before posting to API
//     final String numberOnly = _extractNumberFromString(productId);

//     print('Posting Purchase Details:');
//     print('Product ID: $numberOnly');
//     print('Transaction ID: $transactionId');
//     print('Email or Token: ${email.value}');

//     try {
//       // Post the purchase data to the API
//       final response = await http.post(
//         Uri.parse('https://www.lialinaapp.com/api/purchase'),
//         body: {
//           'productId': productId,
//           'transactionId': transactionId,
//           'emailOrToken': email.value, // Email extracted from WebView
//         },
//       );

//       // Handle success
//       if (response.statusCode == 200) {
//         print('Purchase posted successfully to API');
//         showDialog(
//           context: context,
//           builder: (_) => FireworksEffect(),
//         );
//         // Show success snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('تم الدفع بنجاح وشراء عملة $numberOnly!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         // Handle API failure
//         print('Failed to post purchase, status code: ${response.statusCode}');
//         print('Response body: ${response.body}');

//         // Show error snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Purchase failed, please try again.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (error, stackTrace) {
//       // Handle any exceptions or errors during the request
//       print('Error occurred while posting purchase: $error $stackTrace');

//       // Show error snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An error occurred, please try again later.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // StreamSubscription<List<PurchaseDetails>>? purchaseSubscription;

//   // // Handle purchases update
//   // void listenToPurchases(BuildContext context) {
//   //   final Stream<List<PurchaseDetails>> purchaseUpdated =
//   //       InAppPurchase.instance.purchaseStream;

//   //   // Save the subscription to be able to cancel it later
//   //   purchaseSubscription = purchaseUpdated.listen((purchaseDetailsList) {
//   //     print('Listening for purchase updates...');
//   //     for (var purchaseDetails in purchaseDetailsList) {
//   //       if (purchaseDetails.status == PurchaseStatus.purchased) {
//   //         print('Purchase successful.');

//   //         // Handle successful purchase
//   //         _postPurchaseToAPI(context, purchaseDetails.productID!,
//   //             purchaseDetails.transactionDate!);
//   //         purchasedProduct.value = purchaseDetails.productID;
//   //       } else if (purchaseDetails.status == PurchaseStatus.error) {
//   //         // Handle error in purchase
//   //         print('Error purchasing product: ${purchaseDetails.error}');
//   //       }
//   //     }
//   //   });
//   // }

// // Function to cancel the subscription
//   // void stopListeningToPurchases() {
//   //   if (purchaseSubscription != null) {
//   //     purchaseSubscription!.cancel(); // Cancel the subscription
//   //     print('Stopped listening for purchase updates.');
//   //   }
//   // }

//   @override
//   void onClose() {
//     super.onClose();
//     // stopListeningToPurchases();
//   }
// }
