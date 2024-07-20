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

Widget buildVersions(Versions versions, int? index, Size? size,
    double crossAxisSpacing, double mainAxisSpacing, String? stationId, String? type) {
  final translationController = Get.put(TranslationController());
  final VersionsController controller = Get.put(
    VersionsController(
      ModelId: versions.veModelId,
      BrandId: versions.veBrandId,
       stationId: stationId,
      type: type,
    ),
  );
  return GestureDetector(
    onTap: () {
      controller.SaveUserCars(
          controller.BrandId!, controller.ModelId!, versions.veId,stationId,type);
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
         
          SizedBox(height: size.height * 0.01),
          Text(
            textAlign: TextAlign.center,
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
