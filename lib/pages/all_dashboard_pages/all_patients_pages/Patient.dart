// ignore_for_file: file_names

class Patient {
  String uid;
  String lowerCaseSearchTokens;
  String firstName;
  String middleName;
  String lastName;
  String dob;
  String bloodGroup;
  String rhFactor;
  String maritalStatus;
  String preferredLanguage;
  String homePhone;
  String phone;
  String email;
  String emergencyFirstName;
  String emergencyLastName;
  String relationship;
  String emergencyPhone;
  String knownMedicalIllnesses;
  String previousMedicalIllnesses;
  String allergies;
  String currentMedications;
  String pastMedications;
  String? imageURL;

  Patient({
    required this.uid,
    required this.lowerCaseSearchTokens,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.bloodGroup,
    required this.rhFactor,
    required this.maritalStatus,
    required this.preferredLanguage,
    required this.homePhone,
    required this.phone,
    required this.email,
    required this.emergencyFirstName,
    required this.emergencyLastName,
    required this.relationship,
    required this.emergencyPhone,
    required this.knownMedicalIllnesses,
    required this.previousMedicalIllnesses,
    required this.allergies,
    required this.currentMedications,
    required this.pastMedications,
    this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'lowerCaseSearchTokens': lowerCaseSearchTokens,
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
    };
  }
}
