import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/Model/Messenger%20Models/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ViewModel/Vendor/venue_provider.dart';

class RequestPayments extends StatefulWidget {
  const RequestPayments({Key? key}) : super(key: key);

  @override
  State<RequestPayments> createState() => _RequestPaymentsState();
}

class _RequestPaymentsState extends State<RequestPayments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Request Payments"),
          ),
          body: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(
                    text: "Venue",
                  ),
                  Tab(
                    text: "Salon",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Vendor Orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Venue Orders')
                          .where('paymentStatus',
                              whereIn: ['onHold', 'onHoldByAdmin']).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        // print(snapshot.data!.docs.length);

                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            // physics: ClampingScrollPhysics(),
                            // shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final venueOrderData = snapshot.data!.docs[index];
                              final onHoldPayments = venueOrderData['payment'];
                              final orderId = venueOrderData['orderId'];

                              final venueBookedOn = DateFormat('dd/MM/yy')
                                  .parse(venueOrderData['venueBookedOn']);

                              // bool hasTwoWeeksPassed = DateFormat('dd/MM/yy')
                              //         .parse('8/08/23')
                              //         .difference(venueBookedOn)
                              //         .inDays >
                              //     14;

                              bool hasTwoWeeksPassed = DateTime.now()
                                      .difference(venueBookedOn)
                                      .inDays >
                                  14;
                              final paymentStatus =
                                  venueOrderData['paymentStatus'];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListTile(
                                    title: Text(
                                        "Order Id: ${venueOrderData['orderId']}"),
                                    subtitle: const Text(
                                        'Payment will be released after 2 Weeks.'),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        if (paymentStatus != 'onHoldByAdmin') {
                                          if (hasTwoWeeksPassed) {
                                            releaseVendorPayments(
                                                payment: onHoldPayments,
                                                orderId: orderId);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'StreamPage',
                                                (route) => false);
                                          } else {
                                            Dialogs.showSnackbar(context,
                                                'Your payment will be released after 2 weeks!');
                                          }
                                        } else {
                                          Dialogs.showSnackbar(context,
                                              'Your Payment is on hold by Admin!');
                                        }
                                      },
                                      child: const Text("Request Payment"),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Vendor Orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Salon Orders')
                          .where('paymentStatus',
                              whereIn: ['onHold', 'onHoldByAdmin']).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        // print(snapshot.data!.docs.length);

                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 10,
                                ),
                            // physics: ClampingScrollPhysics(),
                            // shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final venueOrderData = snapshot.data!.docs[index];
                              final onHoldPayments = venueOrderData['payment'];
                              final orderId = venueOrderData['orderId'];

                              final venueBookedOn = DateFormat('dd/MM/yy')
                                  .parse(venueOrderData['salonBookedOn']);

                              // bool hasTwoWeeksPassed = DateFormat('dd/MM/yy')
                              //         .parse('8/08/23')
                              //         .difference(venueBookedOn)
                              //         .inDays >
                              //     14;

                              bool hasTwoWeeksPassed = DateTime.now()
                                      .difference(venueBookedOn)
                                      .inDays >
                                  14;
                              final paymentStatus =
                                  venueOrderData['paymentStatus'];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListTile(
                                    title: Text(
                                        "Order Id: ${venueOrderData['orderId']}"),
                                    subtitle: const Text(
                                        'Payment will be released after 2 Weeks.'),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        if (paymentStatus != 'onHoldByAdmin') {
                                          if (hasTwoWeeksPassed) {
                                            releaseVendorPayments(
                                                payment: onHoldPayments,
                                                orderId: orderId);
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'StreamPage',
                                                (route) => false);
                                          } else {
                                            Dialogs.showSnackbar(context,
                                                'Your payment will be released after 2 weeks!');
                                          }
                                        } else {
                                          Dialogs.showSnackbar(context,
                                              'Your Payment is on hold by Admin!');
                                        }
                                      },
                                      child: const Text("Request Payment"),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ]),
              ),
            ],
          )),
    );
  }
}
