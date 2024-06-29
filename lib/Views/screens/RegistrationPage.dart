import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());
    final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
    final RoundedLoadingButtonController googleController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController facebookController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController twitterController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController phoneController =
        RoundedLoadingButtonController();
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
                RoundedLoadingButton(
                  onPressed: () {
                    // handleGoogleSignIn();
                  },
                  controller: googleController,
                  successColor: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.80,
                  elevation: 0,
                  borderRadius: 25,
                  color: Colors.red,
                  child: Wrap(
                    children: [
                      const Icon(
                        FontAwesomeIcons.google, // donwload
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(translationController.getLanguage(72).trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // facebook login button
                RoundedLoadingButton(
                  onPressed: () {
                    // handleTwitterAuth();
                  },
                  controller: facebookController,
                  successColor: Colors.blue,
                  width: MediaQuery.of(context).size.width * 0.80,
                  elevation: 0,
                  borderRadius: 25,
                  color: Colors.blue,
                  child: Wrap(
                    children: [
                      const Icon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(translationController.getLanguage(73).trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // twitter loading button
                RoundedLoadingButton(
                  onPressed: () {
                    // handleTwitterAuth();
                  },
                  controller: twitterController,
                  successColor: Colors.lightBlue,
                  width: MediaQuery.of(context).size.width * 0.80,
                  elevation: 0,
                  borderRadius: 25,
                  color: Colors.lightBlue,
                  child: Wrap(
                    children: [
                      const Icon(
                        FontAwesomeIcons.twitter,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(translationController.getLanguage(74).trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // phoneAuth loading button
                RoundedLoadingButton(
                  onPressed: () {
                    // nextScreenReplace(context, const PhoneAuthScreen());
                    phoneController.reset();
                  },
                  controller: phoneController,
                  successColor: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.80,
                  elevation: 0,
                  borderRadius: 25,
                  color: Colors.black,
                  child: Wrap(
                    children: [
                      const Icon(
                        FontAwesomeIcons.phone,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(translationController.getLanguage(75).trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (isIPhone)
                  RoundedLoadingButton(
                    onPressed: () {
                      // nextScreenReplace(context, const PhoneAuthScreen());
                      phoneController.reset();
                    },
                    controller: phoneController,
                    successColor: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    color: Colors.black,
                    child: Wrap(
                      children: [
                        const Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(translationController.getLanguage(76).trim(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
