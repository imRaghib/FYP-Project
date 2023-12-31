import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/edit_dresses_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/edit_jewellery_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/edit_salon_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/edit_venue_page.dart';
import 'package:easy_shaadi/ViewModel/Vendor/dresses_provider.dart';
import 'package:easy_shaadi/ViewModel/Vendor/venue_provider.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../ViewModel/Vendor/jewellwery_provider.dart';

class VendorDirectoryPage extends StatefulWidget {
  const VendorDirectoryPage({Key? key}) : super(key: key);

  @override
  State<VendorDirectoryPage> createState() => _VendorDirectoryPageState();
}

class _VendorDirectoryPageState extends State<VendorDirectoryPage> {
  final Stream<QuerySnapshot> venueStream = FirebaseFirestore.instance
      .collection('Venues')
      .where('vendorUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> salonStream = FirebaseFirestore.instance
      .collection('Bridal Salon')
      .where('vendorUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> dressesStream = FirebaseFirestore.instance
      .collection('Dresses')
      .where('sellerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  final Stream<QuerySnapshot> jewelleryStream = FirebaseFirestore.instance
      .collection('Jewelerys')
      .where('sellerUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Listings'),
        ),
        drawer: const VendorDrawer(),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.menu_book,
                    color: kPink,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.brush,
                    color: kPink,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.girl_outlined,
                    color: kPink,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: kPink,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildVenueTab(),
                  buildSalonTab(),
                  buildDressesTab(),
                  buildJewelleryTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildVenueTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: venueStream,
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
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data['venueImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['venueName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['venueFeedback'] == 0
                                        ? 0
                                        : (data['venueRating'] /
                                                (5 * data['venueFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
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
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteVenue(data['venueId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditVenuePage(venueData: data),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildSalonTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: salonStream,
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
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data!['salonImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['salonName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['salonFeedback'] == 0
                                        ? 0
                                        : (data['salonRating'] /
                                                (5 * data['salonFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Salon'),
                                        content: const Text(
                                            'Are you sure you want to delete this salon?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteSalon(data['salonId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditSalonPage(salonData: data),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildDressesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: dressesStream,
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
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data['productImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['productName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['productFeedback'] == 0
                                        ? 0
                                        : (data['productRating'] /
                                                (5 * data['productFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Prodcut'),
                                        content: const Text(
                                            'Are you sure you want to delete this Product?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteDresses(data['productId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DressesEditPage(dressData: data)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildJewelleryTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: jewelleryStream,
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
                child: Text("Nothing to show here!"),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color:
                          data!['isPrivate'] ? Colors.redAccent : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              data!['productImages'][0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['productName']),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    initialRating: data['productFeedback'] == 0
                                        ? 0
                                        : (data['productRating'] /
                                                (5 * data['productFeedback'])) *
                                            5,
                                    unratedColor: Colors.grey,
                                    maxRating: 5,
                                    allowHalfRating: true,
                                    onRatingUpdate: (value) {},
                                  ),
                                ],
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Product'),
                                        content: const Text(
                                            'Are you sure you want to delete this product?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteJewelery(data['productId']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              JewelleryEditPage(
                                                  jewelleryData: data)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
