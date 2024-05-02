// ignore_for_file: use_build_context_synchronously

import 'package:africa_med_app/components/Login_Page_Comps/my_textfield.dart';
import 'package:africa_med_app/components/Registration_Comps/email_text_field.dart';
import 'package:africa_med_app/components/Registration_Comps/name_text_fields.dart';
import 'package:africa_med_app/components/Registration_Comps/phone_num_field.dart';
import 'package:africa_med_app/components/Registration_Comps/create_account_button.dart';
import 'package:africa_med_app/components/Registration_Comps/on_create_error_popup.dart';
import 'package:africa_med_app/components/Registration_Comps/pass_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.updateIsUserRegistered});

  final Function(bool) updateIsUserRegistered;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  User? user;
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final accessController = TextEditingController();
  final confPassController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();

  bool _isStrong = false;
  bool _isValidPhone = false;
  bool _isValidAccessCode = false;
  bool _isValidEmail = false;

  Future signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (passConfirmed()) {
      // Declare the access level of the user so that its outside the scope of the try-catch block
      String accessLevel = '';

      // Get the access level of the user
      try {
        accessLevel = await getAccessLevel(accessController.text.trim());
      } on Exception {
        Navigator.pop(context);
      }

      // Create the user
      try {
        UserCredential userCredential = await createUser(
            emailController.text.trim(),
            passController.text.trim(),
            accessLevel);
      } on Exception catch (e) {
        Navigator.pop(context);
        onCreateErrorPopUp(context, e.toString());
      }
      // Update the user's registration status
      widget.updateIsUserRegistered(true);
      Navigator.pop(context); // Close the CircularProgressIndicator
      Navigator.pop(context); // Close the Registration Page
    } else {
      Navigator.pop(context);
      onCreateErrorPopUp(context, "The passwords don't match!");
      confPassController.clear();
    }
  }

  bool passConfirmed() {
    if (passController.text.trim() == confPassController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getAccessLevel(String accessCode) async {
    // Sign in anonymously to use the Firebase services
    UserCredential anonymousUserCredential =
        await FirebaseAuth.instance.signInAnonymously();

    DocumentSnapshot accessCodeDoc = await FirebaseFirestore.instance
        .collection('access_codes')
        .doc(accessCode)
        .get();
    if (accessCodeDoc.exists) {
      await FirebaseAuth.instance.currentUser?.delete();
      return accessCodeDoc.get('Level');
    } else {
      throw Exception(
          'The access code you entered is invalid! Please try again.');
    }
  }

  Future<UserCredential> createUser(
      String email, String password, String accessLevel) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );
    // Create a new user in the firestore database, collection: accounts, document_id: user.uid, if the user is not null
    if (userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(userCredential.user!.uid)
          .set({
        'first_name': fNameController.text.trim(),
        'last_name': lNameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'access_level': accessLevel,
        'email': emailController.text.trim(),
        'imageURL': '',
      });
      return userCredential;
    } else {
      throw Exception('An error occurred while creating the user!');
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
              colors: [Colors.black54, Colors.black87]),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors
                  .black, // Change this color to match your app's color scheme
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: GradientText(
              'Create an Account',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              colors: const [
                Colors.blue,
                Colors.black45,
              ],
            ),
            backgroundColor: Colors.white.withOpacity(0.9),
          ),
          backgroundColor: const Color.fromARGB(156, 102, 133, 161),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                        height: 60,
                        child: Icon(
                          Icons.person_outlined,
                          size: 60,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Flexible(
                            child: NameTextFields(
                                controller: fNameController,
                                hintText: "First Name")),
                        const SizedBox(
                          width: 60.0,
                        ),
                        Flexible(
                          child: NameTextFields(
                              controller: lNameController,
                              hintText: "Last Name"),
                        ),
                        const SizedBox(width: 30)
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    PhoneNumField(
                      controller: phoneController,
                      onValidated: (isValid) {
                        //
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isValidPhone = isValid;
                          });
                        });
                      },
                    ),
                    const SizedBox(height: 13),
                    EmailTextField(
                      controller: emailController,
                      onValidated: (isValid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isValidEmail = isValid;
                          });
                        });
                      },
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    // Add text field for the registrant's *Access Code* that verifies their membership of the organization and
                    // determines the level of access they have to the app's features.
                    MyTextField(
                      controller: accessController,
                      obscureText: false,
                      hintText: 'Access Code',
                      prefix: Icons.lock_outline,
                      onChanged: (value) {
                        setState(() {
                          _isValidAccessCode =
                              RegExp(r'^[0-9]{6}$').hasMatch(value);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    MyTextField(
                        controller: passController,
                        hintText: "Password",
                        obscureText: false,
                        prefix: Icons.lock_outline),
                    const SizedBox(height: 13),
                    MyTextField(
                        controller: confPassController,
                        hintText: "Confirm Password",
                        obscureText: false,
                        prefix: Icons.shield_outlined),
                    const SizedBox(
                      height: 13,
                    ),
                    AnimatedBuilder(
                      animation: passController,
                      builder: (context, child) {
                        final password = passController.text;

                        return PasswordStrengthChecker(
                          onStrengthChanged: (bool value) {
                            setState(() {
                              _isStrong = value;
                            });
                          },
                          password: password,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CreateButton(
                        onTap: _isStrong &&
                                _isValidPhone &&
                                _isValidEmail &&
                                _isValidAccessCode
                            ? () {
                                signUp();
                              }
                            : null,
                        color: _isStrong &&
                                _isValidPhone &&
                                _isValidEmail &&
                                _isValidAccessCode
                            ? const Color.fromARGB(218, 0, 0, 0).withOpacity(1)
                            : const Color.fromARGB(218, 0, 0, 0)
                                .withOpacity(0.3))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
