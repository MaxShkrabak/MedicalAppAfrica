// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Patient.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_scheduling_pages/schedule_page.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  void selectCamera() {
    _uploadImage(true); // Camera option
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.blue[100],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _uploadImage(false); // Gallery option
                    },
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text(AppLocalizations.of(context)!.gallery)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: selectCamera, // Select from camera option
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text(AppLocalizations.of(context)!.camera)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source =
        isCamera ? ImageSource.camera : ImageSource.gallery;

    if (source == null) {
      return;
    }

    final XFile? image = await picker.pickImage(source: source);
    if (image == null) {
      return;
    }

    final File file = File(image.path);
    final String fileName = basename(file.path);
    final Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    final String url = await ref.getDownloadURL();

    //Also set the patients field to the new image URL in the firestore
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.uid)
        .update({'imageURL': url});

    setState(() {
      _patient.imageURL = url;
    });
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
        imageURL: data['imageURL'] ?? '',
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
                title: Text(
                  AppLocalizations.of(context)!.patient_view,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromARGB(159, 144, 79,
                    230), //old: const Color.fromARGB(161, 88, 82, 173),
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
                color: const Color.fromARGB(246, 244, 236, 255),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: _patient.imageURL != ''
                              ? NetworkImage(_patient.imageURL!)
                              : const AssetImage('assets/Anonymous_profile.jpg')
                                  as ImageProvider<Object>,
                        ),
                      ),
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.first_name,
                      value: _patient.firstName,
                      onChanged: (value) {
                        setState(() {
                          _patient.firstName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.middle_name,
                      value: _patient.middleName,
                      onChanged: (value) {
                        setState(() {
                          _patient.middleName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.last_name,
                      value: _patient.lastName,
                      onChanged: (value) {
                        setState(() {
                          _patient.lastName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.date_of_birth,
                      value: _patient.dob,
                      onChanged: (value) {
                        setState(() {
                          _patient.dob = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.blood_group,
                      value: _patient.bloodGroup,
                      onChanged: (value) {
                        setState(() {
                          _patient.bloodGroup = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.rh_fact,
                      value: _patient.rhFactor,
                      onChanged: (value) {
                        setState(() {
                          _patient.rhFactor = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.marrital,
                      value: _patient.maritalStatus,
                      onChanged: (value) {
                        setState(() {
                          _patient.maritalStatus = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.pref_language,
                      value: _patient.preferredLanguage,
                      onChanged: (value) {
                        setState(() {
                          _patient.preferredLanguage = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.home_num,
                      value: _patient.homePhone,
                      onChanged: (value) {
                        setState(() {
                          _patient.homePhone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.phone_number,
                      value: _patient.phone,
                      onChanged: (value) {
                        setState(() {
                          _patient.phone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.email_address,
                      value: _patient.email,
                      onChanged: (value) {
                        setState(() {
                          _patient.email = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.emer_first,
                      value: _patient.emergencyFirstName,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyFirstName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.emer_last,
                      value: _patient.emergencyLastName,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyLastName = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.relation,
                      value: _patient.relationship,
                      onChanged: (value) {
                        setState(() {
                          _patient.relationship = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.emer_phone,
                      value: _patient.emergencyPhone,
                      onChanged: (value) {
                        setState(() {
                          _patient.emergencyPhone = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.known_ill,
                      value: _patient.knownMedicalIllnesses,
                      onChanged: (value) {
                        setState(() {
                          _patient.knownMedicalIllnesses = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.prev_ill,
                      value: _patient.previousMedicalIllnesses,
                      onChanged: (value) {
                        setState(() {
                          _patient.previousMedicalIllnesses = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.allergies,
                      value: _patient.allergies,
                      onChanged: (value) {
                        setState(() {
                          _patient.allergies = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.curr_medi,
                      value: _patient.currentMedications,
                      onChanged: (value) {
                        setState(() {
                          _patient.currentMedications = value;
                        });
                      },
                    ),
                    _buildEditableTile(
                      title: AppLocalizations.of(context)!.past_medi,
                      value: _patient.pastMedications,
                      onChanged: (value) {
                        setState(() {
                          _patient.pastMedications = value;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showImagePickerOption(context);
                        },
                        child: Text(AppLocalizations.of(context)!.upload_image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Push the schdule_page to the navigator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Schedule(patient: _patient),
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.schedule_app),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Text(AppLocalizations.of(context)!.no_data);
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
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: _editMode
          ? TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black),
            )
          : Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
    );
  }
}
