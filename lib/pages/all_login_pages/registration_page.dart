import 'package:africa_med_app/components/Login_Page_Comps/my_textfield.dart';
import 'package:africa_med_app/components/Registration_Comps/NameTextFields.dart';
import 'package:africa_med_app/components/Registration_Comps/PhoneNumField.dart';
import 'package:africa_med_app/components/Registration_Comps/create_account_button.dart';
import 'package:africa_med_app/components/Registration_Comps/onCreate_error_popup.dart';
import 'package:africa_med_app/components/Registration_Comps/passChecker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final accessController = TextEditingController();
  final confPassController = TextEditingController();
  bool _isStrong = false;

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
      // First check if the user's provided access code exists as a doc in the 'access_codes' collection
      // Also set the user's access level based on the access code's "Level" field

      // Sign in anonymously to use the Firebase services

      try {
        UserCredential anonymousUserCredential =
            await FirebaseAuth.instance.signInAnonymously();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'operation-not-allowed') {
          onCreateErrorPopUp(
              context, "Anonymous sign in is not enabled! Please try again.");
          Navigator.pop(context);
        } else {
          onCreateErrorPopUp(context,
              "An error occurred while trying to sign in anonymously! Please try again.");
          Navigator.pop(context);
        }
      } catch (e) {
        onCreateErrorPopUp(context,
            "An error occurred while trying to sign in anonymously! Please try again.");
        Navigator.pop(context);
      }

      try {
        String enteredAccessCode = accessController.text.trim();
        DocumentSnapshot accessCodeDoc = await FirebaseFirestore.instance
            .collection('access_codes')
            .doc(enteredAccessCode)
            .get();
        if (!accessCodeDoc.exists) {
          print('The access code you entered is invalid! Please try again.');
          throw Exception(
              'The access code you entered is invalid! Please try again.');
        }
        String accessLevel = accessCodeDoc.get('Level');
        await FirebaseAuth.instance.currentUser
            ?.delete(); // Delete the anonymous user
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
            //'password': passController.text.trim(), // Do not store the password in the database
          });
        }

        Navigator.pop(context); // Close the CircularProgressIndicator
        Navigator.pop(context); // Close the Registration Page
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'invalid-email' || e.code == 'email-already-in-use') {
          onCreateErrorPopUp(context,
              'The email you entered is invalid or already in use! Please try again.');
        }
      } catch (e) {
        Navigator.pop(context);
        print('Error: $e');
        onCreateErrorPopUp(context, e.toString());
      }
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
          backgroundColor: Color.fromARGB(156, 102, 133, 161),
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
                    PhoneNumField(controller: phoneController),
                    const SizedBox(height: 13),
                    MyTextField(
                        controller: emailController,
                        hintText: "E-Mail",
                        obscureText: false,
                        prefix: Icons.mail_outlined),
                    const SizedBox(
                      height: 13,
                    ),
                    // Add text field for the registrant's *Access Code* that verifies their membership of the organization and
                    // determines the level of access they have to the app's features.
                    MyTextField(
                        controller: accessController,
                        hintText: "Access Code",
                        obscureText: false,
                        prefix: Icons.lock_outline),
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
                        onTap: _isStrong
                            ? () {
                                signUp();
                              }
                            : null,
                        color: _isStrong
                            ? Color.fromARGB(218, 0, 0, 0).withOpacity(1)
                            : Color.fromARGB(218, 0, 0, 0).withOpacity(0.3))
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
