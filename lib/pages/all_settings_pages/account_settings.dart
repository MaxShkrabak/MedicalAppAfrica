// Add the necessary imports
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:africa_med_app/components/Settings_Comps/name_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' show basename;

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Uint8List? _image;
  String? imageUrl;
  String? uid;
  String? userRole;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('accounts')
          .doc(uid)
          .get();

      setState(() {
        _nameController.text = userData['first_name'] ?? '';
        _lastNameController.text = userData['last_name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneNumberController.text = userData['phone_number'] ?? '';
        imageUrl = userData['imageURL'];
        userRole = userData['access_level'];
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  Future<void> _uploadImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image == null) {
      return;
    }
    final File file = File(image.path);
    final String fileName = basename(file.path);
    final Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    final String url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(uid)
        .update({'imageURL': url});
    setState(() {
      imageUrl = url;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.account_settings,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(159, 144, 79, 230),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 60,
      ),
      backgroundColor: const Color.fromARGB(246, 244, 236, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showImagePickerOption(context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 59,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : (imageUrl != null && imageUrl!.isNotEmpty)
                              ? CircleAvatar(
                                  radius: 59,
                                  backgroundImage: NetworkImage(imageUrl!),
                                )
                              : const CircleAvatar(
                                  radius: 59,
                                  backgroundImage: AssetImage(
                                      "assets/Anonymous_profile.jpg"),
                                ),
                      Text(
                        AppLocalizations.of(context)!.edit,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!
                      .access_role(userRole ?? "Isn't assigned."),
                  style: const TextStyle(color: Color.fromARGB(180, 0, 0, 0)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SettingsNameTextField(
                        hintText: AppLocalizations.of(context)!.first_name,
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SettingsNameTextField(
                        hintText: AppLocalizations.of(context)!.last_name,
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SettingsNameTextField(
                  hintText: AppLocalizations.of(context)!.email,
                  controller: _emailController,
                  isEmailField: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: Text(
                                AppLocalizations.of(context)!.change_email),
                          ),
                          content: Text(
                            AppLocalizations.of(context)!.email_popup,
                            style: const TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.okay),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                SettingsNameTextField(
                  hintText: AppLocalizations.of(context)!.phone_number,
                  controller: _phoneNumberController,
                  isPhoneNumberField: true,
                ),
                const SizedBox(
                  height: 180,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content:
                                Text(AppLocalizations.of(context)!.enter_name),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.okay),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (_lastNameController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content:
                                Text(AppLocalizations.of(context)!.enter_last),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.okay),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (_emailController.text.isNotEmpty &&
                        isValidEmail(_emailController.text)) {
                      if (_phoneNumberController.text.isNotEmpty &&
                          isValidPhoneNumber(_phoneNumberController.text)) {
                        saveUserData();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.error),
                              content: Text(
                                  AppLocalizations.of(context)!.enter_phone),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.okay),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content:
                                Text(AppLocalizations.of(context)!.enter_email),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.okay),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('accounts').doc(uid).update({
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone_number': _phoneNumberController.text,
    }).then((_) {
      print("Data updated successfully!");
      if (_image != null) {
        ();
      }
      showSuccessMessage(context);
    }).catchError((error) {
      print("Failed to update user data: $error");
    });
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.change_success),
      ),
    );
  }
}
