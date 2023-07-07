import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/order_place_details.dart';
import 'package:easy_shaadi/View/User%20Pages/order_status.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_status_viewmodel.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_time_patterns.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class VendorOrderDetails extends StatefulWidget {
  final dynamic data;
  const VendorOrderDetails({Key? key, this.data}) : super(key: key);

  @override
  State<VendorOrderDetails> createState() => _VendorOrderDetailsState();
}

class _VendorOrderDetailsState extends State<VendorOrderDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductProvider>(context,listen: false).getSameVendorOrders(widget.data);
    status.getStatus(widget.data);
  }
  @override
  Widget build(BuildContext context) {
    var dt= widget.data['order_date'] as Timestamp;
    var lis=widget.data['orderlist'] as List;
    var dt1= widget.data as DocumentSnapshot;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: ListView(

        children: [
          SwitchListTile(
              title: Text('Order Placed',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              value: true,
              onChanged: (val){

              }
          ),
          SwitchListTile(
              title: Text('Order Confirmed',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              value: status.confirmed,
              onChanged: (val){
                status.confirmed=val;
                status.changeStatus(
                    title: 'order_confirmed',
                    status: val,
                    docId: dt1.id
                );
                setState(() {
                });
              }
          ),
          SwitchListTile(
              title: Text('On Delivery',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              value: status.onDelivery,
              onChanged: (val){
                status.onDelivery=val;
                status.changeStatus(
                    title: 'order_on_delivery',
                    status: val,
                    docId: dt1.id
                );
                setState(() {
                });
              }
          ),
          SwitchListTile(
              title: Text('Order Delivered',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              value: status.delivered,
              onChanged: (val){

                status.delivered=val;
                status.changeStatus(
                    title: 'order_delivered',
                    status: val,
                    docId: dt1.id
                );
                setState(() {
                });
              }
          ),

          Divider(),
          SizedBox(
            height: 10,
          ),

          orderplaceDetails(
              d1: widget.data['order_id'],
              d2: widget.data['payment_method'],
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
                    Text('${widget.data['buyer_email']}'),
                    Text('${widget.data['buyer_address']}'),
                    Text('${widget.data['buyer_city']}'),
                    Text('${widget.data['buyer_state']}'),
                    Text('${widget.data['buyer_phone']}'),
                    Text('${widget.data['buyer_postalcode']}'),
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
                Text('${widget.data['total_amount']} Rs')
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
              itemCount: Provider.of<ProductProvider>(context).orders.length,
              itemBuilder: (context,index) {
                return ListTile(
                  leading: Image(image: NetworkImage(widget.data['orderlist'][index]['ProductImage'])),
                  title: Text(widget.data['orderlist'][index]['ProductName'].toString()),
                  subtitle: Text('Quantity : '+ widget.data['orderlist'][index]['ProductQuantity'].toString()),
                  trailing: Text(widget.data['orderlist'][index]['totalAmount'].toString()+' Rs'),
                );
              }
          )
        ],
      ),
    );
  }
}
