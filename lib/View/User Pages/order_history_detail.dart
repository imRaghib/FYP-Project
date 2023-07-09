import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/order_place_details.dart';
import 'package:easy_shaadi/View/User%20Pages/order_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_time_patterns.dart';

import '../../constants.dart';

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dt= data['order_date'] as Timestamp;
    var lis=data['orderlist'] as List;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: ListView(

        children: [
          orderStatus(
            color: Colors.green,
            icon: Icons.done,
            title: "Order placed",
            showDone: data['order_placed']
          ),
          orderStatus(
              color: kPurple,
              icon: Icons.thumb_up_alt_sharp,
              title: "Order Confirmed",
              showDone: data['order_confirmed']
          ),
          orderStatus(
              color: Colors.deepOrangeAccent,
              icon: Icons.local_shipping_outlined,
              title: "On Delivery",
              showDone: data['order_on_delivery']
          ),
          orderStatus(
              color: Colors.red,
              icon: Icons.done_all,
              title: "Order Delivered",
              showDone: data['order_delivered']
          ),
          Divider(),
         SizedBox(
           height: 10,
         ),

         orderplaceDetails(
             d1: data['order_id'],
             d2: data['payment_method'],
             t1: "Order Code",
             t2: "Payment method"
         ),
         orderplaceDetails(
             d1: intl.DateFormat().add_yMd().format(dt.toDate()) ,
             d2: intl.DateFormat().add_jm().format(dt.toDate()),
             t1: "Order Date",
             t2: "Order Time"
         ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
           child: Row(
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Shipping Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                   Text('${data['buyer_email']}'),
                   Text('${data['buyer_address']}'),
                   Text('${data['buyer_city']}'),
                   Text('${data['buyer_state']}'),
                   Text('${data['buyer_phone']}'),
                   Text('${data['buyer_postalcode']}'),
                 ],
               ),


             ],
           ),


         ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Total Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                Text('${data['total_amount']} Rs')
              ],
            ),
          ),
          Divider(),
      // ListTile(
      //           leading: Image(image: NetworkImage(data['orderlist'][0]['ProductImage'])),
      //           title: Text(data['orderlist'][0]['ProductName'].toString()),
      //           subtitle: Text(data['orderlist'][0]['ProductQuantity'].toString()),
      //           trailing: Text(data['orderlist'][0]['totalAmount'].toString()+' Rs'),
      //         )
          ListView.builder(
           // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: lis.length,
              itemBuilder: (context,index) {
                return ListTile(
                  leading: Image(image: NetworkImage(data['orderlist'][index]['ProductImage'])),
                  title: Text(data['orderlist'][index]['ProductName'].toString()),
                  subtitle: Text('Quantity : '+ data['orderlist'][index]['ProductQuantity'].toString()),
                  trailing: Text(data['orderlist'][index]['totalAmount'].toString()+' Rs'),
                );
              }
              )
        ],
      ),
    );
  }
}
