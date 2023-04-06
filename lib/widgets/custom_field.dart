// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:howver/utils/colors.dart';

// ignore: must_be_immutable
class CustomField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  bool? obscureText = false;
  double? hintFontSize;
  CustomField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText,
    this.hintFontSize,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: hintFontSize ?? 20,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.4),
          ),
          filled: true,
          fillColor: AppColors.greyColor,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
