import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RawMaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          elevation: 1.0,
          fillColor: const Color.fromRGBO(8, 13, 17, 100),
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: Color.fromARGB(255, 141, 141, 141),
                size: 22.0,
              ),
              SizedBox(width: 8),
              Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
