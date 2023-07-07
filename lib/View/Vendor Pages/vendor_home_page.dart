import 'package:easy_shaadi/View/Vendor%20Pages/add_salon_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/product_upload.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_chat_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_dashboard_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_directory_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_listing_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  int currentTab = 0;
  final List<Widget> screens = [
    VendorDashboardPage(),
    VendorChatPage(),
    VendorDirectoryPage(),
    VendorOrdersPage(),
    VendorOrders()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = VendorDashboardPage();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
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
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        height: 85,
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = VendorDashboardPage(); //Dashboard();
                      currentTab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: currentTab == 0 ? kPurple : kPink,
                      ),
                      Text(
                        'Dashboard',
                        style:
                            TextStyle(color: currentTab == 0 ? kPurple : kPink),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = VendorChatPage();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        color: currentTab == 1 ? kPurple : kPink,
                      ),
                      Text(
                        'Chat',
                        style:
                            TextStyle(color: currentTab == 1 ? kPurple : kPink),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // Right Tab Bar Icons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = VendorDirectoryPage(); //Dashboard();
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_add,
                        color: currentTab == 3 ? kPurple : kPink,
                      ),
                      Text(
                        'Directory',
                        style:
                            TextStyle(color: currentTab == 3 ? kPurple : kPink),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = VendorOrdersPage();
                      currentTab = 4;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: currentTab == 4 ? kPurple : kPink,
                      ),
                      Text(
                        'Orders',
                        style:
                            TextStyle(color: currentTab == 4 ? kPurple : kPink),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// return Scaffold(
// // bottomNavigationBar: BottomNavigationBar(),
// appBar: AppBar(
// title: Text("Dashboard"),
// centerTitle: true,
// ),
// backgroundColor: Colors.grey[100],
// body: Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// color: Colors.white,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: ListTile(
// title: const Text(
// 'Create a Listing',
// ),
// trailing: const Icon(Icons.photo_rounded),
// onTap: () {
// setState(() {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => VendorListingPage()),
// );
// });
// },
// ),
// ),
// ),
// ),
// ],
// ),
// );
