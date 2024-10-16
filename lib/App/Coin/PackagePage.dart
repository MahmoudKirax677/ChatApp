import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:zefaf/App/Coin/widgets/AppBar.dart';
import '../../help/globals.dart' as globals;
import '../../services/controller/PaymentController.dart';

class PackagePage extends GetView<PaymentController> {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.pink.shade200,
          ),
        ),
        controller.obx((state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: appBar(context),
              body: Stack(
                children: [
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: SizedBox(
                          // height: Get.height,
                          width: Get.width,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            // runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: List.generate(
                                state!.item1.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        globals.coinsId =
                                            state.item2.data[index].id;
                                        globals.appContext = context;
                                        controller
                                            .tryPurchase(state.item1[index]);
                                      },
                                      child: Container(
                                        width: Get.width / 2 - 10,
                                        //height: 220,
                                        decoration: BoxDecoration(
                                            border: const GradientBoxBorder(
                                              gradient: LinearGradient(colors: [
                                                Colors.white,
                                                Colors.black
                                              ]),
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: LinearGradient(
                                                begin:
                                                    FractionalOffset.topCenter,
                                                end: FractionalOffset
                                                    .bottomCenter,
                                                colors: [
                                                  controller.accentColor
                                                      .withOpacity(0.5),
                                                  controller.accentColor
                                                ],
                                                stops: const [
                                                  0.0,
                                                  0.5
                                                ])),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              '💰 Get Coins',
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              state.item2.data[index]
                                                  .coinsAmount,
                                              textDirection: TextDirection.rtl,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Align(
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    'assets/icons/dollar.png',
                                                    height: 45)),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  globals.coinsId = state
                                                      .item2.data[index].id;
                                                  globals.appContext = context;
                                                  controller.tryPurchase(
                                                      state.item1[index]);
                                                },
                                                child: const Text("شراء",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        letterSpacing: 1.5,
                                                        color: Colors.white),
                                                    strutStyle: StrutStyle(
                                                      forceStrutHeight: true,
                                                      height: 1,
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                state.item1[index].price,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
