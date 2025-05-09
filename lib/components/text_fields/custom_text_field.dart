import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool? showPassword;
  final VoidCallback? onToggle;

  const CustomTextField({super.key, required this.controller, required this.hintText, required this.obscureText, this.showPassword, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText && !(showPassword ?? false),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: obscureText
              ? IconButton(
            icon: Icon(showPassword! ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle,
          )
              : null,
        ),
      ),
    );
  }
}
