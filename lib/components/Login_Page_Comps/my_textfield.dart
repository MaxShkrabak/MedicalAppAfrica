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
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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

class MyPassField extends StatefulWidget {
  const MyPassField({Key? key}) : super(key: key);

  @override
  _MyPassFieldState createState() => _MyPassFieldState();
}

class _MyPassFieldState extends State<MyPassField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            borderSide: BorderSide(
                color: Color.fromARGB(255, 183, 185, 183), width: 2.0),
          ),
          fillColor: const Color.fromRGBO(127, 162, 193, 100),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromARGB(255, 212, 211, 211),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
