import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Patient.dart';

class PatientViewPage extends StatelessWidget{
  PatientViewPage({Key? key, required this.uid}) : super(key: key);


  final String uid;


  Future<Patient> fetchPatient(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('patients').doc(uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return Patient(
        uid: documentSnapshot.id,
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
    } else {
      throw Exception('Patient with uid: $uid not found');
    }
  }


  // Load the patient with the given uid from the firestore.collection('patients') in the initstate
  @override
  void initState() {
    fetchPatient(uid);
  }
  

  //Patient view page, display all the information about the patient with the given uid in the firestore.collection('patients')
  @override
  Widget build(BuildContext context){
    return FutureBuilder( 
      future: fetchPatient(uid),
      builder: (BuildContext context, AsyncSnapshot<Patient> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            Patient patient = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text('Patient View'),
              ),
              body: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('First Name'),
                    subtitle: Text(patient.firstName),
                  ),
                  ListTile(
                    title: Text('Middle Name'),
                    subtitle: Text(patient.middleName),
                  ),
                  ListTile(
                    title: Text('Last Name'),
                    subtitle: Text(patient.lastName),
                  ),
                  ListTile(
                    title: Text('Date of Birth'),
                    subtitle: Text(patient.dob),
                  ),
                  ListTile(
                    title: Text('Blood Group'),
                    subtitle: Text(patient.bloodGroup),
                  ),
                  ListTile(
                    title: Text('Rh Factor'),
                    subtitle: Text(patient.rhFactor),
                  ),
                  ListTile(
                    title: Text('Marital Status'),
                    subtitle: Text(patient.maritalStatus),
                  ),
                  ListTile(
                    title: Text('Preferred Language'),
                    subtitle: Text(patient.preferredLanguage),
                  ),
                  ListTile(
                    title: Text('Home Phone'),
                    subtitle: Text(patient.homePhone),
                  ),
                  ListTile(
                    title: Text('Phone'),
                    subtitle: Text(patient.phone),
                  ),
                  ListTile(
                    title: Text('Email'),
                    subtitle: Text(patient.email),
                  ),
                  ListTile(
                    title: Text('Emergency First Name'),
                    subtitle: Text(patient.emergencyFirstName),
                  ),
                  ListTile(
                    title: Text('Emergency Last Name'),
                    subtitle: Text(patient.emergencyLastName),
                  ),
                  ListTile(
                    title: Text('Relationship'),
                    subtitle: Text(patient.relationship),
                  ),
                  ListTile(
                    title: Text('Emergency Phone'),
                    subtitle: Text(patient.emergencyPhone),
                  ),
                  ListTile(
                    title: Text('Known Medical Illnesses'),
                    subtitle: Text(patient.knownMedicalIllnesses),
                  ),
                  ListTile(
                    title: Text('Previous Medical Illnesses'),
                    subtitle: Text(patient.previousMedicalIllnesses),
                  ),
                  ListTile(
                    title: Text('Allergies'),
                    subtitle: Text(patient.allergies),
                  ),
                  ListTile(
                    title: Text('Current Medications'),
                    subtitle: Text(patient.currentMedications),
                  ),
                  ListTile(
                    title: Text('Past Medications'),
                    subtitle: Text(patient.pastMedications),
                  ),
                ],
              ),
            );
          } else {
            return Text('No data');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
