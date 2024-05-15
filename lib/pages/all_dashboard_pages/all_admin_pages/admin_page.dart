// Admin page, where you can generate and delete access codes in the database
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? _selectedAccessLevel;
  String? _selectedCode;

  List<String> accessCodes = [];

  // Generate Access Code
  // Pop up a dialog asking for the 6 digit numeric code and the access level (defined by strings like "Admin", "Doctor", "Nurse", and "Physician Assistant")
  void generateAccessCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.generateButton),
          content: Column(
            children: <Widget>[
              Text(AppLocalizations.of(context)!.enterAccessCode),
              TextField(
                onChanged: (value) {
                  _selectedCode = value;
                  // access code
                },
              ),
              DropdownButton<String>(
                value: _selectedAccessLevel,
                hint: Text(AppLocalizations.of(context)!.selectAccessLevel),
                items: <String>[
                  AppLocalizations.of(context)!.doctor,
                  AppLocalizations.of(context)!.nurse,
                  AppLocalizations.of(context)!.physicianAssistant,
                  AppLocalizations.of(context)!.admin
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
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
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () {
                // generate access code
                _uploadAccessCode(_selectedCode, _selectedAccessLevel);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.generateButton),
            ),
          ],
        );
      },
    );
  }

  // Upload Access Code
  void _uploadAccessCode(String? code, String? accessLevel) async {
    try {
      await FirebaseFirestore.instance
          .collection('access_codes')
          .doc(code)
          .set({
        'Level': accessLevel,
      });
      print('Access code uploaded successfully');
    } catch (e) {
      print('Failed to upload access code: $e');
    }
  }

  Future<void> fetchAccessCodes() async {
    accessCodes.clear();

    await FirebaseFirestore.instance
        .collection('access_codes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        querySnapshot.docs.forEach((doc) {
          accessCodes.add(doc.id);
        });
      });
    });
  }

  // Delete Access Code
  // Pop up a list of access codes and allow deletion of one
  void deleteAccessCode() async {
    await fetchAccessCodes();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteButton),
          content: Column(
            children: <Widget>[
              Text(AppLocalizations.of(context)!.deleteButton),
              DropdownButton<String>(
                value: _selectedCode,
                hint: Text(
                    AppLocalizations.of(context)!.selectAccessCodeToDelete),
                items:
                    accessCodes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCode = newValue;
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
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () {
                // delete access code
                _deleteAccessCode(_selectedCode);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccessCode(String? code) async {
    try {
      await FirebaseFirestore.instance
          .collection('access_codes')
          .doc(code)
          .delete();
      print('Access code deleted successfully');
    } catch (e) {
      print('Failed to delete access code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(159, 144, 79, 230), // appbar color
        iconTheme: const IconThemeData(color: Colors.white), // back arrow color
        title: Padding(
          padding: EdgeInsets.only(left: 75),
          //Applocalizations text for Admin page
          child: Text(
            AppLocalizations.of(context)!.adminPageTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Generate Access Code button
              Tiles(
                onTap: () {
                  generateAccessCode();
                },
                width: 250,
                height: 120,
                mainText: AppLocalizations.of(context)!.generateButton,
                subText: '',
              ),
              const SizedBox(height: 15),
              // Delete Access Code button
              Tiles(
                onTap: () {
                  deleteAccessCode();
                },
                width: 250,
                height: 60,
                mainText: AppLocalizations.of(context)!.deleteButton,
                subText: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
