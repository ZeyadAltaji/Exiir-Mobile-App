import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Services/MyServices.dart';

void showOfflineDialog() {
  MyServices services = Get.find();
  String? langcode = services.sharedPreferences.getString("lang");

  String title;
  String content;
  String BtnText;

  if (Get.locale?.languageCode == 'ar') {
    title = 'حالة الاتصال';
    content = 'أنت غير متصل';
    BtnText = 'حسنا';
  } else if (Get.locale?.languageCode == 'en') {
    title = 'Connectivity Status';
    content = 'You are offline';
    BtnText = 'OK';
  } else {
    title = 'Connectivity Status';
    content = 'You are offline';
    BtnText = 'OK';
  }

  if (Get.isDialogOpen != true) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text(BtnText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
