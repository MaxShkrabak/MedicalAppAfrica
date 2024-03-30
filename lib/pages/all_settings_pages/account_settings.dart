import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//######
//this was used from someone's github repository, not made by me.
//#######
class PickImage extends StatefulWidget {
  const PickImage({Key? key}) : super(key: key);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  Uint8List? _image;
  File? selectedImage;
  String? imageUrl; // Store the image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Image'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: Stack(
          children: [
            // Widget to display selected image or default image
            _image != null
                ? CircleAvatar(
                    radius: 100, backgroundImage: MemoryImage(_image!))
                : const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                  ),
            Positioned(
              bottom: -0,
              left: 140,
              child: IconButton(
                onPressed: () {
                  showImagePickerOption(context);
                },
                icon: const Icon(Icons.add_a_photo),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Function to show image picker options
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
                      _pickImageFromGallery();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 70,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 70,
                          ),
                          Text("Camera")
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

  // Function to pick image from gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    uploadImageToFirebase(); // Upload image to Firebase Storage
    Navigator.of(context).pop(); // Close the modal sheet
  }

  // Function to pick image from camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    uploadImageToFirebase(); // Upload image to Firebase Storage
    Navigator.of(context).pop(); // Close the modal sheet
  }

  // Function to upload image to Firebase Storage
  Future<void> uploadImageToFirebase() async {
    try {
      if (selectedImage == null) return;

      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images')
          .child('image.jpg');

      await ref.putFile(selectedImage!);

      // Get the download URL for the uploaded image
      String downloadURL = await ref.getDownloadURL();

      // Update the UI to display the uploaded image
      setState(() {
        imageUrl = downloadURL;
      });

      // Update the user's document in Firestore with the image URL
      updateUserImageUrlInFirestore(downloadURL);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Function to update user's document in Firestore with image URL
  Future<void> updateUserImageUrlInFirestore(String imageUrl) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('accounts').doc(uid).update({
        'imageURL': imageUrl,
      });
    } catch (error) {
      print('Error updating user image URL in Firestore: $error');
    }
  }
}
