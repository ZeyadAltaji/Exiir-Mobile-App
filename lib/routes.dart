import 'package:ExiirEV/Views/screens/LoginPage.dart';
import 'package:ExiirEV/Views/screens/SplashScreen.dart';
import 'package:ExiirEV/Views/screens/home_page.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  // GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/', page: () => LoginPage()),

  GetPage(name: '/HomePage', page: () => HomePage()),
];
