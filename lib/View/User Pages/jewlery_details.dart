import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_shaadi/Model/Order.dart';
import 'package:easy_shaadi/View/User%20Pages/booking_request_page.dart';
import 'package:easy_shaadi/View/details/components/bottom_buttons.dart';
import 'package:easy_shaadi/View/details/components/custom_app_bar.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class JeweleryDetailsScreen extends StatefulWidget {
  final imageUrlList;
  final title;
  final address;
  final description;
  final price;
  final contact;
  final vendorUID;
  final venueId;
  final Carrots;
  final tola;
  final deliveryCharges;
  final email;
  final availableQuantity;

  JeweleryDetailsScreen ({
    super.key,
    this.imageUrlList,
    this.title,
    this.address,
    this.description,
    this.price,
    this.deliveryCharges,
    this.Carrots,
    this.tola,
    this.contact,
    this.vendorUID,
    this.venueId,
    this.email,
    this.availableQuantity
  });

  @override
  _JeweleryDetailsScreenState createState() => _JeweleryDetailsScreenState();
}

class _JeweleryDetailsScreenState extends State<JeweleryDetailsScreen> {
  int cost = 0;
  int activeIndex = 0;
  int quantity=0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final money = NumberFormat("#,##0", "en_US");

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.imageUrlList.length,
                    itemBuilder:
                        (BuildContext context, index, int pageViewIndex) {
                      final imageUrl = widget.imageUrlList[index];
                      return buildImage(imageUrl, index);
                    },
                    options: CarouselOptions(
                        height: size.height * 0.45,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.43),
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: appPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rs. ${money.format(widget.price)}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.address,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: black.withOpacity(0.4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                       Padding(
                         padding: const EdgeInsets.only(bottom: kDefaultPadding),
                         child: Container(
                           height: 30,
                           child: Row(
                             children: [
                               Text('Quantity : ',style: TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold,
                               ),),
                               ElevatedButton(
                                 onPressed: () {
                                   setState(() {
                                     if(quantity<widget.availableQuantity)
                                       {
                                         quantity++;
                                       }

                                   });
                                 },
                                 child: Text('+',style: TextStyle(
                                   fontWeight: FontWeight.bold
                                       ,fontSize: 19
                                 ),),
                                 style: ElevatedButton.styleFrom(
                                   shape: CircleBorder(),
                                   //padding: EdgeInsets.all(24),
                                 ),
                               ),
                               Text(' ${quantity}'),
                               ElevatedButton(
                                 onPressed: () {
                                   setState(() {
                                     if(quantity>0){
                                       quantity--;
                                     }

                                   });
                                 },
                                 child: Text('-',style: TextStyle(
                                     fontWeight: FontWeight.bold
                                     ,fontSize: 19
                                 ),),
                                 style: ElevatedButton.styleFrom(
                                   shape: CircleBorder(),
                                   //padding: EdgeInsets.all(24),
                                 ),
                               )
                             ],
                           ),
                         ),
                       ),

                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Delivery Charges : ${widget.deliveryCharges} Rs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Jewlery information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Carrots : ${widget.Carrots}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Weight : ${widget.tola}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: kDefaultPadding,
                          ),
                          child: ExpandableText(
                            widget.description,
                            expandText: '\nShow More',
                            collapseText: '\nShow Less',
                            maxLines: 4,
                            linkColor: kPurple,
                            style: TextStyle(
                              color: black.withOpacity(0.4),
                              height: 1.5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: kPurple.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Contact Seller',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BottomButtons(
                          contact: widget.contact,
                          email: widget.email,
                          vendorId: widget.vendorUID,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: kPurple.withOpacity(0.2),
                          ),
                        ),





                        SizedBox(
                          height: 110,
                        )
                      ],
                    ),
                  ),
                  buildIndicator(),
                  CustomAppBar(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(),
                  ),
                ),
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                      child: InkWell(
                        onTap: () {
                          print(DateTime.now().toString());
                          if(quantity>0){
                            var prov = Provider.of<ProductProvider>(context,listen: false);
                            bool c=false;
                            prov.cartList.forEach((element) {
                              if(element.ProductName==widget.title){
                                c=true;
                                element.ProductQuantity=element.ProductQuantity+quantity;
                                var total = element.ProductQuantity;
                                Fluttertoast.showToast(msg: '${widget.title} added $total times in cart',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.grey,
                                  fontSize: 15,
                                );
                              }
                            });
                            if(!c){
                              Provider.of<ProductProvider>(context,listen: false).addToCart(
                                  widget.title,
                                  widget.price,
                                  widget.imageUrlList[0],
                                  quantity,
                                  widget.deliveryCharges,
                                  widget.vendorUID,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  widget.tola
                              );
                              Fluttertoast.showToast(msg: '${widget.title} added in cart',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                fontSize: 15,
                              );
                            }


                          }
                          else{
                            Fluttertoast.showToast(msg: 'Kindly Select Quantity',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              fontSize: 15,
                            );
                          }

                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: kPink.withOpacity(0.3),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Text(
                            "   Add to Cart   ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPage(
                                imageUrlList: widget.imageUrlList[0],
                                title: widget.title,
                                address: widget.address,
                                description: widget.description,
                                venuePrice: widget.price,
                                contact: widget.contact,
                                vendorUID: widget.vendorUID,
                                venueId: widget.venueId,
                                perPerson: cost,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: kPink.withOpacity(0.7),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Text(
                            "   Place Order   ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl, int index) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() => Positioned(
    left: 0,
    right: 0,
    top: MediaQuery.of(context).size.height * 0.39,
    child: Align(
      alignment: AlignmentDirectional.topCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.imageUrlList.length,
        effect: JumpingDotEffect(
            dotHeight: 14,
            dotWidth: 14,
            dotColor: Colors.white.withOpacity(0.6),
            activeDotColor: kPurple),
      ),
    ),
  );
}
