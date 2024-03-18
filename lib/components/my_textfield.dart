import 'package:flutter/material.dart';

class MyEmailField extends StatelessWidget {
  const MyEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'E-Mail',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(
                color: Color.fromARGB(255, 183, 185, 183), width: 2.0),
          ),
          fillColor: Color.fromRGBO(127, 162, 193, 100),
          filled: true,
        ),
      ),
    );
  }
}

class MyPassField extends StatelessWidget {
  const MyPassField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Password',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(
                color: Color.fromARGB(255, 183, 185, 183), width: 2.0),
          ),
          fillColor: Color.fromRGBO(127, 162, 193, 100),
          filled: true,
        ),
      ),
    );
  }
}
