import 'package:castlog/controllers/tackle_box_controller.dart';
import 'package:castlog/layout.dart';
import 'package:castlog/routes/app_routes.dart';
import 'package:castlog/views/setup_form_screen.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TackleBoxController>(() => TackleBoxController());
  }
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const Layout(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.setupForm,
      page: () => const SetupFormScreen(),
    ),
  ];
}
