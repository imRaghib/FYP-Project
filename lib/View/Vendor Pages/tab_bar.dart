import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookings and Orders'),
          centerTitle: true,
        ),
        body: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.menu_book,
                    color: kPink,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.history,
                    color: kPink,
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(children: [VendorOrdersPage(), VendorOrders()]),
            )
          ],
        ),
      ),
    );
  }
}
