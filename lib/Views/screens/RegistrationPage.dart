import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Views/Widget/TextSignUp.dart';
import 'package:ExiirEV/Views/Widget/custom_rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../Controller/AccountController.dart';
 
class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());
     final RoundedLoadingButtonController googleController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController facebookController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController twitterController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController phoneController =
        RoundedLoadingButtonController();
            final accountController = Get.put(AccountControllerImp());

    // Check if the device is an iPhone
    bool isIPhone = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Appcolors.logotwo, Appcolors.logoone],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppimageUrlAsset.logo,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  translationController.getLanguage(1).trim(),
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Appcolors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  translationController.getLanguage(77).trim(), // Sign Up
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Appcolors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRoundedLoadingButton(
                  controller: googleController,
                  onPressed: () {
                    accountController.signUpWithGoogle();
                  },
                  color: Appcolors.red,
                  successColor: Appcolors.red,
                  icon: FontAwesomeIcons.google,
                  text: translationController.getLanguage(72).trim(),
                ),
                const SizedBox(height: 10),
                CustomRoundedLoadingButton(
                  controller: facebookController,
                  onPressed: () async {
                   await  accountController.signInWithFacebook();
                  },
                  color: Appcolors.blue,
                  successColor: Appcolors.blue,
                  icon: FontAwesomeIcons.facebook,
                  text: translationController.getLanguage(73).trim(),
                ),
                const SizedBox(height: 10),
                
                CustomRoundedLoadingButton(
                  controller: phoneController,
                  onPressed: () {
                    accountController.goToPhoneNumberPage();
                   },
                  color: Appcolors.Black,
                  successColor: Appcolors.Black,
                  icon: FontAwesomeIcons.phone,
                  text: translationController.getLanguage(75).trim(),
                ),
                const SizedBox(height: 10),
                if (isIPhone)
                  CustomRoundedLoadingButton(
                    controller: phoneController,
                    onPressed: () {
                      phoneController.reset();
                    },
                    color: Appcolors.Black,
                    successColor: Appcolors.Black,
                    icon: FontAwesomeIcons.apple,
                    text: translationController.getLanguage(76).trim(),
                  ),

                const SizedBox(height: 30),
                Textsignup(
                  textone: translationController.getLanguage(79),
                  textTow: translationController.getLanguage(5),
                  onTap: () {
                    accountController.GoToPageLoginPage();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
