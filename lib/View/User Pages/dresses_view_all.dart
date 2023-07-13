import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dress_details.dart';
class DressesViewAll extends StatelessWidget {
  const DressesViewAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('Dresses')
        .where('isPrivate', isEqualTo: false)
        .snapshots();
    double rating;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dresses'),
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
                    child: Material(
                      elevation: 2,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.network(
                            data!['productImages'][0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(data['productName']),
                        subtitle:  RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: " Rs.${money.format(data['productPrice'])}",
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
                          initialRating: data['productFeedback']==0? 0 :(data['producRating'] / (5 * data['productFeedback'])) * 5,
                          unratedColor: Colors.grey,
                          maxRating: 5,
                          allowHalfRating: true,
                          onRatingUpdate: (value) {
                            rating = (data['productRating'] / (5 * data['productFeedback'])) * 5;
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
