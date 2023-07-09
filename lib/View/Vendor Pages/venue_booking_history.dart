import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/venue_booking_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VenueBookingHistory extends StatefulWidget {
  const VenueBookingHistory({Key? key}) : super(key: key);

  @override
  State<VenueBookingHistory> createState() => _VenueBookingHistoryState();
}

class _VenueBookingHistoryState extends State<VenueBookingHistory> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .where('orderStatus', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Orders History"),
      ),
      drawer: const VendorDrawer(),
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

          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text(
                    "No Bookings History",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var venueOrderData = snapshot.data?.docs[index];

                    String customerName = venueOrderData!['customerName'];
                    String bookingDate = venueOrderData['venueBookedOn'];

                    return venueOrderData == null
                        ? const Center(
                            child: Text("No Bookings"),
                          )
                        : Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BookingDetailPage(
                                              bookingData: venueOrderData,
                                              email: venueOrderData[
                                                  'customerEmail'],
                                              customerId:
                                                  venueOrderData['customerUID'],
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
                                    venueOrderData['venueImg'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title:
                                  Text("Venue: ${venueOrderData['venueName']}"),
                              subtitle: Text(
                                  '$customerName has booked this Venue on date: $bookingDate'),
                              trailing: const Icon(Icons.touch_app),
                            ),
                          );
                  },
                );
        },
      ),
    );
  }
}