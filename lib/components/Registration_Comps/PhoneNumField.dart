import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneNumField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneNumField({
    Key? key,
    required this.controller,
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
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            MaskedInputFormatter('(###) ###-####',
                allowedCharMatcher: RegExp(r'[0-9]')),
          ],
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
          )),
    );
  }
}
