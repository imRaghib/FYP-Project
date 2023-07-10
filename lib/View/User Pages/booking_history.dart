import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/booking_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  final Stream<QuerySnapshot> pendingBookings = FirebaseFirestore.instance
      .collection('User Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .where('orderStatus', isEqualTo: false)
      .snapshots();

  final Stream<QuerySnapshot> completedBookings = FirebaseFirestore.instance
      .collection('User Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .where('orderStatus', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking History'),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Completed",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildBookingHistory(streams: pendingBookings),
                  buildBookingHistory(streams: completedBookings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildBookingHistory(
      {required streams}) {
    return StreamBuilder<QuerySnapshot>(
      stream: streams,
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
                  //
                  // String vendorEmail =
                  //     venueOrderData!['vendorEmail'];
                  String bookingDate = venueOrderData!['venueBookedOn'];

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
                                  builder: (BuildContext context) =>
                                      UserBookingDetailPage(
                                        bookingData: venueOrderData,
                                        email: venueOrderData['vendorEmail'],
                                        vendorId: venueOrderData['vendorUID'],
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
                        title: Text("Venue: ${venueOrderData['venueName']}"),
                        subtitle:
                            Text('This venue this booked on $bookingDate'),
                        trailing: const Icon(Icons.touch_app),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
