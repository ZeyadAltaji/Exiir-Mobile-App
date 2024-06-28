import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:flutter/material.dart';

 ThemeData ThemeEn = ThemeData(
        fontFamily: "PlayfairDisplay",
        textTheme: const TextTheme(
          headlineLarge:   TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Appcolors.Black,
                fontFamily: "PlayfairDisplay",

              ),
          bodyLarge : TextStyle(
                  height: 2,
                  color: Appcolors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "PlayfairDisplay",

                  
                ),
                
        ),
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      );
      ThemeData ThemeAr = ThemeData(
        fontFamily: "Almarai",
        textTheme: const TextTheme(
          headlineLarge:   TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Appcolors.Black,
                fontFamily: "Almarai",

              ),
          bodyLarge : TextStyle(
                  height: 2,
                  color: Appcolors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Almarai",

                  
                ),
                
        ),
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      );