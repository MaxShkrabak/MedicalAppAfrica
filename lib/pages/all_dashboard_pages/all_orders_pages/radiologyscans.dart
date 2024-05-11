// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RadiologyScans extends StatefulWidget {
  final DocumentSnapshot document;
  const RadiologyScans({super.key, required this.document});

  @override
  State<RadiologyScans> createState() => _RadiologyScansState();
}

class _RadiologyScansState extends State<RadiologyScans> {
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
        backgroundColor: const Color.fromARGB(
            159, 144, 79, 230), //old: const Color.fromARGB(156, 102, 134, 161),
        title: Padding(
          padding: const EdgeInsets.only(left: 83),
          child: Text(
            AppLocalizations.of(context)!.radiology,
            style: const TextStyle(color: Colors.white),
          ),
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
                    _showOrderDetailsDialog(widget.document, 'X-ray', 'Radiology');
                  },
                  mainText: AppLocalizations.of(context)!.x_ray,
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog(widget.document,'CT Scan', 'Radiology');
                  },
                  mainText: AppLocalizations.of(context)!.ct_scan,
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog(widget.document, 'MRI', 'Radiology');
                  },
                  mainText: AppLocalizations.of(context)!.mri,
                  subText: '',
                  width: 250,
                  height: 100,
                ),
                const SizedBox(height: 7),
                Tiles(
                  onTap: () {
                    _showOrderDetailsDialog(widget.document, 'Other', 'Radiology');
                  },
                  mainText: AppLocalizations.of(context)!.other,
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
      String areatoScan, String orderDetails, int? selectedInt) async {
    try {
      //Adds the order to users 'orders' sub collection
      final appointmentRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'order details': orderDetails,
        'testing': areatoScan,
        'order type': orderType,
        'patient': patientName,
        'testing department': department,
        'urgency': selectedInt,
        'status': "active",
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Center(child: Text(AppLocalizations.of(context)!.order_success)),
        ),
      );

      print('Order added successfully: ${appointmentRef.id}');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  //asks user for order details
  void _showOrderDetailsDialog(DocumentSnapshot document, String orderType, String department) {
    String patientName = document.get('firstName') + ' ' + document.get('lastName');
    String orderDetails = '';
    String areaToScan = '';
    int? selectedInt;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)!.radiology_details),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                const SizedBox(height: 7),
                TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.area_of_interest,
                      border: const OutlineInputBorder()),
                  onChanged: (value) {
                    areaToScan = value;
                  },
                ),
                const SizedBox(height: 7),
                TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.order_details,
                      border: const OutlineInputBorder()),
                  onChanged: (value) {
                    orderDetails = value;
                  },
                ),
                const SizedBox(height: 7),
                DropdownMenu(
                    hintText: AppLocalizations.of(context)!.urgency,
                    width: 130,
                    onSelected: (int? num) {
                      setState(() {
                        selectedInt = num;
                      });
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: 3,
                          label: AppLocalizations.of(context)!.urgency_type1),
                      DropdownMenuEntry(
                          value: 2,
                          label: AppLocalizations.of(context)!.urgency_type2),
                      DropdownMenuEntry(
                          value: 1,
                          label: AppLocalizations.of(context)!.urgency_type3),
                    ]),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel_button),
              ),
              TextButton(
                onPressed: () {
                  _SendOrder(patientName, department, orderType, areaToScan,
                      orderDetails, selectedInt);
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.confirm_button),
              ),
            ],
          ),
        );
      },
    );
  }
  
}
