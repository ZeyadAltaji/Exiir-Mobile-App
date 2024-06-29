
import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Functions/InternetProvider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

abstract class AccountController extends BaseController{
    handleGoogleSignIn();
    handleFacebookAuth();
    handleTwitterAuth();
    handleAfterSignIn();
   

}
class AccountControllerImp extends AccountController{
    final RoundedLoadingButtonController googleController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController facebookController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController twitterController =
        RoundedLoadingButtonController();
    final RoundedLoadingButtonController phoneController =
        RoundedLoadingButtonController();

   Future handleGoogleSignIn() async {
    // final sp ;
    //     final ip ;

    // // final sp = context.read<SignInProvider>();
    // // final ip = context.read<InternetProvider>();
    // await ip.checkInternetConnection();

    // if (ip.hasInternet == false) {
    //   // openSnackbar(context, "Check your Internet connection", Colors.red);
    //   googleController.reset();
    // } else {
    //   await sp.signInWithGoogle().then((value) {
    //     if (sp.hasError == true) {
    //       // openSnackbar(context, sp.errorCode.toString(), Colors.red);
    //       googleController.reset();
    //     } else {
    //       // checking whether user exists or not
    //       sp.checkUserExists().then((value) async {
    //         if (value == true) {
    //           // user exists
    //           await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     googleController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         } else {
    //           // user does not exist
    //           sp.saveDataToFirestore().then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     googleController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         }
    //       });
    //     }
    //   });
    // }
  }
  Future handleTwitterAuth() async {
    // final sp = context.read<SignInProvider>();
    // final ip = context.read<InternetProvider>();
    // await ip.checkInternetConnection();

    // if (ip.hasInternet == false) {
    //   openSnackbar(context, "Check your Internet connection", Colors.red);
    //   googleController.reset();
    // } else {
    //   await sp.signInWithTwitter().then((value) {
    //     if (sp.hasError == true) {
    //       openSnackbar(context, sp.errorCode.toString(), Colors.red);
    //       twitterController.reset();
    //     } else {
    //       // checking whether user exists or not
    //       sp.checkUserExists().then((value) async {
    //         if (value == true) {
    //           // user exists
    //           await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     twitterController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         } else {
    //           // user does not exist
    //           sp.saveDataToFirestore().then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     twitterController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         }
    //       });
    //     }
    //   });
    // }
  }
  // handling facebookauth
  // handling google sigin in
  Future handleFacebookAuth() async {
    // final sp = context.read<SignInProvider>();
    // final ip = context.read<InternetProvider>();
    // await ip.checkInternetConnection();

    // if (ip.hasInternet == false) {
    //   openSnackbar(context, "Check your Internet connection", Colors.red);
    //   facebookController.reset();
    // } else {
    //   await sp.signInWithFacebook().then((value) {
    //     if (sp.hasError == true) {
    //       openSnackbar(context, sp.errorCode.toString(), Colors.red);
    //       facebookController.reset();
    //     } else {
    //       // checking whether user exists or not
    //       sp.checkUserExists().then((value) async {
    //         if (value == true) {
    //           // user exists
    //           await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     facebookController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         } else {
    //           // user does not exist
    //           sp.saveDataToFirestore().then((value) => sp
    //               .saveDataToSharedPreferences()
    //               .then((value) => sp.setSignIn().then((value) {
    //                     facebookController.success();
    //                     handleAfterSignIn();
    //                   })));
    //         }
    //       });
    //     }
    //   });
    // }
  }

  // handle after signin
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      // nextScreenReplace(context, const HomeScreen());
    });
  }
}