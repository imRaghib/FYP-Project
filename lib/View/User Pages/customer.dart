import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../ViewModel/customer_authentication.dart';

class Customer {
  String name;
  String email;
  String password;


  Customer({
    this.email = '',
    this.name = '',
    this.password = '',
  });
  Future customer_signup(
      {String email = '', String password = '', String name = ''}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var customerid = FirebaseAuth.instance.currentUser!.uid;

    var record =
    FirebaseFirestore.instance.collection('Customers').doc(customerid);
    record.set({'Name': name, 'Email': email, 'Role': 'Customer'});

    var record1 =
    FirebaseFirestore.instance.collection('Accounts').doc(customerid);
    record1.set({'Name': name, 'Email': email, 'Role': 'Customer'});

    await createUser(name);

  }


}