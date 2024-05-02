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

  List<Patient> _patients = [];
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
          lowerCaseSearchTokens: data['lowerCaseSearchTokens'] ?? '',
          firstName: data['firstName'] ?? '',
          middleName: data['middleName'] ?? '',
          lastName: data['lastName'] ?? '',
          dob: data['dob'] ?? '',
          bloodGroup: data['bloodGroup'] ?? '',
          rhFactor: data['rhFactor'] ?? '',
          maritalStatus: data['maritalStatus'] ?? '',
          preferredLanguage: data['preferredLanguage'] ?? '',
          homePhone: data['homePhone'] ?? '',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          emergencyFirstName: data['emergencyFirstName'] ?? '',
          emergencyLastName: data['emergencyLastName'] ?? '',
          relationship: data['relationship'] ?? '',
          emergencyPhone: data['emergencyPhone'] ?? '',
          knownMedicalIllnesses: data['knownMedicalIllnesses'] ?? '',
          previousMedicalIllnesses: data['previousMedicalIllnesses'] ?? '',
          allergies: data['allergies'] ?? '',
          currentMedications: data['currentMedications'] ?? '',
          pastMedications: data['pastMedications'] ?? '',
        );
        setState(() {
          _patients.add(patient);
          _searchResults.add(patient);
        });
      }
    });
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResults = _patients);
    } else {
      final List<Patient> searchResults = [];
      for (final patient in _patients) {
        if (patient.lowerCaseSearchTokens.contains(query)) {
          searchResults.add(patient);
        }
      }
      setState(() => _searchResults = searchResults);
    }

  }

  void updatePatientsCallback(Patient patient) {
    setState(() {
      _patients.add(patient);
      _searchResults.add(patient);
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
        backgroundColor: const Color.fromARGB(161, 88, 82, 173),
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
                backgroundColor: const Color.fromARGB(255, 200, 178, 250),
                child: const Icon(Icons.add, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(76, 90, 137, 1),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: const Color.fromARGB(
                          255, 255, 255, 255), //cursor color
                      decoration: InputDecoration(
                        labelText: 'Search Patients',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(
                                255, 255, 255, 255)), //text color
                        enabledBorder: const UnderlineInputBorder(
                          //underline color
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          //underline color when focused
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
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
                child: _patients.isEmpty
                    ? const Center(
                        child: Text(
                        'No patients found',
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 76, 57, 100),
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
                                                    FirebaseFirestore.instance
                                                        .collection('patients')
                                                        .doc(_patients[index]
                                                            .uid)
                                                        .delete()
                                                        .then((_) {
                                                      setState(() {
                                                        _patients
                                                            .removeAt(index);
                                                      });
                                                      Navigator.pop(context);
                                                    });
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
