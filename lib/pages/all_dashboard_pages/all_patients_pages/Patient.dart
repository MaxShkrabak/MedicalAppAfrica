class Patient{
  final String uid;
  final String lowerCaseSearchTokens;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String bloodGroup;
  final String rhFactor;
  final String maritalStatus;
  final String preferredLanguage;
  final String homePhone;
  final String phone;
  final String email;
  final String emergencyFirstName;
  final String emergencyLastName;
  final String relationship;
  final String emergencyPhone;
  final String knownMedicalIllnesses;
  final String previousMedicalIllnesses;
  final String allergies;
  final String currentMedications;
  final String pastMedications;

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
  });
}