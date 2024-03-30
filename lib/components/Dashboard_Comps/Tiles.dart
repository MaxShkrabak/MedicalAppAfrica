import 'package:flutter/material.dart';

class Tiles extends StatefulWidget {
  final Function()? onTap;
  final String mainText;
  final double height, width;
  const Tiles({
    Key? key,
    required this.onTap,
    required this.mainText,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isPressed = true; // Indicate that the button is pressed
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false; // Indicate that the button is released
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false; // Indicate that the tap is canceled
        });
      },
      child: AnimatedOpacity(
        duration:
            const Duration(milliseconds: 150), // Adjust the duration as needed
        opacity: isPressed ? 0.8 : 1.0, // Lower opacity when pressed
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 6, 74, 83),
                Color.fromARGB(255, 99, 25, 148)
              ],
            ),
          ),
          child: Center(
            child: Text(
              widget.mainText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
