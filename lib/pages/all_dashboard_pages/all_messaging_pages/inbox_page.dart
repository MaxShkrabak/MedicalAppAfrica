import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/Tiles.dart';
import 'package:flutter/cupertino.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: const Text('Inbox'),
          backgroundColor: Colors.white,
        ),
        body: const SafeArea(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
