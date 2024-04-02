import 'package:africa_med_app/pages/all_dashboard_pages/dashboard.dart';
import 'package:africa_med_app/pages/all_login_pages/login_page.dart';
import 'package:africa_med_app/pages/all_login_pages/registration_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('accounts')
                .doc(snapshot.data?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data?.exists ?? false) {
                  return const DashBoard();
                } else {
                  if (snapshot.data?.exists ?? false) {
                    return const DashBoard();
                  } else {
                    if (!isRegistrationPagePushed) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        isRegistrationPagePushed = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        ).then((_) => isRegistrationPagePushed = false);
                      });
                    }
                    return const LoginPage();
                  }
                }
              }
            },
          );
        }
      },
    );
  }
}
