import 'package:africa_med_app/components/Dashboard_Comps/Tiles.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/Orders.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_messaging_pages/messaging_page.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/patients_page.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/schedule_page.dart';
import 'package:africa_med_app/pages/all_settings_pages/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late String _userName = '';
  late String _userImageUrl = '';

  @override
  void initState() {
    super.initState();
    getUserName();
    getUserImageUrl();
  }

  Future<void> getUserImageUrl() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .get();
      String imageUrl = userSnap.get('imageURL');
      setState(() {
        _userImageUrl = imageUrl;
      });
    } catch (error) {
      print('Error fetching user image URL: $error');
    }
  }

  Future<void> getUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .get();
      String firstName = userSnap.get('first_name');
      setState(() {
        _userName = firstName;
      });
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

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
          backgroundColor: const Color.fromARGB(156, 102, 133, 161),
          body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "$_userName!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(width: 20), // Add some spacing
                              const Icon(
                                Icons.waving_hand,
                                color: Color.fromARGB(255, 241, 182, 4),
                                size: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                          width: 90), // Add spacing between name and image
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: ((context) => const SettingsPage()),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              backgroundImage: _userImageUrl.isNotEmpty
                                  ? NetworkImage(_userImageUrl)
                                  : const AssetImage(
                                          'assets/Anonymous_profile.jpg')
                                      as ImageProvider<Object>,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Settings",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    thickness: 2,
                  ),
                  const SizedBox(height: 5),
                  //search box stuff here
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 10), // Adjust margin as needed
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0)
                          .withOpacity(0.7), // Adjust opacity as needed
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white), // Text color
                      decoration: InputDecoration(
                        hintText: 'Search', // Placeholder text
                        hintStyle: TextStyle(
                            color: Colors.white
                                .withOpacity(0.5)), // Placeholder color
                        icon: const Icon(Icons.search,
                            color: Colors.white), // Search icon
                        border: InputBorder.none, // Remove border
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Tiles(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: ((context) => const PatientList()),
                        ),
                      );
                    },
                    mainText: 'Patients',
                    width: 400,
                    height: 120,
                  ),
                  const SizedBox(height: 7),
                  Tiles(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: ((context) => const Schedule()),
                        ),
                      );
                    },
                    mainText: 'Scheduling',
                    width: 400,
                    height: 120,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Tiles(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: ((context) => Messaging()),
                              ),
                            );
                          },
                          mainText: "Messaging",
                          height: 120,
                          width: 170),
                      Tiles(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: ((context) => const OrderingSystem()),
                              ),
                            );
                          },
                          mainText: "Orders",
                          height: 120,
                          width: 170)
                    ],
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        signUserOut();
                      },
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
