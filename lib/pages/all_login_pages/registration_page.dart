import 'package:africa_med_app/components/Login_Page_Comps/my_textfield.dart';
import 'package:africa_med_app/components/Registration_Comps/EmailTextField.dart';
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
  User? user;
  late TextEditingController emailController;
  late TextEditingController fNameController;
  late TextEditingController lNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    emailController = TextEditingController(text: user?.email ?? '');
    _isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text);
    List<String>? name = user?.displayName?.split(' ');
    fNameController = TextEditingController(text: name?.first ?? '');
    lNameController = TextEditingController(text: name?.last ?? '');
  }

  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final accessController = TextEditingController();
  final confPassController = TextEditingController();

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
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'invalid-email' || e.code == 'email-already-in-use') {
          onCreateErrorPopUp(context,
              'The email you entered is invalid or already in use! Please try again.');
        }
      } catch (e) {
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
                    PhoneNumField(
                      controller: phoneController,
                      onValidated: (isValid) {
                        //
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
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
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
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
