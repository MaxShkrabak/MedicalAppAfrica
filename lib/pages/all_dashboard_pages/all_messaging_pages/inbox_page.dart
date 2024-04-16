import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'message_tile.dart';



class InboxPage extends StatelessWidget {
  InboxPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserUid = currentUser!.uid;
    final Future<QuerySnapshot> messagesFuture = _firestore.collection('accounts').doc(currentUserUid).collection('messages').get();

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
          title: const Text('Inbox'),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
         child: FutureBuilder<QuerySnapshot>(
            future: messagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final String sender = message['sender_name'];
                    final String messageText = message['message'];
                    final String time = DateFormat('MM/dd kk:mm').format(message['timestamp'].toDate());
                    return MessageTile(
                      sender: sender,
                      message: messageText,
                      time: time,
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
         )
        ),
      ),
    );
  }
}

