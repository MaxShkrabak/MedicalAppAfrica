import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'inbox_page.dart';
import 'sent_page.dart';
import 'contacts_page.dart';
import 'compose_page.dart';






class Messaging extends StatelessWidget {
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
          title: const Text('Messaging'),
          backgroundColor: Colors.white,
        ),  
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [

                const SizedBox(height: 60),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const InboxPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Inbox',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  ),
                ),

                const SizedBox(height: 60),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const SentPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Sent',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  ),
                ),

                const SizedBox(height: 60),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ContactsPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Search Contacts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  ),
                ),

          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
