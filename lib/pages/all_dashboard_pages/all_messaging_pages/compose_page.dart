// Page for composing a new message

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ComposePage extends StatefulWidget {
  final String uid;

  const ComposePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _messageController = TextEditingController();

  Future<DocumentSnapshot> _loadContact() {
    return FirebaseFirestore.instance.collection('accounts').doc(widget.uid).get();
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
              appBar: AppBar(
                title: Text('Compose to $firstName $lastName'),
                backgroundColor: Colors.white,
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