import 'package:flutter_supabase_boilerplate/routes/app_routes.dart';
import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/views/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
  ];
}
