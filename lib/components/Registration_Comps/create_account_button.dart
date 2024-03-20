import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final Function()? onTap;

  const CreateButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          decoration: BoxDecoration(
            color: Color.fromARGB(218, 11, 146, 40),
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_box_outlined,
                color: Color.fromARGB(255, 141, 141, 141),
                size: 22.0,
              ),
              SizedBox(width: 8),
              Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
