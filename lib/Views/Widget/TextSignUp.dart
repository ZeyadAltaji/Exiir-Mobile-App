import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:flutter/material.dart';

class Textsignup extends StatelessWidget {
  final String textone;
  final String textTow;
  final void Function() onTap;

  const Textsignup(
      {super.key,
      required this.textone,
      required this.textTow,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textone,
            style: const TextStyle(
                color: Appcolors.white, fontWeight: FontWeight.bold)),
        InkWell(
          onTap: onTap,
          child: Text(
            textTow,
            style: const TextStyle(
                color: Appcolors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
