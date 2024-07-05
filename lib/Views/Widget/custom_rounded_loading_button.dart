import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CustomRoundedLoadingButton extends StatelessWidget {
  final RoundedLoadingButtonController controller;
  final VoidCallback onPressed;
  final Color color;
  final Color successColor;
  final IconData icon;
  final String text;

  const CustomRoundedLoadingButton({
    Key? key,
    required this.controller,
    required this.onPressed,
    required this.color,
    required this.successColor,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.locale!.languageCode == 'ar'){
 return RoundedLoadingButton(
      controller: controller,
      onPressed: onPressed,
      successColor: successColor,
      width: MediaQuery.of(context).size.width * 0.80,
      elevation: 0,
      borderRadius: 25,
      color: color,
      child: Wrap(
        
        children: [
         
        
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
            const SizedBox(
            width: 15,
          ),
           Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
    }else{
       return RoundedLoadingButton(
      controller: controller,
      onPressed: onPressed,
      successColor: successColor,
      width: MediaQuery.of(context).size.width * 0.80,
      elevation: 0,
      borderRadius: 25,
      color: color,
      child: Wrap(
        
        children: [
         
        
           Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
    }
   
  }
}
