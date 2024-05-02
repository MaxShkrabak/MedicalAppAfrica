import 'package:africa_med_app/components/Patients_Comps/add_patient_tfs.dart';
import 'package:flutter/material.dart';
import 'patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class AddPatientPage extends StatefulWidget {
  final Function updatePatientsCallback;

  const AddPatientPage({super.key, required this.updatePatientsCallback});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _rhFactorController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _preferredLanguageController =
      TextEditingController();
  final TextEditingController _homePhoneController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyFirstNameController =
      TextEditingController();

  final TextEditingController _emergencyLastNameController =
      TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _knownMedicalIllnessesController =
      TextEditingController();
  final TextEditingController _previousMedicalIllnessesController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _currentMedicationsController =
      TextEditingController();
  final TextEditingController _pastMedicationsController =
      TextEditingController();
  final TextEditingController _caregiverController = TextEditingController();
  //mask text input formatter for phone numbers
  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####', 
    filter: {"#": RegExp(r'[0-9]')},
    );

  signUp(BuildContext context) async {
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
    final String previousMedicalIllnesses =
        _previousMedicalIllnessesController.text;
    final String allergies = _allergiesController.text;
    final String currentMedications = _currentMedicationsController.text;
    final String pastMedications = _pastMedicationsController.text;
    final String caregiver = _caregiverController.text;


    final String patient = '$firstName $middleName $lastName';
    
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference ref = await firestore.collection('patients').add({
      'lowerCaseSearchTokens':
          '${firstName.toLowerCase()} ${middleName.toLowerCase()} ${lastName.toLowerCase()}',
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
      'caregiver': caregiver,
      
    });
    

    // Create a new patient object
    final Patient newPatient = Patient(

      uid: ref.id,
      lowerCaseSearchTokens:
          '${firstName.toLowerCase()} ${middleName.toLowerCase()} ${lastName.toLowerCase()}',
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
      caregiver: caregiver,
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
    _caregiverController.clear();
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
              Tab(text: 'Personal Info'),
              Tab(text: 'Contact Info'),
              Tab(text: 'Medical Info'),
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
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _firstNameController,
                        hintText: "Enter First Name"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _middleNameController,
                        hintText: "Enter Middle Name"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _lastNameController,
                        hintText: "Enter Last Name"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: false,
                        controller: _dobController,
                        hintText: "Date of Birth (YYYY/MM/DD)"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _bloodGroupController,
                        hintText: "Enter Blood Group"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _rhFactorController,
                        hintText: "Enter RH factor"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _maritalStatusController,
                        hintText: "Enter Marital Status"),
                    const SizedBox(height: 12),
                    AddPatientTFs(
                        onlyChars: true,
                        controller: _preferredLanguageController,
                        hintText: "Enter Preferred Language"),
                    const SizedBox(height: 16),
                    // forward button that takes care to avoid issues with DefaultTabController context bugs
                    Builder(
                      builder: (BuildContext context) {
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              DefaultTabController.of(context)!.animateTo(1);
                            },
                            child: const Text('Next'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPatientTFs(
                      onlyChars: false,
                      controller: _homePhoneController,
                      maskFormatters: [phoneFormatter],
                      hintText: "Enter Home Phone"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: false,
                      controller: _phoneController,
                      maskFormatters: [phoneFormatter],
                      hintText: "Enter Phone Number"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: false,
                      controller: _emailController,
                      hintText: "Enter Email Address"),
                  const SizedBox(height: 24),
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _emergencyFirstNameController,
                      hintText: "Enter First Name"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _emergencyLastNameController,
                      hintText: "Enter Last Name"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _relationshipController,
                      hintText: "Enter Relationship"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: false,
                      controller: _emergencyPhoneController,
                      maskFormatters: [phoneFormatter],
                      hintText: "Enter Phone Number"),
                  const SizedBox(height: 16),
                  //forward and back buttons
                  Builder(
                    builder: (BuildContext context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              DefaultTabController.of(context)!.animateTo(0);
                            },
                            child: const Text('Back'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              DefaultTabController.of(context)!.animateTo(2);
                            },
                            child: const Text('Next'),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _knownMedicalIllnessesController,
                      hintText: "Enter Known Medical Illnesses"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _previousMedicalIllnessesController,
                      hintText: "Enter Previous Medical Illnesses"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _allergiesController,
                      hintText: "Enter Known Allergies"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _currentMedicationsController,
                      hintText: "Enter Current Medications"),
                  const SizedBox(height: 12),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _pastMedicationsController,
                      hintText: "Enter Past Medications"),
                  const SizedBox(height: 60),
                  AddPatientTFs(
                      onlyChars: true,
                      controller: _caregiverController,
                      hintText: "Signing as Primary Caregiver:"),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green)),
                        onPressed: () {
                          Navigator.pop(context);

                          signUp(context);
                        },
                        child: const Text(
                          'Finish',
                          style: TextStyle(color: Colors.white),
                        ),
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
