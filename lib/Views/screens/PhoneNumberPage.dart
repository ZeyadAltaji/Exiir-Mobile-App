import 'package:ExiirEV/Controller/AccountController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Views/Widget/custom_rounded_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<PhoneNumberPage> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    countryController.text = "+962";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());
    final accountController = Get.put(AccountControllerImp());

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Appcolors.logotwo, Appcolors.logoone],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppimageUrlAsset.logo,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  translationController.getLanguage(1).trim(),
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Appcolors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  translationController.getLanguage(70),
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Appcolors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Appcolors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Appcolors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                                              controller: phoneNumberController,

                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: translationController.getLanguage(17),
                          hintStyle:
                              TextStyle(fontSize: 16, color: Appcolors.white),
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomRoundedLoadingButton(
                  controller: accountController.phoneController,
                   onPressed: () async {
                    try {
                      await accountController.signUpWithPhoneNumber(
                        countryController.text + phoneNumberController.text,
                      );
                    } catch (e) {
                      print("Failed to sign up: $e");
                    }
                  },
                  color: Appcolors.red,
                  successColor: Appcolors.red,
                  icon: FontAwesomeIcons.arrowLeft,
                  text: translationController.getLanguage(80).trim(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
