import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'compose_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();

  // List of documents, the state of this widget that changes on setState
  List<DocumentSnapshot> _docs = [];

  // Logic to search for contacts in this function
  void _onSearchTextChanged(String text) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // If empty, ...
    if (text.isEmpty) {
      setState(() {
        _docs = [];
      });
    } else {
      final List<String> tokens = text.split(' ');

      // iterate over the tokens
      for (final token in tokens) {
        // Search for contacts with first_name or last_name equal to text
        final QuerySnapshot firstQuery = await firestore
            .collection('accounts')
            .where('first_name', isEqualTo: token)
            .get();
        final QuerySnapshot lastQuery = await firestore
            .collection('accounts')
            .where('last_name', isEqualTo: token)
            .get();

        // Search for contacts where the access_level is equal to text
        final QuerySnapshot accessQuery = await firestore
            .collection('accounts')
            .where('access_level', isEqualTo: token)
            .get();

        // Use a Map, or Dictionary  data structure to store the documents. This avoids duplicates by having the id as the key
        Map<String, DocumentSnapshot> docMap = {};

        for (final doc in firstQuery.docs) {
          setState(() {
            docMap[doc.id] = doc;
          });
        }

        for (final doc in lastQuery.docs) {
          setState(() {
            docMap[doc.id] = doc;
          });
        }

        for (final doc in accessQuery.docs) {
          setState(() {
            docMap[doc.id] = doc;
          });
        }

        final List<DocumentSnapshot> docsMerged = docMap.values.toList();
        setState(() {
          _docs = docsMerged;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            246, 244, 236, 255), // White background for visibility
        appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Colors.white), // back arrow color
          title: Padding(
            padding: const EdgeInsets.only(left: 85),
            child: Text(AppLocalizations.of(context)!.contacts,
                style: const TextStyle(color: Colors.white)),
          ),
          backgroundColor: const Color.fromARGB(159, 144, 79,
              230), //old: const Color.fromARGB(156, 102, 134, 161),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchTextChanged,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search_contact,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _docs.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.no_contacts))
                    : ListView.builder(
                        itemCount: _docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ComposePage(uid: _docs[index].id)));
                              },
                              child: ListTile(
                                title: Text(_docs[index]['first_name'] +
                                    ' ' +
                                    _docs[index]['last_name']),
                                subtitle: Text(_docs[index]['access_level']),
                                trailing: const Icon(Icons.message),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
