import 'package:easy_shaadi/ViewModel/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future signout()async{
  FirebaseAuth.instance.signOut();
}