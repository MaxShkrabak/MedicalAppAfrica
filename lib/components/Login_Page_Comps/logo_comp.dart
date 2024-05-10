import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 145,
          child: Image.asset('assets/logo.png'),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.welcome_back,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
