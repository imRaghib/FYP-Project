import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/booking_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VendorVenueBookingPage extends StatefulWidget {
  const VendorVenueBookingPage({Key? key}) : super(key: key);

  @override
  State<VendorVenueBookingPage> createState() => _VendorVenueBookingPageState();
}

class _VendorVenueBookingPageState extends State<VendorVenueBookingPage> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        centerTitle: true,
      ),
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
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var venueOrderData = snapshot.data?.docs[index];

              String venueId = venueOrderData!['venueId'];
              String customerName = venueOrderData['customerName'];
              String bookingDate = venueOrderData['venueBookOn'];
              String customerEmail = venueOrderData['customerEmail'];

              return venueOrderData == null
                  ? Container(
                      child: Center(
                        child: Text(""),
                      ),
                    )
                  : Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             BookingDetailPage(
                          //               menuMap: venueOrderData['selectedMenu'],
                          //               customerName: customerName,
                          //               bookingDate: bookingDate,
                          //               customerEmail: customerEmail,
                          //             )));
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
                        title: Text("Venue: ${venueOrderData['venueName']}"),
                        subtitle: Text(
                            '$customerName has booked this venue.\nDate: ${bookingDate}'),
                        trailing: const Icon(Icons.touch_app),
                      ),
                    );

              // return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //   stream: FirebaseFirestore.instance
              //       .collection('Venues')
              //       .doc(venueId)
              //       .snapshots(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
              //           snapshot) {
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
              //     var venueData = snapshot.data?.data();
              //     return venueData == null
              //         ? Container(
              //             child: Center(
              //               child: Text(""),
              //             ),
              //           )
              //         : Material(
              //             elevation: 2,
              //             borderRadius: BorderRadius.circular(10),
              //             child: ListTile(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (BuildContext context) =>
              //                             BookingDetailPage(
              //                               menuMap: venueData['menus'],
              //                               customerName: customerName,
              //                               bookingDate: bookingDate,
              //                               customerEmail: customerEmail,
              //                             )));
              //               },
              //               tileColor: Colors.white,
              //               leading: AspectRatio(
              //                 aspectRatio: 4 / 3,
              //                 child: ClipRRect(
              //                   borderRadius: const BorderRadius.all(
              //                     Radius.circular(10),
              //                   ),
              //                   child: Image.network(
              //                     venueData['venueImages'][0],
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //               title: Text("Venue: ${venueData['venueName']}"),
              //               subtitle: Text(
              //                   '$customerName has booked this venue.\nDate: ${formatDate(bookingDate ?? " ")}'),
              //               trailing: const Icon(Icons.touch_app),
              //             ),
              //           );
              //   },
              // );
            },
          );
        },
      ),
    );
  }
}
