import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Core/Middleware/GlobalMiddleware.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:ExiirEV/Views/screens/Bookingsummary.dart';
import 'package:ExiirEV/Views/screens/BrandsPage.dart';
import 'package:ExiirEV/Views/screens/BrandsPageAdd.dart';
import 'package:ExiirEV/Views/screens/DarkModeScreens.dart';
import 'package:ExiirEV/Views/screens/ListandAddnewCars.dart';
import 'package:ExiirEV/Views/screens/LoginPage.dart';
import 'package:ExiirEV/Views/screens/MyCars.dart';
import 'package:ExiirEV/Views/screens/PhoneNumberPage.dart';
import 'package:ExiirEV/Views/screens/RegistrationPage.dart';
import 'package:ExiirEV/Views/screens/SplashScreen.dart';
import 'package:ExiirEV/Views/screens/home_page.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> routes = [
  GetPage(name: '/', page: () => SplashScreen()),
  GetPage(name: AppRoutes.HomePage, page: () => HomePage()),
  GetPage(name: AppRoutes.LoginPage, page: () => const LoginPage()),
  GetPage(
      name: AppRoutes.RegistrationPage, page: () => const RegistrationPage()),
  GetPage(name: AppRoutes.PhoneNumberPage, page: () => const PhoneNumberPage()),
  GetPage(
      name: AppRoutes.BrandsPage,
      page: () => const BrandsPage(),
      middlewares: [GlobalMiddleware()]),
  GetPage(
    name: AppRoutes.BrandsPageAdd,
    page: () => const BrandsPageAdd(),
  ),
  GetPage(
      name: AppRoutes.ListandAddnewCars,
      page: () => const ListandAddnewCars(),
      middlewares: [GlobalMiddleware(directToAddCars: true)]),
  GetPage(name: AppRoutes.BookingPage, page: () => BookingPage()),
  GetPage(name: AppRoutes.Bookingsummary, page: () => Bookingsummary()),
  GetPage(name: AppRoutes.MyCars, page: () => MyCars()),
  GetPage(name: AppRoutes.DarkModeScreens, page: () => DarkModeScreens()),
];
