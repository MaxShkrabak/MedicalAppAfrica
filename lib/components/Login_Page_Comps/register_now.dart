import 'package:africa_med_app/pages/all_login_pages/registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatefulWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  bool isPressed = false;

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
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: ((context) => RegistrationPage()),
                ));
          },
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
            duration:
                Duration(milliseconds: 200), // Adjust the duration as needed
            opacity: isPressed ? 0.5 : 1.0, // Lower opacity when pressed
            child: const Text(
              '  Register Now',
              style: TextStyle(
                color: Color.fromARGB(255, 98, 215, 219),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
