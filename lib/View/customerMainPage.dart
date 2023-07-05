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

    final Stream<QuerySnapshot> usersStream =
        FirebaseFirestore.instance.collection('Venues').snapshots();

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
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            //   child: Row(
            //     children: const [
            //       Text(
            //         'Wedding Planning tools',
            //         style: TextStyle(
            //           fontFamily: 'SourceSansPro-SemiBold',
            //           fontSize: 20,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: size.height * 0.12,
            //   child: ListView(
            //     physics: ClampingScrollPhysics(),
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       ToolCard(
            //         // image: prov.hallsList[0].image,
            //         // title: prov.hallsList[0].name,
            //         color: Color(0xFFdcefe9),
            //         press: () {},
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       ToolCard(
            //         // image: prov.hallsList[0].image,
            //         // title: prov.hallsList[0].name,
            //         color: Color(0xFFdce2f7),
            //         press: () {},
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       ToolCard(
            //         // image: prov.hallsList[0].image,
            //         // title: prov.hallsList[0].name,
            //         color: Color(0xFFfddde8),
            //         press: () {},
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       ToolCard(
            //         // image: prov.hallsList[0].image,
            //         // title: prov.hallsList[0].name,
            //         color: Color(0xFFdcefe9),
            //         press: () {},
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
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

            /// here-------------------------------------------------------------------
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Venues').snapshots(),
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

            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Venues for you',
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
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jewelery for you',
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
                physics: ClampingScrollPhysics(),
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
                              'https://media.4rgos.it/i/Argos/sb-2722-M027-gold-7363506_C2?maxW=768&qlt=75&fmt.jpeg.interlaced=true',
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
                                  text: "Jewelry Palace\n".toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'SourceSansPro-SemiBold',
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                const TextSpan(
                                  text: "Rs. 40,000",
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

            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bridal Salon for you',
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Bridal Salon')
                  .where('category', isEqualTo: 'Bridal')
                  .snapshots(),
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
                    'Groom Salon for you',
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Bridal Salon')
                  .where('category', isEqualTo: 'Groom')
                  .snapshots(),
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
                physics: ClampingScrollPhysics(),
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
                            borderRadius: BorderRadius.all(
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

// class ToolCard extends StatelessWidget {
//   const ToolCard({
//     // required this.image,
//     // required this.title,
//     required this.color,
//     required this.press,
//   });
//
//   // final String image, title;
//   final Color color;
//   final VoidCallback press;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return InkWell(
//       onTap: press,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: 4 / 3,
//               child: ClipRRect(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                   child: Container(
//                     color: color,
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
