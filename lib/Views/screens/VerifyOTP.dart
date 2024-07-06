import 'dart:async';
import 'package:ExiirEV/Controller/AccountController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Views/Widget/custom_rounded_loading_button.dart';
import 'package:ExiirEV/Views/screens/LoginPhone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VerifyOTP extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyOTP(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController countryController = TextEditingController();
  final accountController = Get.put(AccountControllerImp());

  Timer? _timer;
  int _remainingTime = 60;
  bool _timerExpired = false;
  String _otpCode = "";
  bool _otpError = false; // Track OTP error state

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _timerExpired = true;
        }
      });
    });
  }

  void resendOTP() {
    setState(() {
      _remainingTime = 60;
      _timerExpired = false;
      _otpCode = "";
      _otpError = false; // Reset OTP error state
      startTimer();
    });
    accountController.signUpWithPhoneNumber(widget.phoneNumber);
  }

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
                  style: const TextStyle(
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Appcolors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!_timerExpired && !_otpError)
                  Column(
                    children: [
                      SizedBox(
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            OtpTextField(
                              fieldWidth: 50.0,
                              borderRadius: BorderRadius.circular(20),
                              numberOfFields: 6,
                              borderColor: Appcolors.green,
                              textStyle: const TextStyle(color: Colors.white),
                              onCodeChanged: (String code) {},
                              onSubmit: (String verificationCode) async {
                                setState(() {
                                  _otpCode = verificationCode;
                                });

                                bool verified =
                                    await accountController.verifyOTP(
                                        widget.verificationId,
                                        verificationCode);

                                if (!verified) {
                                  setState(() {
                                    _otpError = true; // Set OTP error state
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translationController
                            .getLanguage(83)
                            .replaceAll('xxxxx', '$_remainingTime'),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Appcolors.white,
                        ),
                      ),
                    ],
                  ),
                if (_timerExpired)
                  ElevatedButton(
                    onPressed: resendOTP,
                    child: Text(translationController.getLanguage(82)),
                  ),
                if (!_timerExpired &&
                    _otpError) // Show Resend OTP button only when OTP error occurs
                  ElevatedButton(
                    onPressed: resendOTP,
                    child: Text(translationController.getLanguage(82)),
                  ),
                if (!_timerExpired &&
                    !_otpError) // Check if OTP error state is false
                  CustomRoundedLoadingButton(
                    controller: accountController.googleController,
                    onPressed: () {
                      Get.to(LoginPhone(phoneNumber: widget.phoneNumber));
                    },
                    color: Appcolors.red,
                    successColor: Appcolors.red,
                    icon: FontAwesomeIcons.arrowLeft,
                    text: translationController.getLanguage(81).trim(),
                  ),
                if (_otpError) // Display error message if OTP error state is true
                  Text(
                    translationController.GetMessages(7),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
