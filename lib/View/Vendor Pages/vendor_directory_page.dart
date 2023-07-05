import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/wedding_hall_edit_page.dart';
import 'package:easy_shaadi/View/details/details_screen.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class VendorDirectoryPage extends StatefulWidget {
  const VendorDirectoryPage({Key? key}) : super(key: key);

  @override
  State<VendorDirectoryPage> createState() => _VendorDirectoryPageState();
}

class _VendorDirectoryPageState extends State<VendorDirectoryPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Venues')
      .where('vendorUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.1),
      appBar: AppBar(title: Text("Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
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
              var data = snapshot.data?.docs[index];
              return InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 4 / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: Image.network(
                                  data!['venueImages'][0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(data['venueName']),
                            IconButton(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Delete Hall'),
                                      content: const Text(
                                          'Are you sure you want to delete this hall?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteDocument(data['venueId']);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        imageUrlList: data['venueImages'],
                                        location: data['venueLocation'],
                                        title: data['venueName'],
                                        address: data['venueAddress'],
                                        description: data['venueDescription'],
                                        price: data['venuePrice'],
                                        isFav: false,
                                        contact: data['vendorNumber'],
                                        inactiveDates: data['inActiveDates'],
                                        menuMap: data['menus'],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                ),
              );

              // ? SizedBox(
              //     height: size.height * 0.21,
              //     child: Card(
              //       context: context,
              //       image: data['venueImages'][0],
              //       title: data['venueName'],
              //       price: data['venuePrice'],
              //       totalRating: data['venueRating'],
              //       totalFeedbacks: data['venueFeedback'],
              //       press: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => DetailsScreen(
              //               imageUrlList: data['venueImages'],
              //               title: data['venueName'],
              //               address: data['venueAddress'],
              //               description: data['venueDescription'],
              //               price: data['venuePrice'],
              //               isFav: false,
              //               contact: data['vendorNumber'],
              //               inactiveDates: data['inActiveDates'],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   )
              // : Container();
            },
          );
        },
      ),
    );
  }
}
