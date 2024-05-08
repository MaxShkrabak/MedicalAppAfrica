import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';

class LabTests extends StatefulWidget {
  const LabTests({super.key});

  @override
  State<LabTests> createState() => _LabTestsState();
}

class _LabTestsState extends State<LabTests> {
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
        backgroundColor: const Color.fromARGB(159, 144, 79, 230),
        title: const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Text('Laboratory', style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(
          246, 244, 236, 255), //old: const Color.fromARGB(156, 102, 133, 161),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog('Blood Test', "Laboratory");
                  },
                  mainText: 'Blood Tests',
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog('Urine Sample', "Laboratory");
                  },
                  mainText: 'Urine Sample',
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog('Stool Sample', 'Laboratory');
                  },
                  mainText: 'Stool Sample',
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog('Other', 'Laboratory');
                  },
                  mainText: 'Other',
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
    //),
    //);
  }

  // ignore: non_constant_identifier_names
  void _SendOrder(String patientName, String department, String orderType,
      String testType, String orderDetails, int? selectedInt) async {
    try {
      //Adds the order to users 'orders' sub collection
      final appointmentRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'order details': orderDetails,
        'testing': testType,
        'order type': orderType,
        'testing department': department,
        'patient': patientName,
        'status': "active",
        'urgency': selectedInt,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Order added successfully!')),
        ),
      );

      // ignore: avoid_print
      print('Order added successfully: ${appointmentRef.id}');
    } catch (e) {
      // ignore: avoid_print
      print('Error adding order: $e');
    }
  }

  //asks user for order details
  void _showOrderDetailsDialog(String orderType, String department) {
    String patientName = '';
    String orderDetails = '';
    String testingField = '';
    int? selectedInt;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Laboratory Order Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      labelText: 'Patient Name', border: OutlineInputBorder()),
                  onChanged: (value) {
                    patientName = value;
                  },
                ),
                const SizedBox(height: 7),
                TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      labelText: 'Testing Field', border: OutlineInputBorder()),
                  onChanged: (value) {
                    testingField = value;
                  },
                ),
                const SizedBox(height: 7),
                TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      labelText: 'Order Details', border: OutlineInputBorder()),
                  onChanged: (value) {
                    orderDetails = value;
                  },
                ),
                const SizedBox(height: 7),
                DropdownMenu(
                    hintText: 'Urgency',
                    width: 130,
                    onSelected: (int? num) {
                      setState(() {
                        selectedInt = num;
                      });
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 3, label: 'Minor'),
                      DropdownMenuEntry(value: 2, label: 'Average'),
                      DropdownMenuEntry(value: 1, label: 'Urgent'),
                    ]),
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
                  _SendOrder(patientName, department, orderType, testingField,
                      orderDetails, selectedInt);
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
}
