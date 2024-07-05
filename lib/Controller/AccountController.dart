import 'dart:convert';

import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Core/Functions/InternetProvider.dart';
import 'package:ExiirEV/Core/Functions/SignInProvider.dart';
import 'package:ExiirEV/Core/Functions/openSnackbar.dart';
import 'package:ExiirEV/Views/screens/VerifyOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:http/http.dart' as http;

abstract class AccountController extends BaseController {
  signInWithGoogle();
  signUpWithGoogle();
  signInWithPhoneNumber();
  signUpWithPhoneNumber(String PhoneNumber);
  sendOTPVerfiy();
  signInWithApple();
  signInWithFacebook();
  GoToPageRegistrationPage();
  GoToPageLoginPage();
  GoToHomePage();
  goToPhoneNumberPage();
}

class AccountControllerImp extends AccountController {
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();
      @override
  signUpWithPhoneNumber(String phoneNumber) async {
    try {
      if (phoneNumber.startsWith("0")) {
        phoneNumber = "+962" + phoneNumber.substring(1);
      }

      final response = await http.post(
        Uri.parse('${Environment.baseUrl}Auth/SentOtp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'To': phoneNumber,
          'From':'+12093403185',
          'Message': 'Your OTP code is: {OTP}',
        }),
      );

      if (response.statusCode == 200) {
        final String verificationId =
            jsonDecode(response.body)['verificationId'];
        Get.to(VerifyOTP(verificationId: verificationId , phoneNumber:phoneNumber));
      } else {
        print('Failed to send OTP');
      }
    } catch (e) {
      print("Failed to verify phone number: $e");
    }
  }
Future<bool> verifyOTP(String verificationId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.baseUrl}Auth/VerifyOtp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'verificationId': verificationId,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        print('OTP verified successfully');
        return true; // Return true if OTP verification succeeds
      } else {
        print('Failed to verify OTP');
        return false; // Return false if OTP verification fails
      }
    } catch (e) {
      print("Failed to verify OTP: $e");
      return false; // Return false on error
    }
  }
  

  @override
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final accessToken = loginResult.accessToken!.tokenString;

      if (accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken);

        return FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: 'Failed to retrieve access token.',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_FAILED',
        message: loginResult.message,
      );
    }
  }



  @override
  Future<void> signInWithGoogle() async {
    try {
      googleController.start();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Prepare user data
        final userData = {
          'us_username': googleUser?.displayName,
          'us_email': googleUser?.email,
          'us_googleId': googleUser?.id,
          'us_is_active': true,
          'us_created_at': DateTime.now().toIso8601String(),
        };

        // Send data to your API
        final response = await http.post(
          Uri.parse('${Environment.baseUrl}Auth/GoogleSignIn'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          Get.toNamed(AppRoutes.BrandsPage);

          googleController.stop();
        } else {
          print('Failed to sign in with Google: ${response.body}');
          googleController.stop();
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      googleController.stop();

      throw Exception('Google authentication failed');
    }
  }

  @override
  Future<void> signUpWithGoogle() async {
    try {
      googleController.start();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Prepare user data
        final userData = {
          'us_username': googleUser?.displayName,
          'us_name': googleUser?.displayName,
          'us_email': googleUser?.email,
          'us_googleId': googleUser?.id,
          'us_is_active': true,
          'us_created_at': DateTime.now().toIso8601String(),
        };

        // Send data to your API
        final response = await http.post(
          Uri.parse('${Environment.baseUrl}Auth/GoogleSignUp'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          Get.toNamed(AppRoutes.BrandsPage);
          googleController.stop();
        } else {
          print('Failed to sign in with Google: ${response.body}');
          googleController.stop();
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      googleController.stop();

      throw Exception('Google authentication failed');
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  }

  @override
  Future<void> signInWithPhoneNumber() async {
    // TODO: implement signInWithPhoneNumber
    throw UnimplementedError();
  }

  // handling facebookauth
  // handling google sigin in
  Future<void> handleFacebookAuth(BuildContext context) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          facebookController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        // handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        // handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  // handle after signin
  // handleAfterSignIn() {
  //   Future.delayed(const Duration(milliseconds: 1000)).then((value) {
  //     // nextScreenReplace(context, const HomeScreen());
  //   });
  // }

  @override
  GoToPageRegistrationPage() {
    Get.toNamed(AppRoutes.RegistrationPage);
  }

  @override
  GoToPageLoginPage() {
    Get.offAllNamed(AppRoutes.LoginPage);
  }
  

  @override
  GoToHomePage() {
    Get.toNamed(AppRoutes.HomePage);
  }

  @override
  goToPhoneNumberPage() {
    Get.toNamed(AppRoutes.PhoneNumberPage);
  }

  @override
  sendOTPVerfiy() {
    // TODO: implement sendOTPVerfiy
    throw UnimplementedError();
  }
}
