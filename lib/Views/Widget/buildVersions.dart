 
import 'dart:ui';

import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Controller/VersionsController.dart';
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
  final VersionsController controller = Get.put(
      VersionsController(
        ModelId: versions.veModelId,
        BrandId: versions.veBrandId,
      ),
    );
  return GestureDetector(
    onTap: () {
      controller.SaveUserCars(controller.BrandId!, controller.ModelId!, versions.veId);

    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(size!.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Uncomment the following code if you want to display an image
          // SizedBox(
          //   height: size.height * 0.12,
          //   child: Center(
          //     child: Hero(
          //       tag: versions.veId!,
          //       child: Image.network(
          //          '${Environment.imageUrl}/${versions.veLogo}',
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
        ],
      ),
    ),
  );
}
