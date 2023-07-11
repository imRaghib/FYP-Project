import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/request_payments.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ViewModel/signout.dart';
import 'package:intl/intl.dart';

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({Key? key}) : super(key: key);

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "en_US");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: VendorDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.20,
                child: Row(
                  children: [
                    buildOnHoldPayments(
                        numberFormat: numberFormat,
                        paymentStatus: 'readyPayments',
                        title: 'Total Payments'),
                    const SizedBox(
                      width: 12,
                    ),
                    buildOnHoldPayments(
                        numberFormat: numberFormat,
                        paymentStatus: 'onHoldPayments',
                        title: 'Pending Payments'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const RequestPayments()));
                          },
                          child: const Text("Request Payments")),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: usersStream,
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong');
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           valueColor: AlwaysStoppedAnimation<Color>(
      //               Theme.of(context).primaryColor),
      //         ),
      //       );
      //     }
      //
      //     return SizedBox(
      //       height: size.height * 0.39,
      //       child: ListView.separated(
      //         separatorBuilder: (context, index) => const SizedBox(
      //           width: 10,
      //         ),
      //         // physics: ClampingScrollPhysics(),
      //         // shrinkWrap: true,
      //         scrollDirection: Axis.horizontal,
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           onHoldPayment += snapshot.data?.docs[index]['payment'];
      //           // return Container(
      //           //   width: 200,
      //           //   color: Colors.red,
      //           // );
      //           return Text("Payments on Hold $onHoldPayment");
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text("Total Earnings"),
      //             ],
      //           );
      //
      //           // return ItemCard(
      //           //   context: context,
      //           //   image: data!['venueImages'][0],
      //           //   title: data['venueName'],
      //           //   price: data['venuePrice'],
      //           //   totalRating: data['venueRating'],
      //           //   totalFeedbacks: data['venueFeedback'],
      //           //   press: () {
      //           //     Navigator.push(
      //           //       context,
      //           //       MaterialPageRoute(
      //           //         builder: (context) => DetailsScreen(
      //           //           imageUrlList: data['venueImages'],
      //           //           title: data['venueName'],
      //           //           address: data['venueAddress'],
      //           //           description: data['venueDescription'],
      //           //           price: data['venuePrice'],
      //           //           isFav: false,
      //           //           contact: data['vendorNumber'],
      //           //           inactiveDates: data['inActiveDates'],
      //           //           vendorUID: data['vendorUID'],
      //           //           venueId: data['venueId'],
      //           //         ),
      //           //       ),
      //           //     );
      //           //   },
      //           // );
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Expanded buildOnHoldPayments({
    required NumberFormat numberFormat,
    required String paymentStatus,
    required String title,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: kPurple.withAlpha(90),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Vendors')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }

                  final vendorData = snapshot.data!.data();
                  final payments = vendorData?[paymentStatus] as int?;

                  return Text(
                    'Rs.${numberFormat.format(payments)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> onHoldPayments({required String paymentStatus}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Vendor Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Venue Orders')
        .where("paymentStatus", isEqualTo: paymentStatus)
        .get();

    int totalPayment = 0;

    for (var doc in querySnapshot.docs) {
      final payment = doc.data()['payment'] as int?;
      if (payment != null) {
        totalPayment += payment;
      }
    }

    return totalPayment;
  }
}
