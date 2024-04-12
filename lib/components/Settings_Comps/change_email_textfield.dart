import 'package:flutter/material.dart';

class ChangeEmailTF extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool isValid) onValidated;
  final String hintText;

  const ChangeEmailTF(
      {Key? key,
      required this.controller,
      required this.onValidated,
      required this.hintText})
      : super(key: key);

  @override
  _ChangeEmailTFState createState() => _ChangeEmailTFState();
}

class _ChangeEmailTFState extends State<ChangeEmailTF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TextFormField(
        controller: widget.controller,
        // Include validator that the email is in the correct format
        validator: (value) {
          bool isValid =
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!);
          widget.onValidated(isValid);
          if (!isValid) {
            return 'Please enter a valid email';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.black54,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // focused border color
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // enabled border color
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 0, 0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
