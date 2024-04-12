import 'package:flutter/material.dart';

class LabTests extends StatefulWidget {
  const LabTests({super.key});

  @override
  _LabTestsState createState() => _LabTestsState();
}

class _LabTestsState extends State<LabTests> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(133, 23, 6, 87),
              Color.fromARGB(221, 52, 4, 85),
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
             backgroundColor: Color.fromARGB(156, 102, 134, 161),
             title: const Text('Laboratory'),
             leading: IconButton(
             icon: const Icon(Icons.arrow_back),
             onPressed: () {
               Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Color.fromARGB(156, 102, 133, 161),
          body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  const Divider(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    thickness: 2,
                  ),

                  const SizedBox(height: 60),
                  const Text(
                    'Blood, Urine, Stool tests',
                     style: TextStyle(
                       fontSize: 24,
                       fontWeight: FontWeight.bold,
                     ),
                  ),
                ],  
              ),
            ),
          ),
        ),
      ),
    );
  }
}
