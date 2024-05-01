import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComposePage extends StatefulWidget {
  final String uid;

  const ComposePage({super.key, required this.uid});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _messageController = TextEditingController();
  File? _image;

  Future<DocumentSnapshot> _loadContact() {
    return FirebaseFirestore.instance
        .collection('accounts')
        .doc(widget.uid)
        .get();
  }

  Future<String> getMyName() async {
    DocumentSnapshot myDocSnap = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic> data = myDocSnap.data() as Map<String, dynamic>;
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    return '$firstName $lastName';
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Future<void> sendMessage(String uid, String message) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserUid = currentUser!.uid;

    // Upload image to Firebase Storage if an image is selected
    String? imageUrl;
    if (_image != null) {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final UploadTask uploadTask = ref.putFile(_image!);
      await uploadTask.whenComplete(() async {
        imageUrl = await ref.getDownloadURL();
      });
    }

    // Send the message
    final CollectionReference messages = FirebaseFirestore.instance
        .collection('accounts')
        .doc(uid)
        .collection('messages');
    getMyName().then((value) {
      String name = value;
      messages.add({
        'message': message,
        'image': imageUrl, // Include image URL in message
        'timestamp': DateTime.now(),
        'sender_name': name,
      });
    });

    // Save a copy to the sender's sent box
    final CollectionReference sent = FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUserUid)
        .collection('sent');
    final String recipientName = await getRecipientName();
    sent.add({
      'message': message,
      'image': imageUrl, // Include image URL in message
      'timestamp': DateTime.now(),
      'recipient_name': recipientName,
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<String> getRecipientName() async {
    DocumentSnapshot theirDocSnap = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(widget.uid)
        .get();
    Map<String, dynamic> data = theirDocSnap.data() as Map<String, dynamic>;
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    return '$firstName $lastName';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _loadContact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String firstName = data['first_name'];
          final String lastName = data['last_name'];

          return Container(
            decoration: const BoxDecoration(
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
                backgroundColor: const Color.fromARGB(156, 102, 134, 161),
                title: Text('Compose to $firstName $lastName'),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here',
                        ),
                        maxLines: 10,
                      ),
                    ),
                    _image != null
                        ? SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.file(File(_image!.path)),
                          )
                        : const SizedBox(), // Display selected image if available
                    ElevatedButton(
                      onPressed: () {
                        _getImage();
                      },
                      child: const Text('Select Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Send the message
                        sendMessage(
                          widget.uid,
                          _messageController.text,
                        );
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
