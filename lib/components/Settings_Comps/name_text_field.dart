import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

class SettingsNameTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPhoneNumberField;
  final bool isEmailField;
  final Function()? onTap;

  const SettingsNameTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPhoneNumberField = false,
    this.isEmailField = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: isEmailField
          ? Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(180, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        Text(controller.text,
                            style: const TextStyle(
                                color: Color.fromARGB(180, 0, 0, 0),
                                fontSize: 16)),
                        TextButton(
                          onPressed: onTap,
                          child: const Text(
                            "Change Email",
                            style: TextStyle(
                                color: Color.fromARGB(255, 65, 195, 255),
                                fontSize: 11.5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : TextField(
              controller: controller,
              onTap: () {
                // moves cursor all the way to right of text box when tapped
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              },
              style: const TextStyle(
                  color: Color.fromARGB(
                      180, 0, 0, 0)), // color of users data in text box
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
                  borderSide: BorderSide(
                      color: Color.fromARGB(180, 0, 0, 0)), // border color
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Color.fromARGB(180, 0, 0, 0)), // focused border color
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Color.fromARGB(180, 0, 0, 0)), // enabled border color
                ),
              ),
            ),
    );
  }
}
