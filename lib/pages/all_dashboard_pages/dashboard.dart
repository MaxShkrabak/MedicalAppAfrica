import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/Orders.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_messaging_pages/messaging_page.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_scheduling_pages/appointments.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_patients_pages/patients_page.dart';
import 'package:africa_med_app/pages/all_settings_pages/settings_page.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_admin_pages/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key, required this.updateIsUserRegistered});

  final Function(bool) updateIsUserRegistered;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late String _userName = '';
  late String _userImageUrl = '';
  late String _accessLevel = '';

  Future<String> getAccessLevel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();
      return doc['access_level'];
    } else {
      //user is null
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    getAccessLevel().then((value) {
      setState(() {
        _accessLevel = value;
      });
    });
  }

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
      backgroundColor: const Color.fromARGB(
          246, 244, 236, 255), //old: Color.fromARGB(156, 102, 133, 161)
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  _userName = snapshot.data?['first_name'] ?? '';
                  _userImageUrl = snapshot.data?['imageURL'] ?? '';
                  return _buildDashboard();
                },
              ),
            ],
          ),
        ),
      ),
    );
    //),
    //);
  }

  Stream<DocumentSnapshot> _getUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .snapshots();
    } else {
      //returns empty stream if no current user
      return const Stream.empty();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.dash_welcome,
                    style: const TextStyle(
                      color: Color.fromARGB(180, 0, 0, 0),
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
                          color: Color.fromARGB(180, 0, 0, 0),
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
              const SizedBox(width: 90), // Add spacing between name and image
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
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                      backgroundImage: _userImageUrl.isNotEmpty
                          ? NetworkImage(_userImageUrl)
                          : const AssetImage('assets/Anonymous_profile.jpg')
                              as ImageProvider<Object>,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
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
          //Container(
          //  margin: const EdgeInsets.only(bottom: 10),
          //  padding: const EdgeInsets.symmetric(horizontal: 10),
          //  decoration: BoxDecoration(
          //    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
          //    borderRadius: BorderRadius.circular(10),
          //  ),
          //  child: TextField(
          //    style: const TextStyle(color: Colors.white), // Text color
          //    decoration: InputDecoration(
          //      hintText: 'Search',
          //      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          //      icon: const Icon(Icons.search,
          //          color: Colors.white), // Search icon
          //      border: InputBorder.none, // Remove border
          //    ),
          //  ),
          //),
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
            mainText: AppLocalizations.of(context)!.patients,
            subText: '',
            width: 400,
            height: 120,
          ),
          const SizedBox(height: 7),
          if (_accessLevel != 'Physician Assistant')
            StreamBuilder(
              stream: _getNextAppointment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                  if (querySnapshot.docs.isNotEmpty) {
                    DocumentSnapshot appointmentSnap = querySnapshot.docs.first;
                    Map<String, dynamic> data =
                        appointmentSnap.data() as Map<String, dynamic>;
                    Appointment nextAppointment = Appointment(
                      dateTime: (data['date'] as Timestamp).toDate(),
                      meetingDetails: data['meetingDetails'] ?? '',
                      timeSlot: data['timeSlot'] ?? '',
                    );
                    return Tiles(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: ((context) => const AppointmentsPage()),
                          ),
                        );
                      },
                      mainText:
                          AppLocalizations.of(context)!.appointment_nextup,
                      subText: DateFormat('MMMM d, y - HH:mm')
                          .format(nextAppointment.dateTime.toLocal()),
                      width: 400,
                      height: 120,
                    );
                  }
                }
                return Tiles(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: ((context) => const AppointmentsPage()),
                      ),
                    );
                  },
                  mainText: AppLocalizations.of(context)!.appointments,
                  subText: '',
                  width: 400,
                  height: 120,
                );
              },
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
                        builder: ((context) => const Messaging()),
                      ),
                    );
                  },
                  mainText: AppLocalizations.of(context)!.messaging,
                  subText: '',
                  height: 120,
                  width: 170),
              if (_accessLevel != 'Physician Assistant' &&
                  _accessLevel != 'Nurse')
                Tiles(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: ((context) => const OrderingSystem()),
                        ),
                      );
                    },
                    mainText: AppLocalizations.of(context)!.orders,
                    subText: '',
                    height: 120,
                    width: 170)
            ],
          ),
          const SizedBox(height: 7),
          // Special admin tile
          if (_accessLevel == 'Admin')
            Tiles(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: ((context) => const AdminPage()),
                  ),
                );
              },
              mainText: AppLocalizations.of(context)!.admin,
              subText: '',
              height: 120,
              width: 400,
            ),

          const SizedBox(height: 80),
          Center(
            child: TextButton(
              onPressed: () {
                signUserOut();
              },
              child: Text(
                AppLocalizations.of(context)!.sign_out,
                style: const TextStyle(
                  color: Color.fromARGB(180, 0, 0, 0),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getNextAppointment() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .collection('appointments')
          .orderBy('date', descending: false)
          .limit(1) // Limit to only one appointment
          .snapshots();
    } else {
      //returns empty stream
      return const Stream.empty();
    }
  }

  void signUserOut() {
    widget.updateIsUserRegistered(false);
  }
}
