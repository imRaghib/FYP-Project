import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../genRandomString.dart';

String orderId = getRandomString();
String paymentStatus = 'onHold';
bool orderStatus = false;
bool appointmentCompleted = false;
void bookSalon({
  required int payment,
  required String salonId,
  required String vendorUID,
  required String salonBookedOn,
  required String customerName,
  required String customerEmail,
  required Map<String, int> selectedPackage,
  required String salonName,
  required String salonImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Vendor Orders")
      .doc(vendorUID)
      .collection("Salon Orders")
      .doc(orderId)
      .set({
    "orderId": orderId,
    "bookingDate": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    "salonBookedOn": salonBookedOn,
    "payment": payment,
    "salonId": salonId,
    "customerUID": customerUID,
    "paymentStatus": paymentStatus,
    "orderStatus": orderStatus,
    "customerName": customerName,
    "customerEmail": customerEmail,
    "selectedPackage": selectedPackage,
    "salonName": salonName,
    "salonImg": salonImg,
    "appointmentCompleted": appointmentCompleted,
  });
}

updateSalonDate({
  required String salonId,
  required String bookingDate,
}) async {
  // Get a reference to the document you want to update
  DocumentReference documentRef =
      FirebaseFirestore.instance.collection('Bridal Salon').doc(salonId);

  // Update the field
  await documentRef.update({
    'inActiveDates': FieldValue.arrayUnion([bookingDate])
  });

  debugPrint('Document updated successfully!');
}

void appointmentHistory({
  required int payment,
  required String salonId,
  required String vendorUID,
  required String salonBookedOn,
  required String vendorNumber,
  required String vendorEmail,
  required Map<String, int> selectedPackage,
  required String salonName,
  required String salonImg,
}) async {
  String customerUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("User Orders")
      .doc(customerUID)
      .collection("Salon Appointments")
      .doc(orderId)
      .set({
    "orderId": orderId,
    "bookingDate": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    "salonBookedOn": salonBookedOn,
    "payment": payment,
    "salonId": salonId,
    "vendorUID": vendorUID,
    "orderStatus": orderStatus,
    "vendorNumber": vendorNumber,
    "vendorEmail": vendorEmail,
    "selectedPackage": selectedPackage,
    "salonName": salonName,
    "salonImg": salonImg,
  });
}
