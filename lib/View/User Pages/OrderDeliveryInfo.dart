import 'package:easy_shaadi/View/User%20Pages/order_review.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/Customer/venue_request_provider.dart';
import '../../ViewModel/providerclass.dart';
import '../../payment_config.dart';
import '../customerMainPage.dart';

String address = '';
String city = '';
String state = '';
String phone = '';
String postalcode = '';

class DeliveryDetails extends StatefulWidget {
  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  final formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPink,
        title: Text('Shipping Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delivery Details',style: TextStyle(
                fontFamily: 'SourceSansPro-SemiBold',
                fontSize: 25,
              ),
                textAlign: TextAlign.center,
              ),
                  ),
                  SizedBox(height: 20,),
              buildAddress(),
              buildCity(),
              buildState(),
              buildPostalCode(),
              buildPhone(),
              SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                child: InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        // Provider.of<ProductProvider>(context, listen: false)
                        //     .getProductDetails();
                        // Provider.of<ProductProvider>(context, listen: false)
                        //     .placeOrder(
                        //     address: address,
                        //     city: city,
                        //     state: state,
                        //     postalcode: postalcode,
                        //     phone: phone);
                        // Provider
                        //     .of<ProductProvider>(context, listen: false)
                        //     .cartList = [];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderReview(
                                    paddress: address,
                                    pcity: city,
                                    pphone: phone,
                                    ppostalcode: postalcode,
                                    pstate: state,
                                  )
                          ),
                        );
                      } catch (error) {
                        debugPrint(
                            "Payment request Error: ${error.toString()}");
                      }

                    }
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 15),
                      decoration: BoxDecoration(
                        color: kPink.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Text(
                        "   Place Order   ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: kPurple,
                        ),
                      ),
                    ),
                  ),
                ),
              ),


              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10.0, right: 10),
              //   child: GooglePayButton(
              //     paymentConfiguration:
              //     PaymentConfiguration.fromJsonString(defaultGooglePay),
              //     paymentItems: [
              //       PaymentItem(
              //           label: widget.productName,
              //           amount: widget.totalPrice.toString(),
              //           status: PaymentItemStatus.final_price),
              //     ],
              //     type: GooglePayButtonType.buy,
              //     margin: const EdgeInsets.only(top: 15.0),
              //     onPaymentResult: (result) {
              //
              //       if (formKey.currentState!.validate()) {
              //         formKey.currentState!.save();
              //         try {
              //           try {
              //
              //             Provider.of<ProductProvider>(context, listen: false)
              //                 .getProductDetails();
              //             Provider.of<ProductProvider>(context, listen: false)
              //                 .placeOrder(
              //                 address: address,
              //                 city: city,
              //                 state: state,
              //                 postalcode: postalcode,
              //                 phone: phone);
              //             Provider.of<ProductProvider>(context,listen: false).cartList=[];
              //
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const CustomerMainPage(),
              //               ),
              //             );
              //           } catch (error) {
              //             debugPrint("Payment request Error: ${error.toString()}");
              //           }
              //         } catch (e) {
              //           setState(() {
              //             error = e.toString();
              //           });
              //         }
              //       }
              //
              //
              //     },
              //     loadingIndicator: const Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //     onError: (error) {
              //       debugPrint("Payment Error: ${error.toString()}");
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Address",
                labelText: "Address",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[#.0-9a-zA-Z\s,-]+$').hasMatch(value)) {
                  return "Enter your Address";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => address = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "City",
                labelText: "City",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[a-zA-Z\s,-]+$').hasMatch(value)) {
                  return "Enter your City";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => city = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "State",
                labelText: "State",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[a-zA-Z\s-]+$').hasMatch(value)) {
                  return "Enter your State";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => state = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPostalCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "PostalCode",
                labelText: "PostalCode",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^\d{5}(?:[-\s]\d{4})?$').hasMatch(value)) {
                  return "Enter your PostalCode";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => postalcode = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPhone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Phone Number",
                labelText: "Phone Number",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d{11}$").hasMatch(value)) {
                  return "Enter your Phone Number";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => phone = value!),
            ),
          ),
        ],
      ),
    );
  }
}

