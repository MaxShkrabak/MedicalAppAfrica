import 'package:flutter/material.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 145,
          child: Image.asset('assets/logo.png'),
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome Back!",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
