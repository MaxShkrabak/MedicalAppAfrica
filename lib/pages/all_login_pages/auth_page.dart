import 'package:africa_med_app/pages/all_dashboard_pages/dashboard.dart';
import 'package:africa_med_app/pages/all_login_pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  bool isRegistrationPagePushed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginPage();
        } else {
          return const DashBoard();
        } 
      },
    );
  }
}
