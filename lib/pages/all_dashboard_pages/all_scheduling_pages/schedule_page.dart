// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
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
    _selectedDay = DateTime.now().toLocal();
    _focusedDay = DateTime.now().toLocal();
    _selectedDate = DateTime.now().toLocal();
    _timeSlotAvailabilityMap = {};
    _appointmentsMap = {};
    _availableTimeSlots = _generateAvailableTimeSlots(_focusedDay);
    _updateTimeSlotAvailability();
  }

  bool isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            160, 165, 96, 255), //old: const Color.fromARGB(161, 88, 82, 173),
        title: const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Text(
            'Schedule',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(76, 90, 137, 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              rowHeight: 50,
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle:
                    TextStyle(color: Colors.white.withOpacity(0.3)),
                selectedTextStyle: const TextStyle(
                    color: Colors.white), // Set selected text color to white
                withinRangeTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: const BoxDecoration(
                    color: Color.fromARGB(255, 152, 96, 204),
                    shape: BoxShape.circle),
                rangeStartTextStyle: const TextStyle(color: Colors.grey),
                outsideDaysVisible: false,
                selectedDecoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 77, 126, 218), // selected day background
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 30,
                  )),
              locale: 'en_US',
              firstDay: DateTime(2020, 10, 16),
              lastDay: DateTime(2040, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onPageChanged: _onPageChanged,
              onDaySelected: _onDaySelected,
              // disables weekends
              enabledDayPredicate: (day) {
                return !isWeekend(day) &&
                    (day.isAfter(
                            DateTime.now().subtract(const Duration(days: 1))) ||
                        isSameDay(day, DateTime.now()));
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: const TextStyle(
                  color: Colors.white, // color of weekday names
                ),
                weekendStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                //The date that is currently selected
                child: Center(
                  child: Text(
                    DateFormat('MMMM d, y').format(_selectedDay),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 10),
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
                  final color = isAvailable
                      ? const Color.fromARGB(158, 76, 175, 79)
                      : const Color.fromARGB(144, 244, 67, 54);
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

    // checks if there are appointments for the selected day and time slots
    final appointmentsForSelectedDay = _appointmentsMap[selectedDay];
    if (appointmentsForSelectedDay != null) {
      for (var appointmentTimeSlot in appointmentsForSelectedDay) {
        //marks the time slot as unavailable if an appointment exists for it
        if (timeSlots.contains(appointmentTimeSlot)) {
          _timeSlotAvailabilityMap[selectedDay]![appointmentTimeSlot] = false;
        }
      }
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
        .where('selectedAvailability', isEqualTo: _selectedDate)
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
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Meeting Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Meeting Details'),
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
          ),
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
      ).toLocal();

      //Adds the appointment to users 'appointments' sub collection
      final appointmentRef = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('appointments')
          .add({
        'selectedAvailability': _selectedDate,
        'date': appointmentDateTime,
        'timeSlot': timeSlot,
        'meetingDetails': meetingDetails,
      });

      // Updates availability status to false
      setState(() {
        _timeSlotAvailabilityMap[_selectedDay]![timeSlot] = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Appointment scheduled successfully!')),
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
