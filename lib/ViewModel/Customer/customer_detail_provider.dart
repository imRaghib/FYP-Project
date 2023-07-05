import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

getCustomerDetails() async {
  var customerUID = FirebaseAuth.instance.currentUser!.uid;

  var docSnapshot = await FirebaseFirestore.instance
      .collection('Customers')
      .doc(customerUID)
      .get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    String name = data?['Name'];
    return name;
  }
}
