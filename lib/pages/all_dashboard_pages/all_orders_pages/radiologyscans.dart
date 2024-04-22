import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:africa_med_app/components/Dashboard_Comps/Tiles.dart';

class RadiologyScans extends StatefulWidget {
  const RadiologyScans({super.key});

  @override
  _RadiologyScansState createState() => _RadiologyScansState();
}

class _RadiologyScansState extends State<RadiologyScans> {
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
             backgroundColor: Color.fromARGB(156, 102, 134, 161),
             title: const Text('Radiology'),
             leading: IconButton(
             icon: const Icon(Icons.arrow_back),
             onPressed: () {
               Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Color.fromARGB(156, 102, 133, 161),
          body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    thickness: 2,
                  ),
                  Tiles(
                    onTap: () {
                      _showOrderDetailsDialog('X-ray', 'Radiology');
                    },
                    mainText: 'X-ray',
                    subText: '',
                    width: 250,
                    height: 100,
                  ),
                  const SizedBox(height: 7),
                  Tiles(
                    onTap: () {
                      _showOrderDetailsDialog('CT Scan', 'Radiology');
                    },
                    mainText: 'CT Scan',
                    subText: '',
                    width: 250,
                    height: 100,
                  ),
                  const SizedBox(height: 7),
                  Tiles(
                    onTap: () {
                      _showOrderDetailsDialog('MRI', 'Radiology');
                    },
                    mainText: 'MRI',
                    subText: '',
                    width: 250,
                    height: 100,
                  ),
                  const SizedBox(height: 7),
                  Tiles(
                    onTap: () {
                      _showOrderDetailsDialog('Other', 'Radiology');
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
      ),
    );
  }
  void _SendOrder(String patientName, String department, String orderType, String areatoScan, String orderDetails) async {
    try {
    
      //Adds the order to users 'orders' sub collection
      final appointmentRef = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .add({
        'order details': orderDetails,
        'testing' : areatoScan,
        'order type' : orderType,
        'patient': patientName,
        'testing department' : department,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Order added successfully!')),
        ),
      );

      print('Order added successfully: ${appointmentRef.id}');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

   //asks user for meeting details
  void _showOrderDetailsDialog(String orderType, String department) {
    String patientName = '';
    String orderDetails = '';
    String areaToScan = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Radiology Order Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Patient Name'),
                  onChanged: (value) {
                    patientName = value;
                  },
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Area of Interest'),
                  onChanged: (value) {
                    areaToScan = value;
                  },
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Order Details'),
                  onChanged: (value) {
                    orderDetails = value;
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
                  _SendOrder(patientName, department, orderType, areaToScan, orderDetails);
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
