import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_view_page.dart';
import 'patient.dart';
import 'add_patient_page.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final TextEditingController _searchController = TextEditingController();

  final List<Patient> _patients = [];
  List<Patient> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    FirebaseFirestore.instance
        .collection('patients')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        Patient patient = Patient(
          uid: doc.id,
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
        setState(() {
          _patients.add(patient);
          _searchResults.add(patient);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResults = _patients);
    } else {
      final searchResults = _patients
          .where((patient) => patient.lowerCaseSearchTokens.contains(query))
          .toList();
      setState(() => _searchResults = searchResults);
    }
  }

  void updatePatientsCallback(Patient patient) {
    FirebaseFirestore.instance
        .collection('patients')
        .add(patient.toMap()) //adds to firebase
        .then((DocumentReference docRef) {
      String uid = docRef.id;
      patient.uid = uid;

      setState(() {
        _patients.add(patient);
        _searchResults.add(patient);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientViewPage(
            uid: uid,
          ),
        ),
      );
    }).catchError((error) {
      //print('Error adding patient: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 90.0), //space between text and back button
              child: Text(
                'Patients',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(159, 144, 79,
            230), //old: Color.fromARGB(161, 88, 82, 173), //appbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 15), //spacing of icon horizontally
            child: Transform.scale(
              scale: 0.75, //size of add app icon
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPatientPage(
                        updatePatientsCallback: updatePatientsCallback,
                      ),
                    ),
                  );
                },
                elevation: 8,
                backgroundColor: const Color.fromARGB(255, 201, 187, 235),
                child: const Icon(Icons.add, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(246, 244, 236,
            255), //old: Color.fromRGBO(76, 90, 137, 1), //background
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black, //cursor color
                      decoration: InputDecoration(
                        labelText: 'Search Patients',
                        labelStyle:
                            const TextStyle(color: Colors.black), //text color
                        enabledBorder: const UnderlineInputBorder(
                          //underline color
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          //underline color when focused
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                        'No patients found',
                        style: TextStyle(color: Color.fromARGB(180, 0, 0, 0)),
                      ))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(211, 86, 65,
                                    112), //old: Color.fromARGB(255, 76, 57, 100),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  '${_searchResults[index].firstName} ${_searchResults[index].lastName}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  _searchResults[index].phone,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          "Primary Caregiver",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 149, 247, 152),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          _searchResults[index].caregiver,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    //delete patient
                                    IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Color.fromARGB(255, 189, 68, 68),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Confirm Delete'),
                                              content: const Text(
                                                  'Are you sure you want to delete this patient?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Delete patient from Firestore
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'patients')
                                                          .doc(_patients[index]
                                                              .uid)
                                                          .delete()
                                                          .then((_) {
                                                        setState(() {
                                                          _searchResults
                                                              .removeAt(index);
                                                          _patients
                                                              .removeAt(index);
                                                        });
                                                        Navigator.pop(context);
                                                      });
                                                    } on Error catch (_) {
                                                      // print(
                                                      //"Path is empty: $e");
                                                    }
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientViewPage(
                                        uid: _searchResults[index].uid,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
