import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText; //hint text that appears when text field is empty
  final bool obscureText; //determines if text should be visible or not
  final bool showPassIcon; //determines if show icon for password is visible
  final IconData? prefix;

  //constructor
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.showPassIcon = false,
    this.prefix,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
          labelText: widget.hintText,
          labelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          prefixIcon: Icon(
            widget.prefix,
            color: Colors.grey,
          ),
          suffixIcon: widget.obscureText && widget.showPassIcon
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
