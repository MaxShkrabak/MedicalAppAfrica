import 'package:africa_med_app/components/Registration_Comps/on_create_error_popup.dart';
import 'package:africa_med_app/components/Settings_Comps/change_email_textfield.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class newEmailPage extends StatefulWidget {
  const newEmailPage({super.key});

  @override
  State<newEmailPage> createState() => _newEmailPageState();
}

// ignore: camel_case_types
class _newEmailPageState extends State<newEmailPage> {
  final emailController = TextEditingController();
  final confEmailController = TextEditingController();
  bool _isValidEmail = false;

  Future changeEmail() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (emailConfirmed()) {
      // Declare the access level of the user so that its outside the scope of the try-catch block
    } else {
      Navigator.pop(context);
      onCreateErrorPopUp(context, "The Emails don't match!");
      confEmailController.clear();
    }
  }

  bool emailConfirmed() {
    if (emailController.text.trim() == confEmailController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Email',
          style: TextStyle(color: Colors.white), //color of
        ),
        backgroundColor:
            const Color.fromARGB(160, 165, 96, 255), //app bar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color:
              const Color.fromARGB(255, 255, 255, 255), // color of back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 100, //spacing between back arrow and text
      ),
      body: Scaffold(
        backgroundColor:
            const Color.fromARGB(246, 244, 236, 255), //background color
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 7),
                // Account Settings button
                ChangeEmailTF(
                  hintText: "New Email",
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
                  height: 15,
                ),
                TextField(
                  controller: confEmailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black54,
                    ),
                    hintText: "Confirm New Email",
                    hintStyle: TextStyle(
                        color:
                            Colors.black.withOpacity(0.7)), // hint text color
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(180, 0, 0, 0)), // border color
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              180, 0, 0, 0)), // focused border color
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(
                              180, 0, 0, 0)), // enabled border color
                    ),
                  ),
                ),

                const SizedBox(height: 150),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: _isValidEmail
                            ? MaterialStateColor.resolveWith(
                                (states) => Colors.blue)
                            : MaterialStateColor.resolveWith(
                                (states) => Colors.blue.withOpacity(0.4))),
                    onPressed: _isValidEmail
                        ? () {
                            changeEmail();
                          }
                        : () {},
                    child: const Text(
                      "Change Email",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
