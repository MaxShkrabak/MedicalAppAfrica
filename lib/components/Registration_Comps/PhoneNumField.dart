import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneNumField extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool isValid) onValidated;

  const PhoneNumField({
    Key? key,
    required this.controller,
    required this.onValidated,
  }) : super(key: key);

  @override
  _PhoneNumFieldState createState() => _PhoneNumFieldState();
}

class _PhoneNumFieldState extends State<PhoneNumField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
          controller: widget.controller,
          // Include validator that the phone number contains 10 digits 
          validator: (value) {
            bool isValid = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$').hasMatch(value!);
            widget.onValidated(isValid);
            if (!isValid) {
              return 'Phone number must be in the format (XXX) XXX-XXXX';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            MaskedInputFormatter('(###) ###-####',
                allowedCharMatcher: RegExp(r'[0-9]')),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            fillColor: const Color.fromRGBO(127, 162, 193, 100),
            filled: true,
            labelText: "Your Phone Number",
            labelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            hintText: "Phone # (XXX) XXX-XXXX",
            prefixIcon: Icon(
              Icons.phone_iphone,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(color: Colors.red), // change this color as needed
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
              borderSide: BorderSide(color: Colors.red), // change this color as needed
            ),
          )),
    );
  }
}
