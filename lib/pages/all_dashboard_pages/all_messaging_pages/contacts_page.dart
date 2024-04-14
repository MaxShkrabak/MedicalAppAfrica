import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'compose_page.dart';



class ContactsPage extends StatefulWidget {
  ContactsPage({Key? key}) : super(key: key);
  
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();

  // List of documents, the state of this widget that changes on setState
  List<DocumentSnapshot> _docs = [];
  

  // Logic to search for contacts in this function
  void _onSearchTextChanged(String text) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // If empty, ...
    if (text.isEmpty) {
      setState(() {
        _docs = [];
      });
    } else {

      // Search for contacts with first_name or last_name equal to text
      final QuerySnapshot first_query = await _firestore.collection('accounts').where('first_name', isEqualTo: text).get();
      final QuerySnapshot last_query = await _firestore.collection('accounts').where('last_name', isEqualTo: text).get();
      
      // Use a Map, or Dictionary  data structure to store the documents. This avoids duplicates by having the id as the key
      Map<String, DocumentSnapshot> docMap = {};

      for (final doc in first_query.docs) {
        setState(() {
          docMap[doc.id] = doc;
        });
      }

      for (final doc in last_query.docs) {
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

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Contacts'),
          backgroundColor: Colors.white,
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
                    labelText: 'Search Contacts',
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
                  ? Center(child: Text('No contacts found'))
                  : ListView.builder(
                      itemCount: _docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComposePage(uid: _docs[index].id)
                              )
                            );
                          },
                          title: Text(_docs[index]['first_name'] + ' ' + _docs[index]['last_name']),
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