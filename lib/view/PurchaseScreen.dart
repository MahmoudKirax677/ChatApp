import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get/get.dart';
import 'package:zefaf/controller/purchase_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as sp;

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen>
    with TickerProviderStateMixin {
  final PurchaseController controller = Get.put(PurchaseController());
  int _currentIndex = 0; // To track the active slide
  late AnimationController _controller; // Animation controller for coins
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    controller.getAvailableProducts();

    // Initialize the AnimationController with a longer duration to slow down the animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Make the full loop longer
    )..repeat(); // Repeat the animation indefinitely

    // Curved animation for smooth falling
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Linear fall for more controlled timing
    );
    // controller.listenToPurchases(context);
  }

// Function to cancel the subscription
  void stopListeningToPurchases() {
    // if (controller.purchaseSubscription != null) {
    //   controller.purchaseSubscription!.cancel(); // Cancel the subscription
    //   print('Stopped listening for purchase updates.');
    // }
  }

// Call this function when navigating back or disposing the screen

  @override
  void dispose() {
    stopListeningToPurchases(); // Stop the purchase listener
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2F45), // Dark gray-blue background color
      appBar: AppBar(
        title: Text('شراء كوينز 🌍', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Falling coins animation in the background

          // Main content of the screen
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: // Show loading if page is loading or during the first 5 seconds
                    sp.SpinKitCircle(
                  size: 50.0,
                  color: Colors.red,
                ),
              );
            }
            return Column(
              children: [
                // // Display user's currency or points at the top
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: Text(
                //     'اشتري الان',
                //     style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.amber,
                //     ),
                //   ),
                // ),
                // // Carousel Slider for products
                // Expanded(
                //   child: CarouselSlider.builder(
                //     itemCount: controller.availableProducts.length,
                //     itemBuilder: (context, index, realIdx) {
                //       ProductDetails product =
                //           controller.availableProducts[index];
                //       bool isBestSeller =
                //           index == 1; // فرضًا أن العنصر الثاني هو الأكثر مبيعًا

                //       return InkWell(
                //         onTap: () {
                //           // Call the purchase function
                //           controller.purchaseProduct(product, context);
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
                //           child: Stack(
                //             children: [
                //               Card(
                //                 elevation: 6,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(20),
                //                 ),
                //                 color: Color(0xFF1F2340),
                //                 child: Container(
                //                   width:
                //                       MediaQuery.of(context).size.width * 0.5,
                //                   padding: EdgeInsets.all(16),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       // Display the coin image
                //                       Image.asset(
                //                         'assets/logo/Coins.png', // Use the correct asset here
                //                         height: 60,
                //                       ),
                //                       SizedBox(height: 10),
                //                       // Display the coin amount with animation
                //                       AnimatedDefaultTextStyle(
                //                         duration:
                //                             const Duration(milliseconds: 300),
                //                         style: TextStyle(
                //                           fontSize:
                //                               _currentIndex == index ? 28 : 24,
                //                           fontWeight: FontWeight.bold,
                //                           color: Colors.amber,
                //                         ),
                //                         child: Text(product.description),
                //                       ),
                //                       SizedBox(height: 10),
                //                       // Display the price with animation
                //                       AnimatedDefaultTextStyle(
                //                         duration:
                //                             const Duration(milliseconds: 300),
                //                         style: TextStyle(
                //                           fontSize:
                //                               _currentIndex == index ? 16 : 14,
                //                           fontWeight: FontWeight.w600,
                //                           color: Colors.white70,
                //                         ),
                //                         child: Text('${product.price}'),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               // Add badge for best seller
                //               if (isBestSeller)
                //                 AnimatedPositioned(
                //                   top: 5,
                //                   right: 5,
                //                   duration: Duration(milliseconds: 500),
                //                   curve: Curves.easeInOut,
                //                   child: Container(
                //                     padding: EdgeInsets.symmetric(
                //                         vertical: 5, horizontal: 10),
                //                     decoration: BoxDecoration(
                //                       color: Colors.redAccent,
                //                       borderRadius: BorderRadius.only(
                //                           bottomLeft: Radius.circular(10)),
                //                     ),
                //                     child: Text(
                //                       'الأكثر مبيعًا',
                //                       style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 14,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //     options: CarouselOptions(
                //       height: 400.0,
                //       autoPlay: false,
                //       enlargeCenterPage: true,
                //       viewportFraction: 0.6,
                //       aspectRatio: 2.0,
                //       onPageChanged: (index, reason) {
                //         setState(() {
                //           _currentIndex = index;
                //         });
                //       },
                //     ),
                //   ),
                // ),

                // // Dots indicator
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children:
                //       controller.availableProducts.asMap().entries.map((entry) {
                //     return GestureDetector(
                //       onTap: () => setState(() => _currentIndex = entry.key),
                //       child: Container(
                //         width: 8.0,
                //         height: 8.0,
                //         margin: EdgeInsets.symmetric(
                //             vertical: 10.0, horizontal: 4.0),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color:
                //               (Theme.of(context).brightness == Brightness.dark
                //                       ? Colors.white
                //                       : Colors.black)
                //                   .withOpacity(
                //                       _currentIndex == entry.key ? 0.9 : 0.4),
                //         ),
                //       ),
                //     );
                //   }).toList(),
                // ),
                // // Floating action button in the center
                // Padding(
                //   padding: const EdgeInsets.only(top: 16),
                //   child: FloatingActionButton(
                //     backgroundColor: Color(0xFFF85E71), // Pinkish button
                //     onPressed: () {
                //       // Your action here
                //       Get.back();
                //     },
                //     child: Icon(Icons.cancel),
                //   ),
                // ),
                // SizedBox(height: 20),
                // // Bottom navigation bar like in the design
                // // BottomNavigationBar(
                // //   backgroundColor: Color(0xFF2A2F45),
                // //   selectedItemColor: Colors.white,
                // //   unselectedItemColor: Colors.grey[400],
                // //   items: [
                // //     BottomNavigationBarItem(
                // //       icon: Icon(Icons.person_outline),
                // //       label: 'حسابي',
                // //     ),
                // //     BottomNavigationBarItem(
                // //       icon: Icon(Icons.chat),
                // //       label: 'المحادثات',
                // //     ),
                // //   ],
                // // ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
