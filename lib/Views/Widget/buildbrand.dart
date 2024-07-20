import 'dart:ui';

import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Model/Brands.dart';
import 'package:ExiirEV/Views/screens/ModelsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildbrand(Brands brand, int index, Size size, double crossAxisSpacing,
    double mainAxisSpacing, String? stationId, String? type) {
  final translationController = Get.put(TranslationController());

  return GestureDetector(
    onTap: () {
      Get.to(() => ModelsPage(), arguments: {
        'brandId': brand.brId,
        'stationId': stationId,
        'type': type,
      });
    },
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.all(size.width * 0.04),
      width: size.width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.12,
            child: Center(
              child: Hero(
                tag: brand.brId!,
                child: Image.network(
                  '${Environment.imageUrl}/${brand.brLogo}',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            translationController.Translate(brand.brNameAr!, brand.brName!),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    ),
  );
}
