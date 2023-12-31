import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/Model/Messenger%20Models/dialogs.dart';
import 'package:easy_shaadi/ViewModel/Messenger%20Class/apis.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/Messenger Models/chat_user.dart';
import '../../ViewModel/Vendor/venue_provider.dart';
import '../Messenger Screens/chat_screen.dart';

late ChatUser me;

class UserAppointmentDetailPage extends StatefulWidget {
  final bookingData;
  final email;
  final vendorId;

  UserAppointmentDetailPage({this.bookingData, this.email, this.vendorId});

  @override
  State<UserAppointmentDetailPage> createState() =>
      _UserAppointmentDetailPageState();
}

class _UserAppointmentDetailPageState extends State<UserAppointmentDetailPage> {
  final money = NumberFormat("#,##0", "en_US");
  final int platformFee = 5000;
  @override
  Widget build(BuildContext context) {
    Divider buildDivider() {
      return Divider(
        thickness: 1,
        color: kPurple.withOpacity(0.2),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Details"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.bookingData["orderStatus"]
                        ? Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kDarkBlue,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Your Appointment status has been updated to completed!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox(),
                    const Text(
                      "Appointment Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    Text(
                      "Appointment number: ${widget.bookingData["orderId"]}",
                    ),
                    Text("Date:  ${widget.bookingData["bookingDate"]}"),
                    Text(
                        "Appointment Status:  ${widget.bookingData["orderStatus"] ? "Completed" : "In Process"}"),
                  ],
                ),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                const Text(
                  "Stylist's Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Text("Number: ${widget.bookingData["vendorNumber"]}"),
                Text("Email: ${widget.bookingData["vendorEmail"]}"),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                const Text(
                  "Booking Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "Salon Booked On: ${widget.bookingData["salonBookedOn"]}",
                ),
                const SizedBox(height: 10),
                const Text("Selected Package:"),
                ExpandableText(
                  widget.bookingData["selectedPackage"].keys.first,
                  expandText: '\nShow More',
                  collapseText: '\nShow Less',
                  maxLines: 4,
                  linkColor: kPurple,
                  style: TextStyle(
                    color: black.withOpacity(0.4),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                const Text(
                  "Payment Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.bookingData["selectedPackage"].values.first} PKR",
                    ),
                    Text(
                      "${money.format(widget.bookingData["payment"] - platformFee)} PKR", // "${money.format(widget.perPerson * guests)} PKR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Platform Fee",
                    ),
                    Text(
                      "${money.format(platformFee)} PKR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                    ),
                    Text(
                      "${money.format(widget.bookingData["payment"])} PKR", // "${money.format(widget.perPerson * guests)} PKR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildDivider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contact the Stylist",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          APIs.addChatUser(widget.email);
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.vendorId)
                              .get()
                              .then((user) async {
                            if (user.exists) {
                              me = ChatUser.fromJson(user.data()!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen(user: me)));
                            }
                          });
                        },
                        child: const Text("Message")),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
