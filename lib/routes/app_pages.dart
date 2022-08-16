import 'package:firebase_sample/binding/splash_binding.dart';
import 'package:firebase_sample/ui/main/home_page.dart';
import 'package:firebase_sample/ui/main/main_page.dart';
import 'package:firebase_sample/ui/main/welcome_page.dart';
import 'package:firebase_sample/ui/splash/splash_page.dart';
import 'package:get/get.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainPage(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
    ),
  ];
}
