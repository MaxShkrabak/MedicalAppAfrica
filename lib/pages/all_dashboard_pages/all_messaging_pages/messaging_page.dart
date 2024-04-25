import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'inbox_page.dart';
import 'sent_page.dart';
import 'contacts_page.dart';
import 'package:africa_med_app/components/Dashboard_Comps/Tiles.dart';



class Messaging extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
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
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Messaging'),
            backgroundColor: Color.fromARGB(156, 102, 134, 161),
          ),
          backgroundColor: Color.fromARGB(156, 102, 133, 161),
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
                          builder: (context) => ContactsPage(),
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
        ),
      )   
    );
  }
}
