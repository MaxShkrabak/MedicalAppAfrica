import 'package:africa_med_app/pages/all_dashboard_pages/dashboard.dart';
import 'package:africa_med_app/pages/all_login_pages/login_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isUserRegistered = false;

  void updateIsUserRegistered(bool value) {
    setState(() {
      isUserRegistered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserRegistered) {
      return LoginPage(updateIsUserRegistered: updateIsUserRegistered);
    } else {
      return DashBoard(updateIsUserRegistered: updateIsUserRegistered);
    }
  }
}
