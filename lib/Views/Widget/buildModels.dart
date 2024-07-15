 
import 'dart:ui';

import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:ExiirEV/Views/screens/VersionsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildModels(Models models, int? index, Size? size, double crossAxisSpacing,
    double mainAxisSpacing) {
  final translationController = Get.put(TranslationController());

  return GestureDetector(
    onTap: () {
Get.to(() => VersionsPage(), arguments: {'moId': models.moId, 'moBrandId': models.moBrandId});
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
          SizedBox(
            height: size.height * 0.12,
            child: Center(
              child: Hero(
                tag: models.moId!,
                child: Image.network(
                  '${Environment.imageUrl}/${models.moLogo}',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            translationController.Translate(models.moNameAr!, models.moName!),
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

