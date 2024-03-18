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
              color: Color.fromRGBO(0, 0, 0, 0.45), // Corrected color opacity
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Color.fromARGB(255, 160, 159, 159),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color.fromRGBO(0, 0, 0, 0.45), // Corrected color opacity
            ),
          ),
        ],
      ),
    );
  }
}
