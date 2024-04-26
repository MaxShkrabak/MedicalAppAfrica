import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_view_page.dart';
import 'Patient.dart';
import 'add_patient_page.dart';


class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final TextEditingController _searchController = TextEditingController();

  final List<Patient> _patients = [];
  final List<String> _searchResults = [];


 

  //Initstate where you get the data from the firestore to populate the list
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('patients').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Patient patient = Patient(
          uid: doc.id,
          lowerCaseSearchTokens: data['lowerCaseSearchTokens'] ?? '', // Provide default value
          firstName: data['firstName'] ?? '', // Provide default value
          middleName: data['middleName'] ?? '', // Provide default value
          lastName: data['lastName'] ?? '', // Provide default value
          dob: data['dob'] ?? '', // Provide default value
          bloodGroup: data['bloodGroup'] ?? '', // Provide default value
          rhFactor: data['rhFactor'] ?? '', // Provide default value
          maritalStatus: data['maritalStatus'] ?? '', // Provide default value
          preferredLanguage: data['preferredLanguage'] ?? '', // Provide default value
          homePhone: data['homePhone'] ?? '', // Provide default value
          phone: data['phone'] ?? '', // Provide default value
          email: data['email'] ?? '', // Provide default value
          emergencyFirstName: data['emergencyFirstName'] ?? '', // Provide default value
          emergencyLastName: data['emergencyLastName'] ?? '', // Provide default value
          relationship: data['relationship'] ?? '', // Provide default value
          emergencyPhone: data['emergencyPhone'] ?? '', // Provide default value
          knownMedicalIllnesses: data['knownMedicalIllnesses'] ?? '', // Provide default value
          previousMedicalIllnesses: data['previousMedicalIllnesses'] ?? '', // Provide default value
          allergies: data['allergies'] ?? '', // Provide default value
          currentMedications: data['currentMedications'] ?? '', // Provide default value
          pastMedications: data['pastMedications'] ?? '', // Provide default value
        );
        setState(() {
          _patients.add(patient);
        });
      });
    });
  }

  void _onSearchTextChanged(String text) {
    _searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _patients.forEach((patient) {
      if (patient.lowerCaseSearchTokens.contains(text.toLowerCase())) {
        _searchResults.add(patient.uid);
      }
    });

    setState(() {});

  }

  void updatePatientsCallback(Patient patient) {
    setState(() {
      _patients.add(patient);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
        backgroundColor: Colors.white, // White background for visibility
        appBar: AppBar(
          title: const Text('Patients'),
          backgroundColor: Color.fromARGB(156, 102, 134, 161),
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPatientPage(updatePatientsCallback: updatePatientsCallback,),
                ),
              );
            },
          ),
          ]
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchTextChanged,
                  decoration: InputDecoration(
                    labelText: 'Search Patients',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _patients.isEmpty
                  ? Center(child: Text('No patients found'))
                  : ListView.builder(
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientViewPage(uid: _patients[index].uid,)
                                )
                              );
                            },
                            child: ListTile(
                              title: Text('${_patients[index].firstName} ${_patients[index].lastName}'),
                              subtitle: Text(_patients[index].phone),
                              trailing: Icon(Icons.assignment),
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

