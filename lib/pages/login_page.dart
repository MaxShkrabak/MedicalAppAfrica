import 'package:flutter/material.dart';
import 'package:africa_med_app/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 160, 159, 159),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(height: 20),

              //logo
              Container(
                height: 150,
                child: Image.asset('assets/logo.png'),
              ),

              SizedBox(height: 60),

              //email
              MyTextField(),

              SizedBox(height: 30),
              //password
              MyTextField(),

              //login button

              //forgot pass

              //create acc
            ]),
          ),
        ));
  }
}
