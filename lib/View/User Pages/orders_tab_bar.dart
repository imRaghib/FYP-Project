import 'package:easy_shaadi/View/User%20Pages/order_history.dart';
import 'package:easy_shaadi/View/User%20Pages/orders_inprogress.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_salon_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/venue_booking_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_orders_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';

class CustomerOrderTabs extends StatelessWidget {
  const CustomerOrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          centerTitle: true,
        ),
        drawer: const VendorDrawer(),
        body: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.shopify,
                    color: kPink,
                  ),
                ),

                Tab(
                  icon: Icon(
                    Icons.history,
                    color: kPink,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OrdersInProgress(),
                  OrderHistory()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
