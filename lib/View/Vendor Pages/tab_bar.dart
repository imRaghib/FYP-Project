import 'package:easy_shaadi/View/Vendor%20Pages/vendor_drawer.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_inProgress_orders.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_salon_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/venue_booking_page.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_completed_orders_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings and Orders'),
        ),
        drawer: const VendorDrawer(),
        body: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.menu_book,
                    color: kPurple,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.brush,
                    color: kPurple,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.shopify,
                    color: kPurple,
                  ),
                ),

              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  VendorVenueBookingPage(),
                  VendorSalonAppointmentPage(),
                  InProgressVendorOrders(),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
