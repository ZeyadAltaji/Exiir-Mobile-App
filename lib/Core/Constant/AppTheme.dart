import 'package:ExiirEV/Core/Constant/AppFonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:flutter/material.dart';

// Define your fonts
  // Ensure this is properly imported

// Define your themes
ThemeData ThemeEn = ThemeData(
  fontFamily: fontEn.fontFamily,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Appcolors.Black,
      fontFamily: "PlayfairDisplay",
    ),
    bodyLarge: TextStyle(
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
  fontFamily: fontAr.fontFamily,  // Use fontAr directly if properly imported
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Appcolors.Black,
     ),
    bodyLarge: TextStyle(
      height: 2,
      color: Appcolors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      fontFamily: "Cairo",
    ),
  ),
  primarySwatch: Colors.blue,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
