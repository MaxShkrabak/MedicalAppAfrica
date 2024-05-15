import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 145,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/client_logo.png'),
              fit: BoxFit.scaleDown,
            ),
          ),
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
