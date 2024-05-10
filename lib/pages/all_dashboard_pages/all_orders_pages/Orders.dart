// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/labtests.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/radiologyscans.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/vieworders.dart';

class OrderingSystem extends StatefulWidget {
  const OrderingSystem({super.key});
  
  @override
  State<OrderingSystem> createState() => _OrderingSystemState();
}

class _OrderingSystemState extends State<OrderingSystem> {
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

    FutureBuilder<List<int>>(
       future: Future.wait([_getActiveCount(), _getCompleteCount()]),
       builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or any loading indicator
          } else if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
          } else {
            int? active = snapshot.data?[0];
            int? complete = snapshot.data?[1];
                
             return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            160, 165, 96, 255), //old: const Color.fromARGB(156, 102, 134, 161),
        title: const Text('Orders'),
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
          child: Column(
            children: [
              const SizedBox(height: 12),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) => const RadiologyScans()),
                    ),
                  );
                },
                mainText: 'Radiology',
                subText: '',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 7),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) => const LabTests()),
                    ),
                  );
                },
                mainText: 'Laboratory',
                subText: '',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 7),
              Tiles(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) => const ViewOrders()),
                    ),
                  );
                },
                mainText: 'View Orders',
                subText: active.toString() + " Active \n" + complete.toString() + ' Complete',
                width: 400,
                height: 120,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
                  }}
        );
  }}
  Future<int> _getActiveCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: "active").get();
    return querySnapshot.size;
  }
  Future<int> _getCompleteCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: "complete").get();
    return querySnapshot.size;
  }
