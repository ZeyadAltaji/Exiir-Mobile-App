import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ExiirEV/Bindings/intialbindings.dart';
import 'package:ExiirEV/Controller/ConnectivityController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Localization/LocaleController.dart';
import 'package:ExiirEV/Core/Services/MyServices.dart';
import 'package:ExiirEV/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  Get.put(LocaleController());
  Get.put(ConnectivityController());
  Get.put(TranslationController());

  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final TranslationController translationController = Get.find();
  await translationController.fetchLanguage();
  await translationController.fetchMessages();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      locale: controller.language,
      debugShowCheckedModeBanner: false,
      theme: controller.appTheme,
      initialBinding: InitialBindings(),
      getPages: routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
