import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/salon_details_screen.dart';
import 'package:easy_shaadi/View/details/details_screen.dart';
import 'package:easy_shaadi/View/viewAll.dart';
import 'package:easy_shaadi/ViewModel/Drawer/custom_drawer.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'User Pages/item_Card.dart';
import '../ViewModel/providerclass.dart';
import 'User Pages/jewlery_details.dart';

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
        .where('private', isEqualTo: false)
        .snapshots();

    int totalRating = 10;
    int totalFeedbacks = 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),

        // toolbarHeight: 80,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(15),
        //     bottomRight: Radius.circular(15),
        //   ),
        // ),
        //
        centerTitle: true,
        // // backgroundColor: Theme.of(context).primaryColor
        // backgroundColor: Colors.deepPurpleAccent,

        // leading: Icon(Icons.search),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                children: const [
                  Text(
                    'Wedding Planning tools',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                  ),
                ],
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
                    press: () {},
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToolCard(
                    icon: Icons.assignment_ind,
                    title: "GuestList",
                    color: kPurple,
                    press: () {},
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewAll()));
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
                  .collection('Venues')
                  .where('private', isEqualTo: false)
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                              builder: (context) => JeweleryDetailsScreen(
                                imageUrlList: data['venueImages'],
                                title: data['venueName'],
                                address: data['venueAddress'],
                                description: data['venueDescription'],
                                price: data['venuePrice'],
                                contact: data['vendorNumber'],
                                vendorUID: data['vendorUID'],
                                venueId: data['venueId'],
                                email: data['vendorEmail'],
                                Carrots: '24k',
                                tola: '1 tola',
                                deliveryCharges: 300,
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
                    onPressed: () {},
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
                      return ItemCard(
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
                    onPressed: () {},
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
                      return ItemCard(
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
                    onPressed: () {},
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
            SizedBox(
              height: size.height * 0.21,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  width: 15,
                ),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              'https://cdn.shopify.com/s/files/1/1732/6543/products/LatestRedBridalDressinPishwasFrockandLehengaStyle_620x.jpg?v=1661375562',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Glamour Emporium\n".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'SourceSansPro-SemiBold',
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: "Rs. 10,000",
                                  style: TextStyle(
                                    color: kPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      RatingBar.builder(
                        itemSize: 20,
                        ignoreGestures: true,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        initialRating: (totalRating / (5 * totalFeedbacks)) * 5,
                        unratedColor: Colors.grey,
                        maxRating: 5,
                        allowHalfRating: true,
                        onRatingUpdate: (value) {
                          value = (totalRating / (5 * totalFeedbacks)) * 5;
                        },
                      ),
                    ],
                  );
                },
              ),
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

// ListView(
//   shrinkWrap: true,
//   physics: ScrollPhysics(),
//   children: [
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: const [
//         Text(
//           'Wedding Planning Tools',
//           style: TextStyle(
//             fontFamily: 'SourceSansPro-SemiBold',
//             fontSize: 20,
//           ),
//         ),
//       ],
//     ),
//     // ListView.builder(
//     //   scrollDirection: Axis.horizontal,
//     //   itemCount: prov.hallsList.length,
//     //   itemBuilder: (context, index) => Card(
//     //     image: prov.hallsList[index].image,
//     //     title: prov.hallsList[index].name,
//     //     country: "Russia",
//     //     price: 440,
//     //     press: () {},
//     //   ),
//     // ),
//
//     // Container(
//     //   height: 200,
//     //   child: ListView.builder(
//     //       scrollDirection: Axis.horizontal,
//     //       itemCount: prov.hallsList.length,
//     //       itemBuilder: (context, index) {
//     //         return MyItems(
//     //           name: prov.hallsList[index].name,
//     //           image: prov.hallsList[index].image,
//     //           price: prov.hallsList[index].price,
//     //           description: prov.hallsList[index].description,
//     //         );
//     //       }),
//     // ),
//     // Row(
//     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //   children: [
//     //     Text(
//     //       'Wedding Halls',
//     //       style: TextStyle(
//     //         fontFamily: 'SourceSansPro-SemiBold',
//     //         fontSize: 20,
//     //       ),
//     //     ),
//     //     TextButton(
//     //         onPressed: () {
//     //           Navigator.push(
//     //             context,
//     //             MaterialPageRoute(
//     //               builder: (context) => ViewAll(
//     //                 items: prov.hallsList,
//     //               ),
//     //             ),
//     //           );
//     //         },
//     //         child: Text(
//     //           'View All',
//     //           style: TextStyle(
//     //             fontFamily: 'SourceSansPro-SemiBold',
//     //             fontSize: 15,
//     //           ),
//     //         ))
//     //   ],
//     // ),
//     // Container(
//     //   height: 200,
//     //   child: ListView.builder(
//     //       scrollDirection: Axis.horizontal,
//     //       itemCount: prov.hallsList.length,
//     //       itemBuilder: (context, index) {
//     //         return MyItems(
//     //           name: prov.hallsList[index].name,
//     //           image: prov.hallsList[index].image,
//     //           price: prov.hallsList[index].price,
//     //           description: prov.hallsList[index].description,
//     //         );
//     //       }),
//     // ),
//     // Row(
//     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //   children: [
//     //     Text(
//     //       'Jewelery for you',
//     //       style: TextStyle(
//     //         fontFamily: 'SourceSansPro-SemiBold',
//     //         fontSize: 20,
//     //       ),
//     //     ),
//     //     TextButton(
//     //         onPressed: () {
//     //           Navigator.push(
//     //             context,
//     //             MaterialPageRoute(
//     //               builder: (context) => ViewAll(
//     //                 items: prov.hallsList,
//     //               ),
//     //             ),
//     //           );
//     //         },
//     //         child: Text(
//     //           'View All',
//     //           style: TextStyle(
//     //             fontFamily: 'SourceSansPro-SemiBold',
//     //             fontSize: 15,
//     //           ),
//     //         ))
//     //   ],
//     // ),
//     // Container(
//     //   height: 200,
//     //   child: ListView.builder(
//     //       scrollDirection: Axis.horizontal,
//     //       itemCount: prov.hallsList.length,
//     //       itemBuilder: (context, index) {
//     //         return MyItems(
//     //           name: prov.hallsList[index].name,
//     //           image: prov.hallsList[index].image,
//     //           price: prov.hallsList[index].price,
//     //           description: prov.hallsList[index].description,
//     //         );
//     //       }),
//     // ),
//     ElevatedButton(
//         onPressed: () {
//           signout();
//           Navigator.pushNamedAndRemoveUntil(
//               context, 'StreamPage', (route) => false);
//         },
//         child: Text('Signout'))
//   ],
// ),
