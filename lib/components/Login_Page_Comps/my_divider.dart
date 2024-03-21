import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      // Return the Padding widget
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Color.fromRGBO(0, 0, 0, 1),
              thickness: 2, // Corrected color opacity
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Color.fromARGB(255, 50, 197, 255),
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color.fromRGBO(0, 0, 0, 1),
              thickness: 2, // Corrected color opacity
            ),
          ),
        ],
      ),
    );
  }
}
