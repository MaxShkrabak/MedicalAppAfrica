import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return const AlertDialog(
            content:
                Text('Password reset link has been sent! Check your email.'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('This email doesn\'t seem to exist in our database.'),
          );
        },
      );
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
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: GradientText(
              ' Forgot Password',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Enter the email address associated with your account and we'
                        'll send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Email",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: resetPassword,
                              icon: const Icon(Icons.send),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
