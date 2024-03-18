import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'New to the app?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Register Now',
            style: TextStyle(
              color: Color.fromARGB(255, 98, 215, 219),
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
