import 'dart:convert';

import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';

import 'package:ExiirEV/Views/screens/VerifyOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasty_box/toast_service.dart';

abstract class AccountController extends BaseController {
  signInWithGoogle(BuildContext context);
  signUpWithGoogle(BuildContext context);
  signInWithPhoneNumber();
  signUpWithPhoneNumber(String PhoneNumber);
  sendOTPVerfiy();
  signInWithApple();
  GoToPageRegistrationPage();
  GoToPageLoginPage();
  GoToHomePage();
  goToPhoneNumberPage();
  Future<void> signUpWithFacebook(BuildContext context);
}

class AccountControllerImp extends AccountController {
  final TranslationController translationController =
      Get.put(TranslationController());
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();
  @override
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      googleController.start();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        GoogleAuthProvider.credential(
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
          Uri.parse('${Environment.baseUrl}Auth/GoogleSignIn'),
          headers: {
            'Content-Type': 'application/json',
            'KeyToken': Environment.keyToken
          },
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final userId = responseData['user']['us_user_id'];
          final username = responseData['user']['us_username'];
          final email = responseData['user']['us_email'];
          final googleId = responseData['user']['us_googleId'];
          final token = responseData['token'];
 

          final preferences = await SharedPreferences.getInstance();
          preferences.setString('us_username', username);
          preferences.setString('us_email', email);
          preferences.setString('us_googleId', googleId);
          preferences.setString('IsLoged', 'true');
          preferences.setString('UserId', userId.toString());
          preferences.setString('token', token);

          Get.toNamed(AppRoutes.BrandsPage);

          googleController.stop();
        } else {
          ToastService.showErrorToast(context,
              message: translationController.GetMessages(15));

          print('Failed to sign in with Google: ${response.body}');
          googleController.stop();
        }
      }
    } catch (e) {
      ToastService.showErrorToast(context,
          message: translationController.GetMessages(15));

      googleController.stop();

      throw Exception('Google authentication failed');
    }
  }

  @override
  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      googleController.start();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        GoogleAuthProvider.credential(
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
          headers: {
            'Content-Type': 'application/json',
            'KeyToken': Environment.keyToken
          },
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final userId = responseData['user']['us_user_id'];
          final username = responseData['user']['us_username'];
          final email = responseData['user']['us_email'];
          final googleId = responseData['user']['us_googleId'];
          final token = responseData['token'];
          final preferences = await SharedPreferences.getInstance();
          preferences.setString('us_username', username);
          preferences.setString('us_email', email);
          preferences.setString('us_googleId', googleId);
          preferences.setString('IsLoged', 'true');
          preferences.setString('UserId', userId.toString());
          preferences.setString('token', token);

          Get.toNamed(AppRoutes.BrandsPage);
          googleController.stop();
        } else {
          ToastService.showErrorToast(context,
              message: translationController.GetMessages(15));
          googleController.stop();
        }
      }
    } catch (e) {
      ToastService.showErrorToast(context,
          message: translationController.GetMessages(15));
      googleController.stop();

      throw Exception('Google authentication failed');
    }
  }

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
          'KeyToken': Environment.keyToken
        },
        body: jsonEncode(<String, String>{
          'To': phoneNumber,
          'From': '+12093403185',
          'Message': 'Your OTP code is: {OTP}',
        }),
      );

      if (response.statusCode == 200) {
        final String verificationId =
            jsonDecode(response.body)['verificationId'];
        Get.to(VerifyOTP(
            verificationId: verificationId, phoneNumber: phoneNumber));
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
          'KeyToken': Environment.keyToken
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
  Future<void> signUpWithFacebook(BuildContext context) async {
    try {
      // Log the start of the process
      print("Starting Facebook sign-in process...");

      // Perform Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success && result.accessToken != null) {
        print("Facebook login successful, fetching profile...");
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

        final profile = jsonDecode(graphResponse.body);

        print("Profile fetched: $profile");

        try {
          final userData = {
            'us_username': profile['name'],
            'us_name': profile['name'],
            'us_email': profile['email'],
            'us_facebookid': profile['id'],
            'us_is_active': true,
            'us_created_at': DateTime.now().toIso8601String(),
          };

          print("Sending user data to backend...");
          final response = await http.post(
            Uri.parse('${Environment.baseUrl}Auth/FacebookSignUp'),
            headers: {
              'Content-Type': 'application/json',
              'KeyToken': Environment.keyToken
            },
            body: json.encode(userData),
          );

          if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final userId = responseData['user']['us_user_id'];
          final username = responseData['user']['us_username'];
          final email = responseData['user']['us_email'];
          final facebookid = responseData['user']['us_facebookid'];
          final token = responseData['token'];




            final preferences = await SharedPreferences.getInstance();
            await preferences.setString('us_username', username);
            await preferences.setString('us_email', email);
            await preferences.setString('us_facebookid',facebookid);
            await preferences.setString('IsLoged', 'true');
            await preferences.setString('UserId', userId.toString());
            await preferences.setString('token', token);

            Get.toNamed(AppRoutes.BrandsPage);
            facebookController.stop();
          } else {
            ToastService.showErrorToast(context,
                message: translationController.GetMessages(15));

            facebookController.stop();
          }
        } on FirebaseAuthException catch (e) {
          ToastService.showErrorToast(context,
              message: translationController.GetMessages(15));
          facebookController.stop();
        }
      } else {
        ToastService.showErrorToast(context,
            message: translationController.GetMessages(15));
        facebookController.stop();
      }
    } catch (e) {
      ToastService.showErrorToast(context,
          message: translationController.GetMessages(15));
      throw e;
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // Log the start of the process
      facebookController.start();

      // Perform Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success && result.accessToken != null) {
        print("Facebook login successful, fetching profile...");
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

        final profile = jsonDecode(graphResponse.body);

        print("Profile fetched: $profile");

        try {
          final userData = {
            'us_username': profile['name'],
            'us_name': profile['name'],
            'us_email': profile['email'],
            'us_facebookid': profile['id'],
            'us_is_active': true,
            'us_created_at': DateTime.now().toIso8601String(),
          };

          final response = await http.post(
            Uri.parse('${Environment.baseUrl}Auth/FacebookSignIn'),
            headers: {
              'Content-Type': 'application/json',
              'KeyToken': Environment.keyToken
            },
            body: json.encode(userData),
          );

          if (response.statusCode == 200) {
           final responseData = jsonDecode(response.body);
          final userId = responseData['user']['us_user_id'];
          final username = responseData['user']['us_username'];
          final email = responseData['user']['us_email'];
          final facebookid = responseData['user']['us_facebookid'];
          final token = responseData['token'];




            final preferences = await SharedPreferences.getInstance();
            await preferences.setString('us_username', username);
            await preferences.setString('us_email', email);
            await preferences.setString('us_facebookid',facebookid);
            await preferences.setString('IsLoged', 'true');
            await preferences.setString('UserId', userId.toString());
            await preferences.setString('token', token);

            Get.toNamed(AppRoutes.BrandsPage);
            facebookController.stop();
          } else {
            ToastService.showErrorToast(context,
                message: translationController.GetMessages(15));
            facebookController.stop();
          }
        } on FirebaseAuthException catch (e) {
          ToastService.showErrorToast(context,
              message: translationController.GetMessages(15));
          facebookController.stop();
          throw e;
        }
      } else {
        ToastService.showErrorToast(context,
            message: translationController.GetMessages(15));
        facebookController.stop();
      }
    } catch (e) {
      print('Exception: $e');
      throw e;
    }
  }

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
