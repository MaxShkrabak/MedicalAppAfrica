// Admin page, where you can generate and delete access codes in the database
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? _selectedAccessLevel;
  String? _selectedCode;


  // Generate Access Code
  // Pop up a dialog asking for the 6 digit numeric code and the access level (defined by strings like "Admin", "Doctor", "Nurse", and "Physician Assistant")
   void generateAccessCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generate Access Code'),
          content: Column(
            children: <Widget>[
              const Text('Enter the 6 digit numeric code:'),
              TextField(
                onChanged: (value) {
                  _selectedCode = value;
                  // access code
                },
              ),
              DropdownButton<String>(
                value: _selectedAccessLevel,
                hint: const Text('Select Access Level'),
                items: <String>['Doctor', 'Nurse', 'Physician Assistant', 'Admin'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAccessLevel = newValue;
                  });
                },
              ),
              
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // generate access code
                _uploadAccessCode(_selectedCode, _selectedAccessLevel);
                Navigator.of(context).pop();
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  // Upload Access Code
  void _uploadAccessCode(String? code, String? accessLevel) async {
    try {
      await FirebaseFirestore.instance.collection('access_codes').doc(code).set({
        'Level': accessLevel,
      });
      print('Access code uploaded successfully');
    } catch (e) {
      print('Failed to upload access code: $e');
    }
  }

  // Delete Access Code
  // Pop up a list of access codes and allow deletion of one
  void deleteAccessCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Access Code'),
          content: Column(
            children: <Widget>[
              const Text('Select the access code to delete:'),
              // list of access codes
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // delete access code
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 20),
                // Generate Access Code button
                Tiles(
                  onTap: () {generateAccessCode();},
                  width: 250,
                  height: 120,
                  mainText: 'Generate Access Code',
                  subText: '',
                ),
                const SizedBox(height: 15),
                // Delete Access Code button
                Tiles(
                  onTap: () {deleteAccessCode();},
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
