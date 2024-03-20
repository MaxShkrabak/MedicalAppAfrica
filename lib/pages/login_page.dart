import 'package:africa_med_app/components/Login_Page_Comps/register_now.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/Login_Page_Comps/forgot_password.dart';
import '../components/Login_Page_Comps/logo_comp.dart';
import '../components/Login_Page_Comps/my_divider.dart';
import '../components/Login_Page_Comps/signin_button.dart';
import '../components/Login_Page_Comps/my_textfield.dart';
import '../components/Login_Page_Comps/square_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Successfully signed in
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrongCredentialsMessage();
    }
  }

  void wrongCredentialsMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 200.0, horizontal: 80.0),
          backgroundColor: Color.fromARGB(255, 192, 191, 191),
          title: Column(
            children: [
              Text(
                'The email or password you entered is incorrect. Please try again.',
                style: TextStyle(color: Colors.black, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
              Divider(
                color: Colors.black,
                height: 12,
                thickness: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 14, 101, 182)),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(156, 102, 133, 161),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                //logo
                LogoComponent(),
                SizedBox(height: 15),
                //email
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    showPassIcon: false,
                    prefix: Icons.person_outline),
                SizedBox(height: 12),
                //password
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    showPassIcon: true,
                    prefix: Icons.lock_outline),
                //forgot pass
                SizedBox(height: 7),
                ForgotPassword(),
                SizedBox(height: 25),
                //login button
                MyButton(onTap: signUserIn),
                SizedBox(height: 30),
                //divider
                MyDivider(),
                //Google and Apple sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareBoxButton(
                      image: 'assets/google logo.png',
                      onPressed: _handleGoogleSignIn,
                    ),
                    SizedBox(
                      height: 120,
                      width: 26,
                    ),
                    //apple
                    SquareBoxButton(
                      image: 'assets/Apple_logo_black.png',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                //create acc
                RegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle Google Sign In
  void _handleGoogleSignIn() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);
      // Handle signed in user
    } catch (error) {
      print(error);
    }
  }
}
