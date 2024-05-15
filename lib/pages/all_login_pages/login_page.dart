// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:africa_med_app/components/Login_Page_Comps/register_now.dart';
import 'package:africa_med_app/pages/all_login_pages/facebook_registration_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:africa_med_app/main.dart';

import '../../components/Login_Page_Comps/forgot_password.dart';
import '../../components/Login_Page_Comps/logo_comp.dart';
import '../../components/Login_Page_Comps/my_divider.dart';
import '../../components/Login_Page_Comps/signin_button.dart';
import '../../components/Login_Page_Comps/my_textfield.dart';
import '../../components/Login_Page_Comps/square_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../components/Login_Page_Comps/wrong_credentials.dart';
import 'google_registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.updateIsUserRegistered});

  final Function(bool) updateIsUserRegistered;

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
      widget.updateIsUserRegistered(true);
    } on FirebaseAuthException {
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
                        hintText: AppLocalizations.of(context)!.email,
                        obscureText: false,
                        showPassIcon: false,
                        prefix: Icons.person_outline),
                    const SizedBox(height: 12),

                    //password text
                    MyTextField(
                        controller: passwordController,
                        hintText: AppLocalizations.of(context)!.password,
                        obscureText: true,
                        showPassIcon: true,
                        prefix: Icons.lock_outline),

                    //forgot pass text
                    const SizedBox(height: 7),
                    const ForgotPassword(),
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
                          onPressed: _handleFacebookSignIn,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    //create acc
                    RegisterButton(
                        updateIsUserRegistered: widget.updateIsUserRegistered),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(

                          child: Text('EN'),
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            MyApp.setLocale(context, Locale('en', ''));
                          },
                        ),
                        TextButton(
                          child: Text('AR'),
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            MyApp.setLocale(context, Locale('ar', ''));
                          },
                        ),
                      ],
                    ),
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

        //Finish the auth process by signing in with credential
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Navigate to the Google Registration Page *if* the user is not already in the accounts collection in the firestore with the uid being their name
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('accounts')
            .doc(uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            // User already exists in the accounts collection
            // Set the state flag to true so that the AuthPage can navigate to the Dashboard
            widget.updateIsUserRegistered(true);
          } else {
            // User does not exist in the accounts collection
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleRegistrationPage(
                    updateIsUserRegistered: widget.updateIsUserRegistered),
              ),
            );
          }
        });
      } else {
        // User canceled Google Sign In
      }
    } catch (error) {
      print(error);
    }
  }

  // Function to handle Facebook sign in
  void _handleFacebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      // Checks if login was successful
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken =
            result.accessToken!; // Gets access token

        //Creates auth credential
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        // Signs in with credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Checks firebase to see if user exists
        final userDoc = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(userCredential.user!.uid)
            .get();

        //if exists
        if (userDoc.exists) {
          widget.updateIsUserRegistered(true);
        } else {
          // If user doesn't exist in database, navigates to Facebook registration page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacebookRegistrationPage(
                updateIsUserRegistered: widget.updateIsUserRegistered,
              ),
            ),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        print('Facebook login cancelled by user');
      } else {
        print('Error during Facebook login: ${result.message}');
      }
    } catch (error) {
      print('Error during Facebook login: $error');
      if (error
          .toString()
          .contains('account-exists-with-different-credential')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An account already exists with the same email address but different sign-in credentials. Please sign in using a provider associated with this email address.',
            ),
          ),
        );
      }
    }
  }
}
