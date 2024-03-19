import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Color.fromARGB(156, 102, 133, 161),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
              height: 190.0,
              width: MediaQuery.of(context).size.width - 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                      image: AssetImage("assets/logo.png"))),
              child: const Center(
                child: Text('test'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
