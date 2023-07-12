import 'package:easy_shaadi/View/Admin%20Pages/manage_payments_page.dart';
import 'package:easy_shaadi/View/Admin%20Pages/user_page.dart';
import 'package:easy_shaadi/View/Admin%20Pages/vendor_request_page.dart';
import 'package:easy_shaadi/View/Messenger%20Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';

class AdminPage extends StatefulWidget {
  AdminPage({this.val});
  final val;
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  List screens = const [
    VendorRequestPage(),
    UserDetailPage(),
    ManagePaymentsPage(),
    MessengerScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex=widget.val ?? 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurpleAccent,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (indexValue) {
            setState(() {
              currentIndex = indexValue;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Vendors'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Payments'),
            BottomNavigationBarItem(icon: Icon(Icons.mail_outlined), label: 'Messages'),
          ]),
    );
  }
}
