import 'package:flutter/material.dart';

class OrderingSystem extends StatefulWidget {
  const OrderingSystem({super.key});

  @override
  _OrderingSystemState createState() => _OrderingSystemState();
}

class _OrderingSystemState extends State<OrderingSystem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Orders stuff',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
