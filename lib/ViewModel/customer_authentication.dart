import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/ViewModel/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/Messenger Models/chat_user.dart';


var user = FirebaseAuth.instance.currentUser!;
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

 Future<void> createUser(String username) async {
final time = DateTime.now().millisecondsSinceEpoch.toString();

final chatUser = ChatUser(
    id: user.uid,
    name: username,
    email: user.email.toString(),
    about: "Hey, I'm using We Chat!",
    image: user.photoURL.toString(),
    createdAt: time,
    isOnline: false,
    lastActive: time,
    pushToken: '');

return await FirebaseFirestore.instance
    .collection('users')
.doc(user.uid)
    .set(chatUser.toJson());
}
