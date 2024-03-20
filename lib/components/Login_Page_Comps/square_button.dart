import 'package:flutter/material.dart';

class SquareBoxButton extends StatelessWidget {
  final String image;
  final VoidCallback? onPressed; // Add onPressed callback

  const SquareBoxButton({Key? key, required this.image, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        width: 70,
        height: 70,
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1.0,
          fillColor: const Color.fromARGB(255, 235, 232, 232),
          onPressed: onPressed, // Use the onPressed callback here
          child: SizedBox(
            height: 50,
            child: Image.asset(image),
          ),
        ),
      ),
    );
  }
}
