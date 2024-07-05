import 'dart:ui';

import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildModels(Models models, [int? index, Size? size]) {
  final translationController = Get.put(TranslationController());

  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    padding: EdgeInsets.all(size!.width * 0.04),
    width: size.width * 0.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.12,
          child: Center(
            child: Hero(
              tag: models.moId!,
              child: Image.network(
                'https://res.cloudinary.com/dk5eekms5/image/upload/v1681947361/a55buce4haifci2aarcb.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        // Text with button in a row
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                translationController.Translate(models.moNameAr!, models.moName!),
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('Button'),
            ),
          ],
        ),
      ],
    ),
  );
}
