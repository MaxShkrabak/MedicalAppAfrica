import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'inbox_page.dart';
import 'sent_page.dart';
import 'contacts_page.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';

class Messaging extends StatelessWidget {
  const Messaging({super.key});

  @override
  Widget build(BuildContext context) {
    return /*Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
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
          child: */
        Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // back arrow color
        title: const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Text(
            'Messaging',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(
            159, 144, 79, 230), //old: Color.fromARGB(156, 102, 134, 161),
      ),
      backgroundColor: const Color.fromARGB(246, 244, 236, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => InboxPage(),
                    ),
                  );
                },
                mainText: 'Inbox',
                subText: 'View messages',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 60),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SentPage(),
                    ),
                  );
                },
                mainText: 'Sent',
                subText: 'View sent messages',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 60),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const ContactsPage(),
                    ),
                  );
                },
                mainText: 'Contacts',
                subText: 'View contacts',
                width: 400,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
    //));
  }
}
