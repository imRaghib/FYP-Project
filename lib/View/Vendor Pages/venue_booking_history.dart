import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/salon_appointment_detail_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/venue_booking_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class VenueBookingHistory extends StatefulWidget {
  const VenueBookingHistory({Key? key}) : super(key: key);

  @override
  State<VenueBookingHistory> createState() => _VenueBookingHistoryState();
}

class _VenueBookingHistoryState extends State<VenueBookingHistory> {
  final Stream<QuerySnapshot> bookingStream = FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .where('bookingCompleted', isEqualTo: true)
      .snapshots();

  final Stream<QuerySnapshot> salonStream = FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Salon Orders')
      .where('appointmentCompleted', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders History"),
        ),
        drawer: const VendorDrawer(),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.menu_book,
                    color: kPurple,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.brush,
                    color: kPurple,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: bookingStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 10,
                              ),
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var venueOrderData = snapshot.data?.docs[index];

                                String customerName =
                                    venueOrderData!['customerName'];
                                String bookingDate =
                                    venueOrderData['venueBookedOn'];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        VendorBookingDetailPage(
                                                          bookingData:
                                                              venueOrderData,
                                                          email: venueOrderData[
                                                              'customerEmail'],
                                                          customerId:
                                                              venueOrderData[
                                                                  'customerUID'],
                                                        )));
                                      },
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
                                      title: Text(
                                          "Venue: ${venueOrderData['venueName']}"),
                                      subtitle: Text(
                                          '$customerName has booked this Venue on date: $bookingDate'),
                                      trailing: const Icon(Icons.touch_app),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: salonStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                "No Appointment History",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 10,
                              ),
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var venueOrderData = snapshot.data?.docs[index];

                                String customerName =
                                    venueOrderData!['customerName'];
                                String bookingDate =
                                    venueOrderData['salonBookedOn'];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        VendorSalonDetailPage(
                                                          bookingData:
                                                              venueOrderData,
                                                          email: venueOrderData[
                                                              'customerEmail'],
                                                          customerId:
                                                              venueOrderData[
                                                                  'customerUID'],
                                                        )));
                                      },
                                      leading: AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            venueOrderData['salonImg'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          "Salon: ${venueOrderData['salonName']}"),
                                      subtitle: Text(
                                          '$customerName has booked an appointment on $bookingDate'),
                                      trailing: const Icon(Icons.touch_app),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
