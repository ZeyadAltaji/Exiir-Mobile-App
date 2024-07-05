import 'dart:async';
import 'package:ExiirEV/Controller/AccountController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Views/Widget/custom_rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
 class LoginPhone extends StatefulWidget {
    final String phoneNumber;


  const LoginPhone(
      {super.key, required this.phoneNumber});
  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final accountController = Get.put(AccountControllerImp());

  

 
 @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Appcolors.logotwo, Appcolors.logoone],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppimageUrlAsset.logo,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 25),
                Text(
                  translationController.getLanguage(1).trim(),
                  style: TextStyle(
                    fontSize: 28,
                    color: Appcolors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  translationController.getLanguage(70),
                  style: TextStyle(
                    fontSize: 20,
                    color: Appcolors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                 
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        style:const TextStyle(color: Appcolors.white),
                        cursorColor: Appcolors.white,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:  BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          hintText: translationController.getLanguage(3),
                          hintStyle: TextStyle(
                            fontSize: 19,
                            color: Appcolors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style:const TextStyle(color: Appcolors.white),
                        cursorColor: Appcolors.white,
                        decoration: InputDecoration(
                          border:const OutlineInputBorder(),
                          enabledBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          hintText: translationController.getLanguage(4),
                          hintStyle: TextStyle(
                            fontSize: 19,
                            color: Appcolors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: const TextStyle(color: Appcolors.white),
                        cursorColor: Appcolors.white,
                        decoration: InputDecoration(
                          border:const OutlineInputBorder(),
                          enabledBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          focusedBorder:const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Appcolors.white, // Border color here
                            ),
                          ),
                          hintText: translationController.getLanguage(84),
                          hintStyle: TextStyle(
                            fontSize: 19,
                            color: Appcolors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomRoundedLoadingButton(
                  controller: accountController.phoneController,
                  onPressed: () async {
                    try {
                      
                    } catch (e) {
                      print("Failed to sign up: $e");
                    }
                  },
                  color: Appcolors.red,
                  successColor: Appcolors.red,
                  icon: FontAwesomeIcons.arrowLeft,
                  text: translationController.getLanguage(81).trim(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}