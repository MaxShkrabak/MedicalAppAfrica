import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

class SettingsNameTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPhoneNumberField;

  const SettingsNameTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPhoneNumberField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        onTap: () {
          // moves cursor all the way to right of text box when tapped
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        },
        style: const TextStyle(
            color: Colors.white), // color of users data in text box
        // Apply phone number formatting if it's a phone number field
        inputFormatters: isPhoneNumberField
            ? [
                MaskedInputFormatter('(###) ###-####',
                    allowedCharMatcher: RegExp(r'[0-9]')),
              ]
            : [],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7)), // hint text color
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // border color
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // focused border color
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // enabled border color
          ),
        ),
      ),
    );
  }
}
