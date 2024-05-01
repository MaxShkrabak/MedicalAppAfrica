// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient.dart';

class PatientViewPage extends StatefulWidget {
  const PatientViewPage({super.key, required this.uid});

  final String uid;

  @override
  State<PatientViewPage> createState() => _PatientViewPageState();
}

class _PatientViewPageState extends State<PatientViewPage> {
  late Future<Patient> _patientFuture;
  late Patient _patient;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _patientFuture = fetchPatient(widget.uid);
  }

  Future<Patient> fetchPatient(String uid) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('patients').doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return Patient(
        uid: documentSnapshot.id,
        lowerCaseSearchTokens: data['lowerCaseSearchTokens'] ?? 'Not Given',
        firstName: data['firstName'] ?? 'Not Given',
        middleName: data['middleName'] ?? 'Not Given',
        lastName: data['lastName'] ?? 'Not Given',
        dob: data['dob'] ?? 'Not Given',
        bloodGroup: data['bloodGroup'] ?? 'Not Given',
        rhFactor: data['rhFactor'] ?? 'Not Given',
        maritalStatus: data['maritalStatus'] ?? 'Not Given',
        preferredLanguage: data['preferredLanguage'] ?? 'Not Provided',
        homePhone: data['homePhone'] ?? 'None',
        phone: data['phone'] ?? 'None',
        email: data['email'] ?? 'None',
        emergencyFirstName: data['emergencyFirstName'] ?? 'None',
        emergencyLastName: data['emergencyLastName'] ?? 'None',
        relationship: data['relationship'] ?? 'None',
        emergencyPhone: data['emergencyPhone'] ?? 'None',
        knownMedicalIllnesses: data['knownMedicalIllnesses'] ?? 'None',
        previousMedicalIllnesses: data['previousMedicalIllnesses'] ?? 'None',
        allergies: data['allergies'] ?? 'None',
        currentMedications: data['currentMedications'] ?? 'None',
        pastMedications: data['pastMedications'] ?? 'None',
        caregiver: data['caregiver'] ?? 'None',
      );
    } else {
      throw Exception('Patient with uid: $uid not found');
    }
  }

  Future<void> _saveChanges() async {
    print('Saving changes...');
    print('Updated patient data: ${_patient.toMap()}');

    await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.uid)
        .update(_patient.toMap());

    print('Changes saved successfully.');

    setState(() {
      _editMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _patientFuture,
      builder: (BuildContext context, AsyncSnapshot<Patient> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            _patient = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 85.0, // Space between back arrow and title
                title: const Text(
                  'Patient View',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromARGB(161, 88, 82, 173),
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: Icon(_editMode ? Icons.save : Icons.edit),
                    onPressed: () {
                      setState(() {
                        if (_editMode) {
                          _saveChanges();
                        }
                        _editMode = !_editMode;
                      });
                    },
                  ),
                ],
              ),
              body: Container(
                color: const Color.fromRGBO(76, 90, 137, 1),
                child: ListView(
                  children: <Widget>[
                    _buildEditableTile(
                      title: 'First Name',
                      value: _patient.firstName,
                      onChanged: (value) {
                        setState(() {
                          _patient.firstName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Middle Name',
                      value: _patient.middleName,
                      onChanged: (value) {
                        setState(() {
                          _patient.middleName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Last Name',
                      value: _patient.lastName,
                      onChanged: (value) {
                        setState(() {
                          _patient.lastName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Date of Birth',
                      value: _patient.dob,
                      onChanged: (value) {
                        setState(() {
                          _patient.dob = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Blood Group',
                      value: _patient.bloodGroup,
                      onChanged: (value) {
                        setState(() {
                          _patient.bloodGroup = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Rh Factor',
                      value: _patient.rhFactor,
                      onChanged: (value) {
                        setState(() {
                          _patient.rhFactor = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Marital Status',
                      value: _patient.maritalStatus,
                      onChanged: (value) {
                        setState(() {
                          _patient.maritalStatus = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Preferred Language',
                      value: _patient.preferredLanguage,
                      onChanged: (value) {
                        setState(() {
                          _patient.preferredLanguage = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Home Phone',
                      value: _patient.homePhone,
                      onChanged: (value) {
                        setState(() {
                          _patient.homePhone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Phone',
                      value: _patient.phone,
                      onChanged: (value) {
                        setState(() {
                          _patient.phone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Email',
                      value: _patient.email,
                      onChanged: (value) {
                        setState(() {
                          _patient.email = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Emergency First Name',
                      value: _patient.emergencyFirstName,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyFirstName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Emergency Last Name',
                      value: _patient.emergencyLastName,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyLastName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Relationship',
                      value: _patient.relationship,
                      onChanged: (value) {
                        setState(() {
                          _patient.relationship = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Emergency Phone',
                      value: _patient.emergencyPhone,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyPhone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Known Medical Illnesses',
                      value: _patient.knownMedicalIllnesses,
                      onChanged: (value) {
                        setState(() {
                          _patient.knownMedicalIllnesses = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Previous Medical Illnesses',
                      value: _patient.previousMedicalIllnesses,
                      onChanged: (value) {
                        setState(() {
                          _patient.previousMedicalIllnesses = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Allergies',
                      value: _patient.allergies,
                      onChanged: (value) {
                        setState(() {
                          _patient.allergies = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Current Medications',
                      value: _patient.currentMedications,
                      onChanged: (value) {
                        setState(() {
                          _patient.currentMedications = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: 'Past Medications',
                      value: _patient.pastMedications,
                      onChanged: (value) {
                        setState(() {
                          _patient.pastMedications = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('No data');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildEditableTile({
    required String title,
    required String value,
    required Function(String) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: _editMode
          ? TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white),
            )
          : Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}