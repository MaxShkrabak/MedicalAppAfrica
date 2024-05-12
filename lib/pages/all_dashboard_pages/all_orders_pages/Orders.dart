// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/patientQuery.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/all_orders_pages/vieworders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                return const CircularProgressIndicator(); // or any loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                int? active = snapshot.data?[0];
                int? complete = snapshot.data?[1];

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(159, 144, 79, 230),
                    iconTheme: const IconThemeData(
                        color: Colors.white), // back arrow color
                    title: Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text(
                        AppLocalizations.of(context)!.orders,
                        style:
                            const TextStyle(color: Colors.white), // title color
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(246, 244, 236,
                      255), //old: const Color.fromARGB(156, 102, 133, 161),
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
                                  builder: ((context) =>
                                      const DocumentListScreen(
                                        collectionName: 'patients',
                                      )),
                                ),
                              );
                            },
                            mainText: AppLocalizations.of(context)!.new_order,
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
                            mainText: AppLocalizations.of(context)!.view_orders,
                            subText: AppLocalizations.of(context)!
                                .active_complete(
                                    active.toString(), complete.toString()),
                            width: 400,
                            height: 120,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            });
  }
}

Future<int> _getActiveCount() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('status', isEqualTo: "active")
      .get();
  return querySnapshot.size;
}

Future<int> _getCompleteCount() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('status', isEqualTo: "complete")
      .get();
  return querySnapshot.size;
}
