import 'package:flutter/material.dart';
import 'package:africa_med_app/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(156, 102, 133, 161),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 20),

              //logo
              Container(
                height: 234,
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              //email
              const MyEmailField(),

              const SizedBox(height: 12),
              //password
              const MyPassField(),

              //login button

              //forgot pass

              //create acc
            ]),
          ),
        ));
  }
}
