import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestPayments extends StatefulWidget {
  const RequestPayments({Key? key}) : super(key: key);

  @override
  State<RequestPayments> createState() => _RequestPaymentsState();
}

class _RequestPaymentsState extends State<RequestPayments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Vendor Orders')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Venue Orders')
                .where('paymentStatus', isEqualTo: 'onHold')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              // print(snapshot.data!.docs.length);

              return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                  // physics: ClampingScrollPhysics(),
                  // shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final venueOrderData = snapshot.data!.docs[index];
                    final onHoldPayments = venueOrderData['payment'];

                    return ListTile(
                      onTap: () {},
                      tileColor: Colors.white,
                      title: Text("Order Id: ${venueOrderData['orderId']}"),
                      subtitle:
                          const Text('Payment will be released after 2 Weeks.'),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Request Payment"),
                      ),
                    );
                  });

              // return ListView.separated(
              //   separatorBuilder: (context, index) => const SizedBox(
              //     width: 10,
              //   ),
              //   // physics: ClampingScrollPhysics(),
              //   // shrinkWrap: true,
              //   scrollDirection: Axis.horizontal,
              //   itemCount: snapshot.data!.docs.length,
              //   itemBuilder: (context, index) {
              //     final venueOrderData = snapshot.data?.docs[index];
              //
              //     final onHoldPayments = venueOrderData?['payment'];
              //
              //     return ListTile(
              //       leading: CircleAvatar(child: Text('A')),
              //       title: Text('Name'),
              //       subtitle: Text('Message'),
              //       trailing: Icon(Icons.favorite_rounded),
              //     );
              //
              //     return Text('On Hold Payments: ${onHoldPayments ?? 'N/A'}');
              //   },
              // );
            }));
  }
}
