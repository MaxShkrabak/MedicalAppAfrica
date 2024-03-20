import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, top: 20),
        hintText: widget.hintText,
        labelText: widget.hintText,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        fillColor: Color.fromRGBO(127, 162, 193, 90),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
