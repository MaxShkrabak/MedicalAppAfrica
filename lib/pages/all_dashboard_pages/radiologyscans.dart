import 'package:flutter/material.dart';

class RadiologyScans extends StatefulWidget {
  const RadiologyScans({super.key});

  @override
  _RadiologyScansState createState() => _RadiologyScansState();
}

class _RadiologyScansState extends State<RadiologyScans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(156, 102, 133, 161),
        title: const Text('Radiology'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'X-rays - MRIs, Cat Scans, etc',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
