import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _selectedDate;
  late List<String> _availableTimeSlots;
  late Map<DateTime, Map<String, bool>> _timeSlotAvailabilityMap;
  late Map<DateTime, List<String>> _appointmentsMap;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedDate = DateTime.now();
    _timeSlotAvailabilityMap = {};
    _appointmentsMap = {};
    _availableTimeSlots = _generateAvailableTimeSlots(_focusedDay);
    _updateTimeSlotAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime(2020, 10, 16),
            lastDay: DateTime(2040, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: _onPageChanged,
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              DateFormat('MMMM d, y').format(_selectedDay),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: _availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = _availableTimeSlots[index];
                final isAvailable = _timeSlotAvailabilityMap[_selectedDay]!
                        .containsKey(timeSlot) &&
                    _timeSlotAvailabilityMap[_selectedDay]![timeSlot]!;
                final color = isAvailable ? Colors.green : Colors.red;
                return GestureDetector(
                  onTap: () {
                    if (isAvailable) {
                      _showMeetingDetailsDialog(timeSlot);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This time slot is already taken'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeSlot,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateAvailableTimeSlots(DateTime selectedDay) {
    final timeSlots = <String>[];
    final formatter = DateFormat.Hm();

    // start and end time
    final startTime = DateTime(
        selectedDay.year, selectedDay.month, selectedDay.day, 9, 0); // 9:00 am
    final endTime = DateTime(
        selectedDay.year, selectedDay.month, selectedDay.day, 17, 0); //4:30 pm

    // time slots in 30 min intervals
    var currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      timeSlots.add(formatter.format(currentTime));
      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return timeSlots;
  }

  void _updateTimeSlotAvailability() {
    if (!_timeSlotAvailabilityMap.containsKey(_selectedDay)) {
      _timeSlotAvailabilityMap[_selectedDay] =
          _initializeTimeSlotAvailability();
    }

    //Gets appointments for the selected day
    FirebaseFirestore.instance
        .collection('accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appointments')
        .where('date', isEqualTo: _selectedDate)
        .get()
        .then((QuerySnapshot querySnapshot) {
      _appointmentsMap[_selectedDay] = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (var document in querySnapshot.docs) {
          final appointmentTimeSlot =
              (document.data() as Map<String, dynamic>)['timeSlot'] as String;
          _appointmentsMap[_selectedDay]!.add(appointmentTimeSlot);
        }
      }

      //Makes timeslot unavailable if appointment is already scheduled
      _timeSlotAvailabilityMap[_selectedDay]!.forEach((timeSlot, _) {
        if (_appointmentsMap[_selectedDay]!.contains(timeSlot)) {
          setState(() {
            _timeSlotAvailabilityMap[_selectedDay]![timeSlot] = false;
          });
        }
      });
    });
  }

  //Creates available timeslots
  Map<String, bool> _initializeTimeSlotAvailability() {
    final timeSlotAvailability = <String, bool>{};
    for (var timeSlot in _availableTimeSlots) {
      timeSlotAvailability[timeSlot] = true;
    }
    return timeSlotAvailability;
  }

  //asks user for meeting details
  void _showMeetingDetailsDialog(String timeSlot) {
    String meetingDetails = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meeting Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Meeting Details'),
                onChanged: (value) {
                  meetingDetails = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _scheduleAppointment(timeSlot, meetingDetails);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _scheduleAppointment(String timeSlot, String meetingDetails) async {
    try {
      final appointmentDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(timeSlot.split(':')[0]),
        int.parse(timeSlot.split(':')[1]),
      );

      //Adds the appointment to users 'appointments' sub collection
      final appointmentRef = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('appointments')
          .add({
        'date': _selectedDate,
        'timeSlot': timeSlot,
        'meetingDetails': meetingDetails,
      });

      // Updates availability status to false
      setState(() {
        _timeSlotAvailabilityMap[_selectedDay]![timeSlot] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Appointment scheduled successfully!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              //undo logic will go here, if we do it
            },
          ),
        ),
      );

      print('Appointment created successfully: ${appointmentRef.id}');
    } catch (e) {
      print('Error creating appointment: $e');
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = focusedDay;
      _selectedDate = focusedDay;
      _updateTimeSlotAvailability();
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedDate = selectedDay;
      _updateTimeSlotAvailability();
    });
  }
}
