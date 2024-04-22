import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String patientName;
  final String department;
  final String orderType;
  final String testing;
  final String testInfo;

  Order(
      {required this.patientName,
      required this.department,
      required this.orderType,
      required this.testing,
      required this.testInfo});
}
class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
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
             title: const Text('View Orders'),
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
            child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('accounts')
                .doc(user!.uid)
                .collection('orders')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  testInfo: data['order details']?? '',
                );
              }).toList();

              orders.sort((a, b) => a.department.compareTo(b.department));

              return ListView.builder(
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
                                order.patientName,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 143, 226,
                                      247),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    order.department,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 143, 226, 247),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  
                                  Text(
                                    order.testing,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 143, 226,
                                            2),
                                        fontWeight: FontWeight.w600),
                                  ),

                                  Text(
                                    order.testInfo,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 143, 226,
                                            2),
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
                                color: Color.fromARGB(255, 189, 68,
                                    68), 
                              ),
                              onPressed: () {
                                _showCancelConfirmationDialog(
                                    context, order, user.uid);
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
      ),
    );
  }
  //asks user for verification before canceling appointment
  Future<void> _showCancelConfirmationDialog(
      BuildContext context, Order order, String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this order?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _cancelAppointment(order, userId);
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
      Order order, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(userId)
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
      print('Error cancelling appointment: $error');
    }
  }
}
