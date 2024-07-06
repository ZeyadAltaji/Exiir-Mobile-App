import 'dart:ui';

import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:ExiirEV/Model/Versions.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildVersions(Versions versions, int? index, Size? size, double crossAxisSpacing,
    double mainAxisSpacing) {
  final translationController = Get.put(TranslationController());

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    padding: EdgeInsets.all(size!.width * 0.04),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // SizedBox(
        //   height: size.height * 0.12,
        //   child: Center(
        //     child: Hero(
        //       tag: models.moId!,
        //       child: Image.network(
        //          '${Environment.imageUrl}/${models.moLogo}',
        //         fit: BoxFit.fitWidth,
        //       ),
        //     ),
        //   ),
        // ),
         SizedBox(height: size.height * 0.01),
        Text(
          translationController.Translate(versions.veName!, versions.veName!),
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
          SizedBox(height: size.height * 0.001),
        const Spacer(),
        Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: () {
                    Get.to(() => BookingPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.kPrimaryColorShadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              translationController.getLanguage(88),
              style: const TextStyle(
                color: Appcolors.kPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

