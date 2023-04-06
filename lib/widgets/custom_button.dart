import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/utils/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final double widthPercent;
  double? radius;
  CustomButton({
    super.key,
    required this.onPressed,
    required this.btnText,
    this.radius,
    required this.widthPercent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: Get.width * widthPercent,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 15),
          ),
        ),
        child: Text(
          btnText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
