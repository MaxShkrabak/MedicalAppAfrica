import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'schedule_page.dart';

class Appointment {
  final DateTime dateTime;
  final String meetingDetails;
  final String timeSlot;

  Appointment(
      {required this.dateTime,
      required this.meetingDetails,
      required this.timeSlot});
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //gets current user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding:
              EdgeInsets.only(left: 62), //space between back button and title
          child: Text(
            'Appointments',
            style: TextStyle(color: Colors.white), //title color
          ),
        ),
        backgroundColor: const Color.fromARGB(161, 88, 82, 173), //app bar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Color of back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Scaffold(
        backgroundColor:
            const Color.fromRGBO(76, 90, 137, 1), // Background color
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('accounts')
                .doc(user!.uid)
                .collection('appointments')
                .orderBy('date', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final appointments =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Appointment(
                  dateTime: (data['date'] as Timestamp).toDate(),
                  meetingDetails: data['meetingDetails'] ?? '',
                  timeSlot: data['timeSlot'] ?? '',
                );
              }).toList();

              // sorts appointments by date/time, closest app will be at top
              appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  //formater for PST time
                  final formattedDate = DateFormat('MMMM d, y - HH:mm')
                      .format(appointment.dateTime.toLocal());

                  //calculates time dif from curr time and app time
                  final timeDifference =
                      appointment.dateTime.difference(DateTime.now());

                  return ListTile(
                    //displays meeting details
                    title: Text(
                      appointment.meetingDetails,
                      style: const TextStyle(
                          color: Colors.white), //meeting details text color
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$formattedDate, ${appointment.timeSlot}',
                          style: TextStyle(color: Colors.white), //text color
                        ),
                        //top appointment will have countdown timer
                        if (index == 0)
                          CountdownTimer(
                            endTime:
                                appointment.dateTime.millisecondsSinceEpoch,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(
                                  255, 148, 224, 150), // Timer color
                            ),
                          ),
                        //doesn't work but shows total time
                        /*Text(
                          'Time until appointment: ${_formatDuration(timeDifference)}',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                        */
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      //little 'add' icon bottom right
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Schedule()), //takes to schedule page
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  //used it for testing dont know if will be useful
  /*
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:${twoDigitMinutes}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
  */
}
