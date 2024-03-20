import 'package:flutter/material.dart';

class NameTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const NameTextFields({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  _NameTextFieldsState createState() => _NameTextFieldsState();
}

class _NameTextFieldsState extends State<NameTextFields> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 130),
        child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 183, 185, 183),
                  width: 2.0,
                ),
              ),
              fillColor: const Color.fromRGBO(127, 162, 193, 100),
              filled: true,
              hintText: widget.hintText,
            )));
  }
}
