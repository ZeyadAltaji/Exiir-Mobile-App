import 'package:ExiirEV/Controller/AccountController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Views/Widget/TextSignUp.dart';
import 'package:ExiirEV/Views/Widget/custom_rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());
    final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
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
                  translationController.getLanguage(5).trim(), // login
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
                  controller: accountController.googleController,
                  onPressed: () {
                    accountController.signInWithGoogle();

                  },
                  color: Appcolors.red,
                  successColor: Appcolors.red,
                  icon: FontAwesomeIcons.google,
                  text: translationController.getLanguage(67).trim(),
                ),
                const SizedBox(height: 10),
                CustomRoundedLoadingButton(
                  controller: accountController.facebookController,
                  onPressed: () {
                    accountController.handleFacebookAuth(context);
                  },
                  color: Appcolors.blue,
                  successColor: Appcolors.blue,
                  icon: FontAwesomeIcons.facebook,
                  text: translationController.getLanguage(68).trim(),
                ),
                const SizedBox(height: 10),
            
                CustomRoundedLoadingButton(
                  controller: accountController.phoneController,
                  onPressed: () {
                    accountController.phoneController.reset();
                  },
                  color: Appcolors.Black,
                  successColor: Appcolors.Black,
                  icon: FontAwesomeIcons.phone,
                  text: translationController.getLanguage(70).trim(),
                ),
                const SizedBox(height: 10),
                if (isIPhone)
                  CustomRoundedLoadingButton(
                    controller: accountController.phoneController,
                    onPressed: () {
                      accountController.phoneController.reset();
                    },
                    color: Appcolors.Black,
                    successColor: Appcolors.Black,
                    icon: FontAwesomeIcons.apple,
                    text: translationController.getLanguage(71).trim(),
                  ),
                const SizedBox(height: 30),
                Textsignup(
                  textone: translationController.getLanguage(78),
                  textTow: translationController.getLanguage(77),
                  onTap: () {
                    accountController.GoToPageRegistrationPage();
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
