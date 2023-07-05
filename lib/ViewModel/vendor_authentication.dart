import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int readyPayments = 0;
int onHoldPayments = 0;

Future vendorSignup({
  required String email,
  required String buisnessName,
  required String password,
  required String name,
  required String cnic,
  required String number,
  required String address,
}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);

  var vendorUID = FirebaseAuth.instance.currentUser!.uid;
  var record = FirebaseFirestore.instance.collection('Vendors').doc(vendorUID);
  await record.set({
    'Name': name,
    'Email': email,
    'BuisnessName': buisnessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor',
    'readyPayments': readyPayments,
    'onHoldPayments': onHoldPayments,
  });
  var record1 =
      FirebaseFirestore.instance.collection('Accounts').doc(vendorUID);
  await record1.set({
    'Name': name,
    'Email': email,
    'BuisnessName': buisnessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor'
  });

  var record3 =
      FirebaseFirestore.instance.collection('Vendor Requests').doc(vendorUID);
  await record3.set({
    'Id': vendorUID,
    'Name': name,
    'Email': email,
    'BuisnessName': buisnessName,
    'Cnic': cnic,
    'Number': number,
    'Address': address,
    'Role': 'Vendor',
    'RequestStatus': 'waiting'
  });
}
