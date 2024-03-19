import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isPressed = false; // Variable to track button press state

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                isPressed = true; // Indicate that the button is pressed
              });
            },
            onTapUp: (_) {
              setState(() {
                isPressed = false; // Indicate that the button is released
              });
            },
            onTapCancel: () {
              setState(() {
                isPressed = false; // Indicate that the tap is canceled
              });
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200), // Animation duration
              opacity: isPressed ? 0.3 : 1.0, // Lower opacity when pressed
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color.fromARGB(211, 0, 4, 8),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
