import 'package:flutter/material.dart';
import 'package:africa_med_app/pages/all_login_pages/forgot_pass_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false;
              });
              _navigateToForgotPasswordPage(context);
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isPressed ? 0.3 : 1.0,
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: TextStyle(
                  color: Color.fromARGB(211, 0, 4, 8),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToForgotPasswordPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }
}
