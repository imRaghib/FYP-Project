import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
class VendorOrders extends StatelessWidget {
  const VendorOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(color: kPink),),
        centerTitle: true,
      ),
      body: Text('data'),
    );
  }
}
