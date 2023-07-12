import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/Model/Vendor/product_model.dart';
import 'package:easy_shaadi/View/User%20Pages/order_place_details.dart';
import 'package:easy_shaadi/View/User%20Pages/order_status.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_time_patterns.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../Model/Order.dart';
import '../../ViewModel/Customer/venue_request_provider.dart';
import '../../constants.dart';
import '../../payment_config.dart';
import '../customerMainPage.dart';

class OrderReview extends StatefulWidget {

  final paddress;
  final pcity;
  final pstate;
  final pphone;
  final ppostalcode;

   OrderReview({Key? key,this.paddress,this.pcity,this.pphone,this.ppostalcode,this.pstate}) : super(key: key);

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {

  @override
  Widget build(BuildContext context) {
    void showAlert(){
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Order Placed',
          text: 'Order Placed Successfully',
        showCancelBtn: false,

      );
    }
    var prov=Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Review'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: ListView(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: prov.cartList.length,
              itemBuilder: (context,index) {
                return ListTile(
                  leading: Image(image: NetworkImage(prov.cartList[index].ProductImages)),
                  title: Text(prov.cartList[index].ProductName),
                  subtitle: Text('Quantity : '+ '${prov.cartList[index].ProductQuantity}'),
                  trailing: Text('${prov.cartList[index].ProductPrice}' +' Rs'),
                );
              }
          ),

          Divider(),
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                    Text(FirebaseAuth.instance.currentUser!.email.toString()),
                    Text(widget.paddress),
                    Text(widget.pcity),
                    Text(widget.pstate),
                    Text(widget.pphone),
                    Text(widget.ppostalcode),
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
                Text('${prov.getTotalAmount()+prov.getTotalDelivery()}'' Rs')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 4),
            child: ElevatedButton(onPressed: ()async{
              Provider.of<ProductProvider>(context, listen: false)
                  .getProductDetails();
              Provider.of<ProductProvider>(context, listen: false)
                  .placeOrder(
                  address: widget.paddress,
                  city: widget.pcity,
                  state: widget.pstate,
                  postalcode: widget.ppostalcode,
                  phone: widget.pphone);
              Provider
                  .of<ProductProvider>(context, listen: false)
                  .cartList = [];

              showAlert();
              await Future.delayed(Duration(milliseconds: 2000));
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  BottomNavBar(val: 0,),
                ),
              );
            }, child: Text('Test Order')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 4),
            child: GooglePayButton(
              paymentConfiguration:
              PaymentConfiguration.fromJsonString(defaultGooglePay),
              paymentItems: [
                PaymentItem(
                    label: 'Hammad',
                    amount: (prov.getTotalAmount()+prov.getTotalDelivery()).toString(),
                    status: PaymentItemStatus.final_price),
              ],
              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) {
                debugPrint("Results: ${result.toString()}");
                try {
                  Provider.of<ProductProvider>(context, listen: false)
                      .getProductDetails();
                  Provider.of<ProductProvider>(context, listen: false)
                      .placeOrder(
                      address: widget.paddress,
                      city: widget.pcity,
                      state: widget.pstate,
                      postalcode: widget.ppostalcode,
                      phone: widget.pphone);
                  Provider
                      .of<ProductProvider>(context, listen: false)
                      .cartList = [];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(val: 0),
                    ),
                  );
                } catch (error) {
                  debugPrint("Payment request Error: ${error.toString()}");
                }
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (error) {
                debugPrint("Payment Error: ${error.toString()}");
              },
            ),
          ),
        ],
      ),
    );

  }
}
