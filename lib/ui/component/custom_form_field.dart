// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  String label;

  String hintText;
  bool isPassword;
  TextInputType keyboardType;
  MyValidator validator;
  TextEditingController controller;
  int maxLine;

  int minLine;

  //This is a Constructor that take a parameter
  CustomFormField({
    required this.label,
    required this.hintText,
    required this.validator,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.minLine = 1,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        maxLines: maxLine,
        minLines: minLine,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
