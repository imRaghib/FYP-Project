import 'package:easy_shaadi/Model/customer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/VendorRequest.dart';
import '../Model/bookings.dart';
import 'Messenger Class/apis.dart';
import 'google_login.dart';

class ProductProvider with ChangeNotifier {
  List<Booking> hallsList = [];
  late Booking halls;
  List<Requests> requestList = [];
  late Requests request;

  Future fetchHallsData() async {
    var document = await FirebaseFirestore.instance.collection("Venues").get();

    for (var element in document.docs) {
      halls = Booking(
        venueId: element.get('venueId'),
        venueImages: List.from(element.get('venueImages')),
        venueLocation: element.get('venueLocation'),
        venueName: element.get('venueName'),
        venuePrice: element.get('venuePrice'),
        venueDescription: element.get('venueDescription'),
        venueAddress: element.get('venueAddress'),
        venueCapacity: element.get('venueCapacity'),
        venueParking: element.get('venueParking'),
        vendorUID: element.get('vendorUID'),
        venueRating: element.get('venueRating'),
        venueFeedback: element.get('venueFeedback'),
        vendorNumber: element.get('vendorNumber'),
        inActiveDates: List.from(element.get('inActiveDates')),
        menus: Map.from(element.get('menus')),
      );
      hallsList.add(halls);
    }
    notifyListeners();
  }

  getUserEmail() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  Future fetchRequests() async {
    var document =
        await FirebaseFirestore.instance.collection('Vendor Requests').get();
    for (var element in document.docs) {
      request = Requests(id: element.get('Id'), name: element.get('Name'));
      requestList.add(request);
      // print(requestList.length);
    }
    notifyListeners();
  }

  Future signOut() async {
    APIs.updateActiveStatus(false);
    if (await googleSignin.isSignedIn()) {
      await googleSignin.disconnect();
    }

    await FirebaseAuth.instance.signOut();
  }

  late Customer customer;
  Future getCustomerDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      customer = Customer(
        Name: snapshot.get('Name').toString(),
        Email: snapshot.get('Email').toString(),
      );
    }

    notifyListeners();
  }
}
Future signout() async {
  APIs.updateActiveStatus(false);
  if (await googleSignin.isSignedIn()) {
    await googleSignin.disconnect();
  }

  await FirebaseAuth.instance.signOut();
}
deleteDocument(String venueId) async {
  var document = await FirebaseFirestore.instance;
  document.collection("Venues").doc(venueId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}
