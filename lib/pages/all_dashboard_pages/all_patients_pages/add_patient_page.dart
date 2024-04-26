
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Patient.dart';

class AddPatientPage extends StatefulWidget {
  final Function updatePatientsCallback;

  const AddPatientPage({super.key, required this.updatePatientsCallback});
  

  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _rhFactorController = TextEditingController();
  final TextEditingController _maritalStatusController = TextEditingController();
  final TextEditingController _preferredLanguageController = TextEditingController();
  final TextEditingController _homePhoneController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyFirstNameController = TextEditingController();

  final TextEditingController _emergencyLastNameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _knownMedicalIllnessesController = TextEditingController();
  final TextEditingController _previousMedicalIllnessesController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _currentMedicationsController = TextEditingController();
  final TextEditingController _pastMedicationsController = TextEditingController();




  signUp() async {
    final String firstName = _firstNameController.text;
    final String middleName = _middleNameController.text;
    final String lastName = _lastNameController.text;
    final String dob = _dobController.text;
    final String bloodGroup = _bloodGroupController.text;
    final String rhFactor = _rhFactorController.text;
    final String maritalStatus = _maritalStatusController.text;
    final String preferredLanguage = _preferredLanguageController.text;
    final String homePhone = _homePhoneController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;
    final String emergencyFirstName = _emergencyFirstNameController.text;
    final String emergencyLastName = _emergencyLastNameController.text;
    final String relationship = _relationshipController.text;
    final String emergencyPhone = _emergencyPhoneController.text;
    final String knownMedicalIllnesses = _knownMedicalIllnessesController.text;
    final String previousMedicalIllnesses = _previousMedicalIllnessesController.text;
    final String allergies = _allergiesController.text;
    final String currentMedications = _currentMedicationsController.text;
    final String pastMedications = _pastMedicationsController.text;

    final String patient = '$firstName $middleName $lastName';
    

    // Make a commit to the patients collection of the firestore
    // with the patient's details
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference ref = await firestore.collection('patients').add({
      'lowerCaseSearchTokens': firstName.toLowerCase() + ' ' + middleName.toLowerCase() + ' ' + lastName.toLowerCase(),
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'rhFactor': rhFactor,
      'maritalStatus': maritalStatus,
      'preferredLanguage': preferredLanguage,
      'homePhone': homePhone,
      'phone': phone,
      'email': email,
      'emergencyFirstName': emergencyFirstName,
      'emergencyLastName': emergencyLastName,
      'relationship': relationship,
      'emergencyPhone': emergencyPhone,
      'knownMedicalIllnesses': knownMedicalIllnesses,
      'previousMedicalIllnesses': previousMedicalIllnesses,
      'allergies': allergies,
      'currentMedications': currentMedications,
      'pastMedications': pastMedications,
    });

    // Create a new patient object
    final Patient newPatient = Patient(
      uid: '',
      lowerCaseSearchTokens: firstName.toLowerCase() + ' ' + middleName.toLowerCase() + ' ' + lastName.toLowerCase(),
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      dob: dob,
      bloodGroup: bloodGroup,
      rhFactor: rhFactor,
      maritalStatus: maritalStatus,
      preferredLanguage: preferredLanguage,
      homePhone: homePhone,
      phone: phone,
      email: email,
      emergencyFirstName: emergencyFirstName,
      emergencyLastName: emergencyLastName,
      relationship: relationship,
      emergencyPhone: emergencyPhone,
      knownMedicalIllnesses: knownMedicalIllnesses,
      previousMedicalIllnesses: previousMedicalIllnesses,
      allergies: allergies,
      currentMedications: currentMedications,
      pastMedications: pastMedications,
    );

    // Send the new patient object to the parent widget
    widget.updatePatientsCallback(newPatient);

    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
    _bloodGroupController.clear();
    _rhFactorController.clear();
    _maritalStatusController.clear();
    _preferredLanguageController.clear();
    _homePhoneController.clear();
    _phoneController.clear();
    _emailController.clear();
    _emergencyFirstNameController.clear();
    _emergencyLastNameController.clear();
    _relationshipController.clear();
    _emergencyPhoneController.clear();
    _knownMedicalIllnessesController.clear();
    _previousMedicalIllnessesController.clear();
    _allergiesController.clear();
    _currentMedicationsController.clear();
    _pastMedicationsController.clear();
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Patient'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Personal Information'),
              Tab(text: 'Contact Information'),
              Tab(text: 'Medical Information'),
            ],
          ),
        ),
        body: TabBarView(
          children: [ 
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'First Name:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter first name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Middle Name:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _middleNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter middle name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Last Name:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter last name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Date of Birth (YYYY/MM/DD):',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        hintText: 'Enter date of birth',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Blood Group:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _bloodGroupController,
                      decoration: InputDecoration(
                        hintText: 'Enter blood group',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'RH Factor:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _rhFactorController,
                      decoration: InputDecoration(
                        hintText: 'Enter RH factor',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Marital Status:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _maritalStatusController,
                      decoration: InputDecoration(
                        hintText: 'Enter marital status',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Preferred Language:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: _preferredLanguageController,
                      decoration: InputDecoration(
                        hintText: 'Enter preferred language',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Home Phone:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _homePhoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter home phone',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Phone:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Email Address:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'First Name:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _emergencyFirstNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter first name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Last Name:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _emergencyLastNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter last name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Relationship:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _relationshipController,
                    decoration: InputDecoration(
                      hintText: 'Enter relationship',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Phone Number:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _emergencyPhoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Known Medical Illnesses:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _knownMedicalIllnessesController,
                    decoration: InputDecoration(
                      hintText: 'Enter known medical illnesses',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Previous Medical Illnesses:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _previousMedicalIllnessesController,
                    decoration: InputDecoration(
                      hintText: 'Enter previous medical illnesses',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Allergies:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _allergiesController,
                    decoration: InputDecoration(
                      hintText: 'Enter allergies',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Current Medications:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _currentMedicationsController,
                    decoration: InputDecoration(
                      hintText: 'Enter current medications',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Past Medications:',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: _pastMedicationsController,
                    decoration: InputDecoration(
                      hintText: 'Enter past medications',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          signUp();
                        },
                        child: const Text('Finish'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



