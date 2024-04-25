// Page for composing a new message

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ComposePage extends StatefulWidget {
  final String uid;

  const ComposePage({super.key, required this.uid});

  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _messageController = TextEditingController();

  Future<DocumentSnapshot> _loadContact() {
    return FirebaseFirestore.instance.collection('accounts').doc(widget.uid).get();
  }

  Future<String> getMyName() async {
    DocumentSnapshot myDocSnap = await FirebaseFirestore.instance.collection('accounts').doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic>  data = myDocSnap.data() as Map<String, dynamic>;
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    return firstName + ' ' + lastName;
  }

  Future<String> getTheirName() async {
    DocumentSnapshot theirDocSnap = await FirebaseFirestore.instance.collection('accounts').doc(widget.uid).get();
    Map<String, dynamic>  data = theirDocSnap.data() as Map<String, dynamic>;
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    return firstName + ' ' + lastName;
  }

  void sendMessage(String uid, String message) {
    // Send a copy to the recipients account
    final CollectionReference messages = FirebaseFirestore.instance.collection('accounts').doc(uid).collection('messages');
    final User? currentUser = FirebaseAuth.instance.currentUser;
    // Get the current users first and last name
    getMyName().then((value) {
      String name = value;
      messages.add({
        'message': message,
        'timestamp': DateTime.now(),
        'sender_name': name,
      });
    });

    // Save a copy to the senders sent box
    String currentUserUid = currentUser!.uid;
    final CollectionReference sent = FirebaseFirestore.instance.collection('accounts').doc(currentUserUid).collection('sent');
    getTheirName().then((value) {
      String name = value;
      sent.add({
        'message': message,
        'timestamp': DateTime.now(),
        'recipient_name': name,
      });
    });
    Navigator.pop(context);
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
                backgroundColor: Color.fromARGB(156, 102, 134, 161),
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