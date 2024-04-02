import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/Tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/labtests.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/radiologyscans.dart';
import 'package:africa_med_app/pages/all_dashboard_pages/vieworders.dart';

class OrderingSystem extends StatefulWidget {
  const OrderingSystem({super.key});

  @override
  _OrderingSystemState createState() => _OrderingSystemState();
}

class _OrderingSystemState extends State<OrderingSystem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(156, 102, 134, 161),
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

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
                    width: 400,
                    height: 120,
                  ),
                  const SizedBox(height: 7),
                  
                  
                ],
              ),
            ),
          )
    );
  }
}
