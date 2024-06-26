import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Order {
  final String patientName;
  final String department;
  final String orderType;
  final String testing;
  final String testInfo;
  final int urgency;

  Order(
      {required this.patientName,
      required this.department,
      required this.orderType,
      required this.testing,
      required this.testInfo,
      required this.urgency});
}

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme:
              const IconThemeData(color: Colors.white), // back arrow color
          backgroundColor: const Color.fromARGB(159, 144, 79, 230),
          title: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(AppLocalizations.of(context)!.view_orders,
                style: const TextStyle(color: Colors.white)),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.active,
              ),
              Tab(
                text: AppLocalizations.of(context)!.completed,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final orders =
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Order(
                    patientName: (data['patient']),
                    department: data['testing department'] ?? '',
                    orderType: data['order type'] ?? '',
                    testing: data['testing'] ?? '',
                    testInfo: data['order details'] ?? '',
                    urgency: data['urgency'] ?? 0,
                  );
                }).toList();

                orders.sort((a, b) => a.urgency.compareTo(b.urgency));

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

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
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .patient_dialogue(order.patientName),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 143, 226, 247),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .department(order.department),
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 143, 226, 247),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .testing(order.testing),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 143, 226, 2),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .test_info(order.testInfo),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 143, 226, 2),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .urgency_grade(
                                              order.urgency.toString()),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 75, 75),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //cancel order
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Color.fromARGB(255, 57, 170, 72),
                                ),
                                onPressed: () {
                                  _showCompleteConfirmationDialog(
                                      context, order);
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status', isEqualTo: 'complete')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final orders =
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Order(
                    patientName: (data['patient']),
                    department: data['testing department'] ?? '',
                    orderType: data['order type'] ?? '',
                    testing: data['testing'] ?? '',
                    testInfo: data['order details'] ?? '',
                    urgency: data['urgency'] ?? 0,
                  );
                }).toList();

                orders.sort((a, b) => a.urgency.compareTo(b.urgency));

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

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
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .patient_dialogue(order.patientName),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 143, 226, 247),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .department(order.department),
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 143, 226, 247),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .testing(order.testing),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 143, 226, 2),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .test_info(order.testInfo),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 143, 226, 2),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .urgency_grade(
                                              order.urgency.toString()),
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 75, 75),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //cancel order
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Color.fromARGB(255, 189, 68, 68),
                                ),
                                onPressed: () {
                                  _showCancelConfirmationDialog(context, order);
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
          ],
        ),
      ),
    );
  }

  //asks user for verification before canceling order
  Future<void> _showCompleteConfirmationDialog(
      BuildContext context, Order order) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.complete_order),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.mark_complete),
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
              child: Text(AppLocalizations.of(context)!.confirm_button),
              onPressed: () {
                updateStatus(order);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStatus(Order order) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('patient', isEqualTo: order.patientName)
          .where('testing department', isEqualTo: order.department)
          .where('testing', isEqualTo: order.testing)
          .where('order type', isEqualTo: order.orderType)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.update({'status': 'complete'});
        }
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error cancelling order: $error');
    }
  }
}

//asks user for verification before canceling order
Future<void> _showCancelConfirmationDialog(
    BuildContext context, Order order) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_order), //delete_order,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppLocalizations.of(context)!.confirm_delete),
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
            child: Text(AppLocalizations.of(context)!.confirm_button),
            onPressed: () {
              _cancelOrder(order);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//cancels the order, removes data from firebase
Future<void> _cancelOrder(Order order) async {
  try {
    await FirebaseFirestore.instance
        .collection('orders')
        .where('patient', isEqualTo: order.patientName)
        .where('testing department', isEqualTo: order.department)
        .where('testing', isEqualTo: order.testing)
        .where('order type', isEqualTo: order.orderType)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  } catch (error) {
    // ignore: avoid_print
    print('Error cancelling order: $error');
  }
}
