// Admin page, where you can generate and delete access codes in the database
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // back arrow color
        title: const Padding(
          padding: EdgeInsets.only(left: 75),
          child: Text('Admin Page', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: const Color.fromARGB(
            159, 144, 79, 230), //old: const Color.fromARGB(161, 88, 82, 173),
      ),
      body: Scaffold(
        backgroundColor: const Color.fromARGB(
            246, 244, 236, 255), //old: const Color.fromRGBO(76, 90, 137, 1),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('bing bong ding dong'),
                ),
                const SizedBox(height: 7),
                // Generate Access Code button
                Tiles(
                  onTap: () {},
                  width: 250,
                  height: 120,
                  mainText: 'Generate Access Code',
                  subText: '',
                ),
                const SizedBox(height: 15),
                // Delete Access Code button
                Tiles(
                  onTap: () {},
                  width: 250,
                  height: 60,
                  mainText: 'Delete Access Code',
                  subText: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
