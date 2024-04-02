import 'package:africa_med_app/components/Login_Page_Comps/register_now.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../components/Login_Page_Comps/forgot_password.dart';
import '../../components/Login_Page_Comps/logo_comp.dart';
import '../../components/Login_Page_Comps/my_divider.dart';
import '../../components/Login_Page_Comps/signin_button.dart';
import '../../components/Login_Page_Comps/my_textfield.dart';
import '../../components/Login_Page_Comps/square_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../components/Login_Page_Comps/wrong_credentials.dart';
import 'registration_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) {
        Navigator.pop(context);
      }
      // Successfully signed in
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        wrongCredentialsMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(133, 0, 225, 255),
                Color.fromARGB(221, 44, 25, 148)
              ]),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(156, 102, 133, 161),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    //logo image
                    const LogoComponent(),
                    const SizedBox(height: 15),

                    //email text
                    MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        showPassIcon: false,
                        prefix: Icons.person_outline),
                    const SizedBox(height: 12),

                    //password text
                    MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        showPassIcon: true,
                        prefix: Icons.lock_outline),

                    //forgot pass text
                    const SizedBox(height: 7),
                    ForgotPassword(),
                    const SizedBox(height: 25),

                    //login button
                    MyButton(onTap: signUserIn),
                    const SizedBox(height: 30),

                    //divider
                    const MyDivider(),

                    //Google and Facebook sign in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //google
                        SquareBoxButton(
                          image: 'assets/google logo.png',
                          onPressed: _handleGoogleSignIn,
                        ),
                        const SizedBox(
                          height: 120,
                          width: 26,
                        ),

                        //facebook
                        SquareBoxButton(
                          image: 'assets/facebook_logo.png',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    //create acc
                    const RegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle Google Sign In
  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        // Check if user exists in 'accounts' collection
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('accounts').doc(userCredential.user?.uid).get();

        if (!userDoc.exists) {
          // If user doesn't exist in 'accounts' collection, navigate to RegistrationPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        }
      } else {
        // User canceled Google Sign In
      }
    } catch (error) {
      print(error);
    }
  }
}
