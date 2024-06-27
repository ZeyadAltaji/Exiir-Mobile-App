import 'package:exiir3/Controller/BaseController.dart';
import 'package:exiir3/Core/Services/MyServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../Constant/AppTheme.dart';

class LocaleController extends BaseController{
    Locale? language;
    MyServices myServices = Get.find();
    ThemeData appTheme = ThemeEn;
    changeLang(String langcode) {
    Locale locale = Locale(langcode) ; 
    myServices.sharedPreferences.setString("lang", langcode) ; 
    appTheme = langcode == 'ar' ? ThemeAr : ThemeEn;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale) ; 
  }
  @override
  void onInit(){
    String ? GetLang = myServices.sharedPreferences.getString('lang');
    if(GetLang == 'ar')
    {
      language = const Locale('ar'); 
      appTheme = ThemeAr;
    }
    else if (GetLang == 'en') {
      language = const Locale('en');appTheme = ThemeEn;
    }
    else {
      language =  Locale(Get.deviceLocale!.languageCode) ; 
    }
    super.onInit(); 
  }
}