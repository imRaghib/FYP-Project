import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../genRandomString.dart';

class SalonProvider {
  String salonId = getRandomString();

  void addSalonData({
    required List salonImages,
    required String salonLocation,
    required String salonName,
    required String salonDescription,
    required String salonAddress,
    required int salonRating,
    required int salonFeedback,
    required String vendorNumber,
    required List inActiveDates,
    required int startingPrice,
    required Map<String, int> packages,
    required String category,
  }) async {
    await FirebaseFirestore.instance
        .collection("Bridal Salon")
        .doc(salonId)
        .set({
      "salonId": salonId,
      "salonImages": salonImages,
      "salonLocation": salonLocation,
      "salonName": salonName,
      "salonDescription": salonDescription,
      "salonAddress": salonAddress,
      "vendorUID": FirebaseAuth.instance.currentUser!.uid,
      "salonRating": salonRating,
      "salonFeedback": salonFeedback,
      "vendorNumber": vendorNumber,
      "inActiveDates": inActiveDates,
      "startingPrice": startingPrice,
      "salonPackages": packages,
      "category": category,
    });
  }
}
