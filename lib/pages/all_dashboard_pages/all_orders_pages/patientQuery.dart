// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/labtests.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/radiologyscans.dart';
import 'package:flutter/cupertino.dart';

class DocumentListScreen extends StatelessWidget {
  final String collectionName;

  DocumentListScreen({required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Colors.white), // back arrow color
          backgroundColor: const Color.fromARGB(159, 144, 79, 230),
          title: Padding(
            padding: const EdgeInsets.only(left: 55),
            child: Text('Select a Patient',
                style: const TextStyle(color: Colors.white)),
          ),

        ),
      body: DocumentList(collectionName: collectionName),
    );
  }
}

class DocumentList extends StatelessWidget {
  final String collectionName;

  DocumentList({required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No documents found.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document.get('firstName') + ' ' + document.get('lastName')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentDetailScreen(document: document),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class DocumentDetailScreen extends StatelessWidget {
  final DocumentSnapshot document;

  DocumentDetailScreen({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Colors.white), // back arrow color
          backgroundColor: const Color.fromARGB(159, 144, 79, 230),
          title: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text('Select Testing Department',
                style: const TextStyle(color: Colors.white)),
          ),
        ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) =>  RadiologyScans(document: document)),
                    ),
                  );
                },
                mainText: AppLocalizations.of(context)!.radiology,
                subText: '',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 7),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) =>  LabTests(document: document)),
                    ),
                  );
                },
                mainText: AppLocalizations.of(context)!.lab_title,
                subText: '',
                width: 400,
                height: 120,
              ),
          ],
        ),
      ),
    );
  }
  
}

