import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefaf/controller/PackageController.dart';
import 'package:zefaf/view/webview.dart';

import 'Widgets/AppBar.dart';

class PackagePage extends GetView<PackageController> {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewScreen(
      link: 'https://lialinaapp.com/',
    );
  }
}
