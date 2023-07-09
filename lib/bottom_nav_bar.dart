import 'package:easy_shaadi/View/Messenger%20Screens/home_screen.dart';
import 'package:easy_shaadi/View/User%20Pages/order_history.dart';
import 'package:easy_shaadi/View/User%20Pages/orders_tab_bar.dart';
import 'package:easy_shaadi/View/customerMainPage.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/checklist/pages/home_page.dart';
import 'package:easy_shaadi/guest_list_content/guest_list_main.dart';
import 'package:easy_shaadi/newchanges/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({this.val=0});
  final val;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentindex = 0;
  List Screens=[
    CustomerMainPage(),
    MessengerScreen(),
    ReviewCart(),
    CustomerOrderTabs(),
    CheckList(),
    GuestList()
  ];
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fetchHallsData();
    currentindex=widget.val;
    // Provider.of<ProductProvider>(context, listen: false).fetchHallsData1();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF9f5f2),

      body: Screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurpleAccent,
          iconSize: 30,
          currentIndex: currentindex,
          onTap: (indexValue) {
            setState(() {
              currentindex = indexValue;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.mail_outlined), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_outlined), label: 'Checklist'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt), label: 'GuestList'),
          ]),
    );
  }
}
