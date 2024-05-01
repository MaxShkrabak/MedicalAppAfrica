// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:africa_med_app/components/Login_Page_Comps/my_textfield.dart';
import 'package:africa_med_app/components/Registration_Comps/name_text_fields.dart';
import 'package:africa_med_app/components/Registration_Comps/phone_num_field.dart';
import 'package:africa_med_app/components/Registration_Comps/pass_checker.dart';
import 'package:africa_med_app/components/Registration_Comps/create_account_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleRegistrationPage extends StatefulWidget {
  const GoogleRegistrationPage(
      {super.key, required this.updateIsUserRegistered});

  final Function(bool) updateIsUserRegistered;

  @override
  State<GoogleRegistrationPage> createState() => _GoogleRegistrationPageState();
}

class _GoogleRegistrationPageState extends State<GoogleRegistrationPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accessController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confPassController = TextEditingController();
  late TextEditingController fNameController;
  late TextEditingController lNameController;

  User? user;
  bool _isValidAccessCode = false;
  bool _isValidPhone = false;

  bool _isStrong = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Auto-fill the user's name if it is available
    List<String>? name = user?.displayName?.split(' ');
    fNameController = TextEditingController(text: name?.first ?? '');
    lNameController = TextEditingController(text: name?.last ?? '');
  }

  Future signUp() async {
    // Get access level
    try {
      String accessLevel = await getAccessLevel(accessController.text.trim());
      // Create user
      await createUser(accessLevel);
      // Update the user's registration status
      widget.updateIsUserRegistered(true);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  Future<String> getAccessLevel(String accessCode) async {
    DocumentSnapshot accessCodeDoc = await FirebaseFirestore.instance
        .collection('access_codes')
        .doc(accessCode)
        .get();
    if (accessCodeDoc.exists) {
      return accessCodeDoc.get('Level');
    } else {
      throw Exception(
          'The access code you entered is invalid! Please try again.');
    }
  }

  Future<void> createUser(String accessLevel) async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'first_name': fNameController.text.trim(),
      'last_name': lNameController.text.trim(),
      'phone_number': phoneController.text.trim(),
      'access_level': accessLevel,
      'email': FirebaseAuth.instance.currentUser!.email,
      'imageURL': '',
      //'password': passController.text.trim(), // Do not store the password in the database
    });
  }

  // When popping, unauth the user so you go to the login page not the dashboard
  Future<void> _onWillPop() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool isPopInvoked) async {
        await _onWillPop();
      },
      child: Container(
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
                  colors: [Colors.black54, Colors.black87],
                ),
              ),
              child: Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: GradientText(
                      'Google Registration',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                              child: Column(children: [
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
                    const SizedBox(height: 13),
                    PhoneNumField(
                      controller: phoneController,
                      onValidated: (isValid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isValidPhone = isValid;
                          });
                        });
                      },
                    ),

                    const SizedBox(height: 13),

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
                        onTap: _isStrong && _isValidPhone && _isValidAccessCode
                            ? () {
                                signUp();
                              }
                            : null,
                        color: _isStrong && _isValidPhone && _isValidAccessCode
                            ? const Color.fromARGB(218, 0, 0, 0).withOpacity(1)
                            : const Color.fromARGB(218, 0, 0, 0)
                                .withOpacity(0.3))
                  ]))))))),
    );
  }
}
