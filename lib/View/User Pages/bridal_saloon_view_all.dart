import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/salon_details_screen.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../details/details_screen.dart';
class BridalViewAll extends StatelessWidget {
  const BridalViewAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('Bridal Salon')
        .where('isPrivate', isEqualTo: false).where('category', isEqualTo: 'Bridal')
        .snapshots();
    double rating;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bridal Saloons'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 0,
              ),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data?.docs[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: InkWell(
                    onTap: (){
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
                    child: Material(
                      elevation: 2,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.network(
                            data!['salonImages'][0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(data['salonName']),
                        subtitle:  RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: " Rs.${money.format(data['startingPrice'])}",
                                style: TextStyle(
                                  color: kPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: RatingBar.builder(
                          itemSize: 20,
                          ignoreGestures: true,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          initialRating: data['salonFeedback']==0? 0 :(data['salonRating'] / (5 * data['salonFeedback'])) * 5,
                          unratedColor: Colors.grey,
                          maxRating: 5,
                          allowHalfRating: true,
                          onRatingUpdate: (value) {
                            rating = (data['salonRating'] / (5 * data['salonFeedback'])) * 5;
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

    );
  }
}
