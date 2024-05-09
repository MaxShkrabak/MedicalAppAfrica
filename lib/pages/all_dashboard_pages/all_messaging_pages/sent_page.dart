import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'message_tile.dart';

class SentPage extends StatelessWidget {
  SentPage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserUid = currentUser!.uid;
    final Future<QuerySnapshot> messagesFuture = _firestore
        .collection('accounts')
        .doc(currentUserUid)
        .collection('sent')
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
        backgroundColor: const Color.fromARGB(
            246, 244, 236, 255), //old: const Color.fromRGBO(76, 90, 137, 1),
        appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Colors.white), // back arrow color
          title: Padding(
            padding: const EdgeInsets.only(left: 110),
            child: Text(AppLocalizations.of(context)!.sent,
                style: const TextStyle(color: Colors.white)),
          ),
          backgroundColor: const Color.fromARGB(159, 144, 79,
              230), //old: const Color.fromARGB(156, 102, 134, 161),
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
                    final String sender = message['recipient_name'];
                    final String messageText = message['message'];
                    final String time = DateFormat('MM/dd kk:mm')
                        .format(message['timestamp'].toDate());
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
                              title: Text(
                                AppLocalizations.of(context)!.confirm_button,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!.confirm_delete,
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                        AppLocalizations.of(context)!.delete)),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(AppLocalizations.of(context)!
                                      .cancel_button),
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
                            .collection('sent')
                            .doc(messages[index].id)
                            .delete();
                      },
                      child: MessageTile(
                        sender: sender,
                        message: messageText,
                        time: time,
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
