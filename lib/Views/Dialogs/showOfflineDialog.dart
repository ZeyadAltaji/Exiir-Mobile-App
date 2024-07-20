import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Services/MyServices.dart';
import '../../Core/Constant/ImgaeAssets.dart';

void showOfflineDialog() {
  MyServices services = Get.find();
  String? langcode = services.sharedPreferences.getString("lang");

  String title;
  String content;
  String btnText;

  if (Get.locale?.languageCode == 'ar') {
    title = 'حالة الاتصال';
    content = ' أنت غير متصل بالانترنت';
    btnText = 'حسنا';
  } else if (Get.locale?.languageCode == 'en') {
    title = 'Connectivity Status';
    content = 'You are offline';
    btnText = 'OK';
  } else {
    title = 'Connectivity Status';
    content = 'You are offline';
    btnText = 'OK';
  }

  if (!Get.isDialogOpen!) {
    Get.dialog(
      dialogshow(
        title: title,
        content: content,
        btnText: btnText,
      ),
    );
  }
}

class dialogshow extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;

  dialogshow({
    required this.title,
    required this.content,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          exit(0); // Close the dialog
                        },
                        child: Text(btnText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -50,
            child: CircleAvatar(
              radius: 50,
              child: Image.asset(AppimageUrlAsset.logo),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
