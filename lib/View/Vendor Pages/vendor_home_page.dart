import 'package:easy_shaadi/View/Vendor%20Pages/add_salon_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/product_upload.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/tab_bar.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_chat_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_dashboard_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_directory_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_listing_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/providerclass.dart';

class VendorHomePage extends StatefulWidget {
  VendorHomePage({this.val=0});
  final val;

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  int currentindex = 0;
  List Screens=[
    VendorDashboardPage(),
    VendorChatPage(),
    VendorDirectoryPage(),
    OrderTabs(),
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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white.withOpacity(0),
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //     "What do you want to sell? (IDK what to write here)"),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddSalonPage()),
                                );
                              },
                              child: Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      size: 35,
                                      color: kPurple,
                                      Icons.brush,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Salon'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VendorListingPage()),
                                );
                              },
                              child: Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      size: 35,
                                      color: kPurple,
                                      Icons.girl_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Dresses'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VendorListingPage()),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      size: 35,
                                      color: kPurple,
                                      Icons.list_alt_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Venue'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Product()),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      size: 35,
                                      color: kPurple,
                                      Icons.shopping_bag_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Jewellery'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kPink,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPurple,
          iconSize: 30,
          currentIndex: currentindex,
          onTap: (indexValue) {
            setState(() {
              currentindex = indexValue;
            });
          },
          items: const [
            BottomNavigationBarItem(
                backgroundColor:kPink,
                icon: Icon(
                  Icons.dashboard,
                ),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_add), label: 'Directory'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded), label: 'Order'),
          ]),
    );
  }
}