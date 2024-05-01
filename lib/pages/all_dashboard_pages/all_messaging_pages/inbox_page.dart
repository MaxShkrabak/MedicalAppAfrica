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
    final Future<QuerySnapshot> messagesFuture = _firestore
        .collection('accounts')
        .doc(currentUserUid)
        .collection('messages')
        .get();

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
        backgroundColor: const Color.fromRGBO(76, 90, 137, 1),
        appBar: AppBar(
          title: const Text('Inbox'),
          backgroundColor: const Color.fromARGB(156, 102, 134, 161),
        ),
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot>(
            future: messagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final List<QueryDocumentSnapshot> messages =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final String sender = message['sender_name'];
                    final String messageText = message['message'];
                    final String time = DateFormat('MM/dd kk:mm')
                        .format(message['timestamp'].toDate());
                    final String? imageUrl = message['image'];
                    return Dismissible(
                      key: Key(messages[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _firestore
                            .collection('accounts')
                            .doc(currentUserUid)
                            .collection('messages')
                            .doc(messages[index].id)
                            .delete();
                      },
                      child: MessageTile(
                        sender: sender,
                        message: messageText,
                        time: time,
                        imageUrl: imageUrl, // Pass imageUrl to MessageTile
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
