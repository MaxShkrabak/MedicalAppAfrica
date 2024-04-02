import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool isValid) onValidated;

  const EmailTextField({
    Key? key,
    required this.controller,
    required this.onValidated,
  }) : super(key: key);

  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: widget.controller,
        // Include validator that the email is in the correct format
        validator: (value) {
          bool isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!);
          widget.onValidated(isValid);
          if (!isValid) {
            return 'Please enter a valid email';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          fillColor: const Color.fromRGBO(127, 162, 193, 100),
          filled: true,
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          hintText: "Email",
          prefixIcon: Icon(
            Icons.email,
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
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 0, 0),
              width: 2.0,      
          ),
        ),
      ),
    ),
    );
  }
}