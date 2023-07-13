import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/bridal_saloon_view_all.dart';
import 'package:easy_shaadi/View/User%20Pages/dress_details.dart';
import 'package:easy_shaadi/View/User%20Pages/dresses_view_all.dart';
import 'package:easy_shaadi/View/User%20Pages/groom_salon_view_all.dart';
import 'package:easy_shaadi/View/User%20Pages/jewelery_view_all.dart';
import 'package:easy_shaadi/View/User%20Pages/salon_details_screen.dart';
import 'package:easy_shaadi/View/User%20Pages/venue_view_all.dart';
import 'package:easy_shaadi/View/details/details_screen.dart';
import 'package:easy_shaadi/View/viewAll.dart';
import 'package:easy_shaadi/ViewModel/Drawer/custom_drawer.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'User Pages/item_Card.dart';
import '../ViewModel/providerclass.dart';
import 'User Pages/jewlery_details.dart';
import 'details/components/productCard.dart';

class CustomerMainPage extends StatefulWidget {
  const CustomerMainPage({Key? key}) : super(key: key);

  @override
  State<CustomerMainPage> createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {
  @override
  Widget build(BuildContext context) {
    double rate = 0.0;
    var prov = Provider.of<ProductProvider>(context);
    Size size = MediaQuery.of(context).size;

    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('Venues')
        .where('isPrivate', isEqualTo: false)
        .snapshots();

    final Stream<QuerySnapshot> jewleryStream = FirebaseFirestore.instance
        .collection('Jewelerys')
        .where('isPrivate', isEqualTo: false)
        .snapshots();
    final Stream<QuerySnapshot> DressStream = FirebaseFirestore.instance
        .collection('Dresses')
        .where('isPrivate', isEqualTo: false)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                'Wedding Planning tools',
                style: TextStyle(
                  fontFamily: 'SourceSansPro-SemiBold',
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ToolCard(
                    icon: Icons.checklist,
                    title: "CheckList",
                    color: kPurple,
                    press: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return BottomNavBar(
                              val: 4,
                            );
                          }));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToolCard(
                    icon: Icons.assignment_ind,
                    title: "GuestList",
                    color: kPurple,
                    press: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return BottomNavBar(
                              val: 5,
                            );
                          }));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToolCard(
                    icon: Icons.timer,
                    title: "Coming Soon",
                    color: kPurple,
                    press: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Coming Soon',
                                style: TextStyle(
                                  fontFamily: 'SourceSansPro-SemiBold',
                                )),
                            content: const Text('This feature is coming soon.',
                                style: TextStyle(
                                  fontFamily: 'SourceSansPro-SemiBold',
                                )),
                            actions: [
                              TextButton(
                                child: const Text('OK',
                                    style: TextStyle(
                                      fontFamily: 'SourceSansPro-SemiBold',
                                      fontSize: 18,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Venues',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                //   TextButton(
                //     onPressed: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) => ViewAll()));
                //     },
                //     child: const Text(
                //       'View All',
                //       style: TextStyle(
                //         fontFamily: 'SourceSansPro-SemiBold',
                //         fontSize: 15,
                //       ),
                //     ),
                //   ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Venues')
                  .where('isPrivate', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.39,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ItemCard(
                        context: context,
                        image: data!['venueImages'][0],
                        title: data['venueName'],
                        price: data['venuePrice'],
                        totalRating: data['venueRating'],
                        totalFeedbacks: data['venueFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                imageUrlList: data['venueImages'],
                                title: data['venueName'],
                                address: data['venueAddress'],
                                description: data['venueDescription'],
                                price: data['venuePrice'],
                                isFav: false,
                                contact: data['vendorNumber'],
                                inactiveDates: data['inActiveDates'],
                                vendorUID: data['vendorUID'],
                                venueId: data['venueId'],
                                menuMap: data['menus'],
                                email: data['vendorEmail'],
                                parking: data['venueParking'],
                                capacity: data['venueCapacity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Venues for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>VenueViewAll()
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro-SemiBold',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ItemCard(
                        context: context,
                        image: data!['venueImages'][0],
                        title: data['venueName'],
                        price: data['venuePrice'],
                        totalRating: data['venueRating'],
                        totalFeedbacks: data['venueFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                imageUrlList: data['venueImages'],
                                title: data['venueName'],
                                address: data['venueAddress'],
                                description: data['venueDescription'],
                                price: data['venuePrice'],
                                isFav: false,
                                contact: data['vendorNumber'],
                                inactiveDates: data['inActiveDates'],
                                vendorUID: data['vendorUID'],
                                venueId: data['venueId'],
                                menuMap: data['menus'],
                                email: data['vendorEmail'],
                                parking: data['venueParking'],
                                capacity: data['venueCapacity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            // not live data

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jewelery for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>JewleryViewAll()
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro-SemiBold',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: jewleryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ProductCard(
                        context: context,
                        image: data!['productImages'][0],
                        title: data['productName'],
                        price: data['productPrice'],
                        totalRating: data['productRating'],
                        totalFeedbacks: data['productFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JeweleryDetailsScreen(
                                imageUrlList: data['productImages'],
                                title: data['productName'],
                                address: data['productAddress'],
                                description: data['productDescription'],
                                price: data['productPrice'],
                                contact: data['sellerNumber'],
                                vendorUID: data['sellerUID'],
                                venueId: data['productId'],
                                email: data['sellerEmail'],
                                Carrots: data['productCarrots'],
                                tola: data['productSize'],
                                deliveryCharges: data['productDelivery'],
                                availableQuantity: data['availableQuantity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bridal Salon for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>BridalViewAll()
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro-SemiBold',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Bridal Salon')
                  .where('category', isEqualTo: 'Bridal')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ProductCard(
                        context: context,
                        image: data!['salonImages'][0],
                        title: data['salonName'],
                        price: data['startingPrice'],
                        totalRating: data['salonRating'],
                        totalFeedbacks: data['salonFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalonDetailsScreen(
                                imageUrlList: data['salonImages'],
                                title: data['salonName'],
                                address: data['salonAddress'],
                                description: data['salonDescription'],
                                price: data['startingPrice'],
                                isFav: false,
                                contact: data['vendorNumber'],
                                inactiveDates: data['inActiveDates'],
                                vendorUID: data['vendorUID'],
                                venueId: data['salonId'],
                                menuMap: data['salonPackages'],
                                email: data['vendorEmail'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Groom Salon for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroomViewAll()
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro-SemiBold',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Bridal Salon')
                  .where('category', isEqualTo: 'Groom')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ProductCard(
                        context: context,
                        image: data!['salonImages'][0],
                        title: data['salonName'],
                        price: data['startingPrice'],
                        totalRating: data['salonRating'],
                        totalFeedbacks: data['salonFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalonDetailsScreen(
                                imageUrlList: data['salonImages'],
                                title: data['salonName'],
                                address: data['salonAddress'],
                                description: data['salonDescription'],
                                price: data['startingPrice'],
                                isFav: false,
                                contact: data['vendorNumber'],
                                inactiveDates: data['inActiveDates'],
                                vendorUID: data['vendorUID'],
                                venueId: data['salonId'],
                                menuMap: data['salonPackages'],
                                email: data['vendorEmail'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dresses for you',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>DressesViewAll()
                        ),
                      );
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro-SemiBold',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: DressStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return SizedBox(
                  height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return ProductCard(
                        context: context,
                        image: data!['productImages'][0],
                        title: data['productName'],
                        price: data['productPrice'],
                        totalRating: data['productRating'],
                        totalFeedbacks: data['productFeedback'],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DressDetailsScreen(
                                imageUrlList: data['productImages'],
                                title: data['productName'],
                                address: data['productAddress'],
                                description: data['productDescription'],
                                price: data['productPrice'],
                                contact: data['sellerNumber'],
                                vendorUID: data['sellerUID'],
                                venueId: data['productId'],
                                email: data['sellerEmail'],
                                size: data['productSize'],
                                deliveryCharges: data['productDelivery'],
                                availableQuantity: data['availableQuantity'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    // required this.image,
    required this.title,
    required this.color,
    required this.press,
    required this.icon,
  });

  // final String image, title;
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    color: color,
                    padding: const EdgeInsets.all(
                      kDefaultPadding / 2,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'SourceSansPro-SemiBold',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

