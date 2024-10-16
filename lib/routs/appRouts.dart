import 'package:get/get.dart';

import '../binding/PackageBinding.dart';
import '../view/PackagePage.dart';




appRoutes() => [
  GetPage(
      name: '/PackagePage',
      page: () => const PackagePage(),
      binding: PackageBinding(),
      transitionDuration: const Duration(milliseconds: 0)
  )
];

