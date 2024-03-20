import 'package:africa_med_app/components/Login_Page_Comps/my_textfield.dart';
import 'package:africa_med_app/components/Registration_Comps/NameTextFields.dart';
import 'package:africa_med_app/components/Registration_Comps/PhoneNumField.dart';
import 'package:africa_med_app/components/Registration_Comps/create_account_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RegistrationPage extends StatefulWidget {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
              'Create an Account.',
              style: const TextStyle(fontSize: 37, fontWeight: FontWeight.w800),
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
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20),
                        Flexible(
                            child: NameTextFields(
                                controller: widget.fNameController,
                                hintText: "First Name")),
                        const SizedBox(
                          width: 60.0,
                          child: Icon(Icons.person_outlined, size: 50),
                        ),
                        Flexible(
                          child: NameTextFields(
                              controller: widget.lNameController,
                              hintText: "Last Name"),
                        ),
                        const SizedBox(width: 20)
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    PhoneNumField(controller: widget.phoneController),
                    const SizedBox(height: 40),
                    MyTextField(
                        controller: widget.emailController,
                        hintText: "E-Mail",
                        obscureText: false,
                        prefix: Icons.mail_outlined),
                    const SizedBox(
                      height: 40,
                    ),
                    MyTextField(
                        controller: widget.passController,
                        hintText: "Password",
                        obscureText: false,
                        prefix: Icons.lock_outline),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: widget.confPassController,
                        hintText: "Confirm Password",
                        obscureText: false,
                        prefix: Icons.shield_outlined),
                    const SizedBox(
                      height: 140,
                    ),
                    CreateButton(onTap: () {}),
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
