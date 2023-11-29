import "package:flutter/material.dart";
import 'package:miniproject/Components/color.dart';

class AuthField extends StatelessWidget {
  final controller;
  final String hintText;
  final IconData icon;
  final bool obscureText; //hiding textfield

  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.mainColor1),
              ),
              prefixIcon: Icon(icon),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.mainColor1),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.lightTextColor))),
    );
  }
}
