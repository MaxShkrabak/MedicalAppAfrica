import 'package:flutter/material.dart';

class SquareBoxButton extends StatelessWidget {
  final String image;
  const SquareBoxButton({super.key, required this.image});

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
          fillColor: Color.fromARGB(255, 235, 232, 232),
          onPressed: () {},
          child: Container(
            child: Image.asset(image),
            height: 50,
          ),
        ),
      ),
    );
  }
}
