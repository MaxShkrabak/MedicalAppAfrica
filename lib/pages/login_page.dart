import 'package:africa_med_app/components/Login_Page_Comps/register_now.dart';
import '../components/Login_Page_Comps/forgot_password.dart';
import '../components/Login_Page_Comps/logo_comp.dart';
import '../components/Login_Page_Comps/my_divider.dart';
import '../components/Login_Page_Comps/signin_button.dart';
import '../components/Login_Page_Comps/my_textfield.dart';
import 'package:flutter/material.dart';

import '../components/Login_Page_Comps/square_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(156, 102, 133, 161),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(height: 20),

              //logo
              LogoComponent(),
              SizedBox(height: 15),

              //email
              MyEmailField(),
              SizedBox(height: 12),

              //password
              MyPassField(),

              //forgot pass
              SizedBox(height: 8),

              //forgot pass
              ForgotPassword(),
              SizedBox(height: 25),

              //login button
              SignInButton(),
              SizedBox(height: 30),

              //divider
              MyDivider(),

              //Google and Apple sign in

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SquareBoxButton(image: 'assets/google logo.png'),
                SizedBox(
                  height: 120,
                  width: 26,
                ),
                //apple
                SquareBoxButton(image: 'assets/Apple_logo_black.png'),
              ]),
              SizedBox(
                height: 12,
              ),
              //create acc
              RegisterButton(),
            ]),
          ),
        ));
  }
}
