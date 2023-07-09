import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/genRandomString.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VenueProvider {
  String venueId = getRandomString();

  void addVenueData({
    required List venueImages,
    required String venueLocation,
    required String venueName,
    required int venuePrice,
    required String venueDescription,
    required String venueAddress,
    required double venueCapacity,
    required double venueParking,
    required int venueRating,
    required int venueFeedback,
    required String vendorNumber,
    required List inActiveDates,
    required Map<String, int> menus,
  }) async {
    await FirebaseFirestore.instance.collection("Venues").doc(venueId).set({
      "venueId": venueId,
      "venueImages": venueImages,
      "venueLocation": venueLocation,
      "venueName": venueName,
      "venuePrice": venuePrice,
      "venueDescription": venueDescription,
      "venueAddress": venueAddress,
      "venueCapacity": venueCapacity,
      "venueParking": venueParking,
      "vendorUID": FirebaseAuth.instance.currentUser!.uid,
      "venueRating": venueRating,
      "venueFeedback": venueFeedback,
      "vendorNumber": vendorNumber,
      "inActiveDates": inActiveDates,
      "menus": menus,
      "isPrivate": false,
      "vendorEmail": FirebaseAuth.instance.currentUser!.email
    });
  }

  void addJeweleryData({
    required List productImages,
    required String productLocation,
    required String productName,
    required int productPrice,
    required String productDescription,
    required int productRating,
    required int productFeedback,
    required String productNumber,
    required int productQuantity,
    required String productSize,
    required String productCarrots,
    required int productDelivery
  }) async {
    await FirebaseFirestore.instance.collection("Jewelerys").doc().set({
      "productId": Random().nextInt(100000).toString(),
      "productImages": productImages,
      "productAddress": productLocation,
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "sellerUID": FirebaseAuth.instance.currentUser!.uid,
      "productRating": productRating,
      "productFeedback": productFeedback,
      "sellerNumber": productNumber,
      "isPrivate": false,
      "sellerEmail": FirebaseAuth.instance.currentUser!.email,
      "availableQuantity":productQuantity,
      "productSize":productSize,
      "productCarrots":productCarrots,
      "productDelivery":productDelivery

    });
  }

  void addDressData({
    required List productImages,
    required String productLocation,
    required String productName,
    required int productPrice,
    required String productDescription,
    required int productRating,
    required int productFeedback,
    required String productNumber,
    required int productQuantity,
    required String productSize,
    required int productDelivery
  }) async {
    await FirebaseFirestore.instance.collection("Dresses").doc().set({
      "productId": Random().nextInt(100000).toString(),
      "productImages": productImages,
      "productAddress": productLocation,
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "sellerUID": FirebaseAuth.instance.currentUser!.uid,
      "productRating": productRating,
      "productFeedback": productFeedback,
      "sellerNumber": productNumber,
      "isPrivate": false,
      "sellerEmail": FirebaseAuth.instance.currentUser!.email,
      "availableQuantity":productQuantity,
      "productSize":productSize,
      "productDelivery":productDelivery

    });
  }

}



String? vendorName;
getVendorName() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      vendorName = snapshot.get('Name').toString();
    }
  } catch (e) {
    print('Error: $e');
  }
}

updateBookingStatus({
  required String orderId,
  required bool updatedStatus,
}) async {
  // Get a reference to the document you want to update

  FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'orderStatus': updatedStatus,
  }).then((value) {
    print('Order status updated successfully');
  }).catchError((error) {
    print('Failed to update order status: $error');
  });
}

void payVendor({
  required int payment,
}) {
  FirebaseFirestore.instance
      .collection('Vendors')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'readyPayments': FieldValue.increment(payment),
  }).then((_) {
    debugPrint('Value added successfully!');
  }).catchError((error) {
    debugPrint('Error adding value: $error');
  });
}

const updatedStatus = "approved";
void releaseVendorPayments({
  required int payment,
  required String orderId,
}) {
  FirebaseFirestore.instance
      .collection('Vendors')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'readyPayments': FieldValue.increment(payment),
    'onHoldPayments': FieldValue.increment(-payment),
  }).then((_) {
    debugPrint('Value added successfully!');
  }).catchError((error) {
    debugPrint('Error adding value: $error');
  });

  FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'paymentStatus': updatedStatus,
  }).then((value) {
    print('Order status updated successfully');
  }).catchError((error) {
    print('Failed to update order status: $error');
  });
}
