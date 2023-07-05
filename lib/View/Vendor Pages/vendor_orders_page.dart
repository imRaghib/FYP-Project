import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/Model/bookings.dart';
import 'package:easy_shaadi/View/User%20Pages/item_Card.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/booking_detail_page.dart';
import 'package:easy_shaadi/ViewModel/Vendor/venue_provider.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorOrdersPage extends StatefulWidget {
  const VendorOrdersPage({Key? key}) : super(key: key);

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .snapshots();

  formatDate(String date) {
    return date.substring(0, date.indexOf(' '));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).indicatorColor),
              ),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var venueOrderData = snapshot.data?.docs[index];

              String venueId = venueOrderData!['venueId'];
              String customerName = venueOrderData['customerName'];
              String bookingDate = venueOrderData['bookingDate'];
              String customerEmail = venueOrderData['customerEmail'];

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Venues')
                    .doc(venueId)
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
                  var venueData = snapshot.data?.data();
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BookingDetailPage(
                                    menuMap: venueData['menus'],
                                    customerName: customerName,
                                    bookingDate: bookingDate,
                                    customerEmail: customerEmail,
                                  )));
                    },
                    tileColor: Colors.white,
                    leading: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Image.network(
                          venueData!['venueImages'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text("Venue: ${venueData['venueName']}"),
                    subtitle: Text(
                        '$customerName has booked this venue.\nDate: ${formatDate(bookingDate ?? " ")}'),
                    trailing: const Icon(Icons.touch_app),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
