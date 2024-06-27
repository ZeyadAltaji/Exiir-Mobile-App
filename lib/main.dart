import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:exiir3/Bindings/intialbindings.dart';
import 'package:exiir3/Controller/ConnectivityController.dart';
import 'package:exiir3/Controller/TranslationController.dart';
import 'package:exiir3/Core/Localization/LocaleController.dart';
import 'package:exiir3/Core/Services/MyServices.dart';
import 'package:exiir3/Views/screens/home_page.dart';
import 'package:exiir3/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'helper/language/config/config_lang.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

      await initialServices();

    Get.put(ConnectivityController());
    Get.put(TranslationController());

    // final TranslationController translationController = Get.find();

  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    EasyLocalization(
      supportedLocales: const [ConfigLanguage.EN_LOCALE, ConfigLanguage.AR_LOCALE],
      path: ConfigLanguage.LANG_PATH,
      fallbackLocale: ConfigLanguage.EN_LOCALE,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        LocaleController controller = Get.put(LocaleController());

    return ScreenUtilInit(
      builder: (context, child) {
        // LocaleController controller = Get.put(LocaleController());

        return GetMaterialApp(
          title: "Flutter Demo",
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: HomePage(),
          theme: controller.appTheme ,
          initialBinding: InitialBindings(),
          getPages:routes,
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
