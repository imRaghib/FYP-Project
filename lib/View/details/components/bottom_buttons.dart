import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/Model/Messenger%20Models/chat_user.dart';
import 'package:easy_shaadi/View/User%20Pages/booking_request_page.dart';
import 'package:easy_shaadi/ViewModel/Messenger%20Class/apis.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../ViewModel/customer_authentication.dart';
import '../../Messenger Screens/chat_screen.dart';

 late ChatUser me;

class BottomButtons extends StatelessWidget {

  const BottomButtons({required this.contact,required this.email,required this.vendorId});

  final String contact;
  final String email;
  final String vendorId;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: ()async{
            APIs.addChatUser(email);
      await FirebaseFirestore.instance.collection('users').doc(vendorId).get().then((user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(user: me)));
        }
      });

        },
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.mail_rounded),
                  color: white,
                ),
                Text(
                  ' Message',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _launchTel,
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: kPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.call_rounded),
                  color: white,
                ),
                Text(
                  ' Call',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchTel() async {
    if (!await launchUrl(Uri.parse("tel:$contact"))) {
      throw Exception('Could not launch $contact');
    }
  }

  Future<void> _launchSms() async {
    if (!await launchUrl(Uri.parse("sms:$contact"))) {
      throw Exception('Could not launch $contact');
    }
  }
}
