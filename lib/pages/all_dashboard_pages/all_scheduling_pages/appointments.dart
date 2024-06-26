import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'schedule_page.dart';
import 'dart:async';
import 'package:africa_med_app/pages/all_dashboard_pages/all_patients_pages/patient_view_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Appointment {
  final DateTime dateTime;
  final String meetingDetails;
  final String timeSlot;
  final String? patientName;
  final String? patientUID;
  final String? patientimageURL;

  Appointment(
      {required this.dateTime,
      required this.meetingDetails,
      required this.timeSlot,
      this.patientName,
      this.patientimageURL,
      this.patientUID});
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 62),
          child: Text(
            AppLocalizations.of(context)!.appointments,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(
            159, 144, 79, 230), //old: const Color.fromARGB(161, 88, 82, 173),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 8.0), //spacing of icon horizontally
            child: Transform.scale(
              scale: 0.75, //size of add app icon
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Schedule(),
                    ),
                  );
                },
                elevation: 8,
                backgroundColor: const Color.fromARGB(255, 200, 178, 250),
                child: const Icon(Icons.add, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: Scaffold(
        backgroundColor: const Color.fromARGB(
            246, 244, 236, 255), //old:const Color.fromRGBO(76, 90, 137, 1),
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
                  patientName: data['patientName'] ?? '',
                  patientimageURL: data['patientimageURL'] ?? '',
                  patientUID: data['patientUID'] ?? '',
                );
              }).toList();

              appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final formattedDate = DateFormat('MMMM d, y - HH:mm')
                      .format(appointment.dateTime.toLocal());

                  //box that appointments are stored in
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 76, 57, 100),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      //appointment stuff
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                appointment.meetingDetails,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 143, 226,
                                      247), //color of meeting details
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 216, 215,
                                            215), //color of date/time
                                        fontWeight: FontWeight.w600),
                                  ),
                                  //for displaying counter for limited amount of appointments
                                  CountdownTimer(
                                    endWidget: Text(
                                      AppLocalizations.of(context)!
                                          .ongoing_meet,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    endTime: appointment
                                        .dateTime.millisecondsSinceEpoch,
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(
                                          255, 136, 216, 140), //color of timer
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: appointment.patientName != ''
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PatientViewPage(
                                                    uid: appointment
                                                        .patientUID!),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: appointment
                                                        .patientimageURL !=
                                                    ''
                                                ? NetworkImage(appointment
                                                    .patientimageURL!)
                                                : const AssetImage(
                                                        'assets/Anonymous_profile.jpg')
                                                    as ImageProvider<Object>,
                                          ),
                                          Text(
                                            appointment.patientName!,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255,
                                                  143,
                                                  226,
                                                  247), //color of meeting details
                                            ),
                                          ),
                                        ],
                                      ))
                                  : null,
                            ),
                          ),
                          //cancel appointment icon
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Color.fromARGB(255, 189, 68,
                                    68), //color of cancel appointment icon
                              ),
                              onPressed: () {
                                _showCancelConfirmationDialog(
                                    context, appointment, user.uid);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  //asks user for verification before canceling appointment
  Future<void> _showCancelConfirmationDialog(
      BuildContext context, Appointment appointment, String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.cancel_app),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.conf_cancel_app),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes_cancel),
              onPressed: () {
                _cancelAppointment(appointment, userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //cancels the appointment, removes data from firebase
  Future<void> _cancelAppointment(
      Appointment appointment, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(userId)
          .collection('appointments')
          .where('date', isEqualTo: appointment.dateTime)
          .where('meetingDetails', isEqualTo: appointment.meetingDetails)
          .where('timeSlot', isEqualTo: appointment.timeSlot)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error cancelling appointment: $error');
    }
  }
}
