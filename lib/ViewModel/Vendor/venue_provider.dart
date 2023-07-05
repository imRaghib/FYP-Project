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
    });
  }
}

updateRequestStatus(
  String requestId,
  String updatedStatus,
) async {
  // Get a reference to the document you want to update
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Venue Requests').doc(requestId);

  // Update the field
  await documentRef.update({'requestStatus': updatedStatus});

  print('Document updated successfully!');
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
