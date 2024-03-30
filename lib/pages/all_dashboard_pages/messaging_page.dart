import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Messaging',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
