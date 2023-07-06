import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:provider/provider.dart';
import 'package:easy_shaadi/stringCasingExtension.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: const Text("Admin Page"),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Provider.of<ProductProvider>(context).signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'StreamPage', (route) => false);
                  },
                  child: const Text('Sign out')),
            ],
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Pending Requests",
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "View all",
                    style: TextStyle(
                      fontFamily: 'SourceSansPro-SemiBold',
                      fontSize: 15,
                      color: kPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Vendor Requests')
                  // .where('category', isEqualTo: 'Groom')
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
                  // height: size.height * 0.21,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: ListTile(
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            backgroundColor: kPink,
                            child: Text(
                              data!['Name'].toString().toTitleCase()[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            data['Name'].toString().toTitleCase(),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['Email'].toString().toTitleCase(),
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // Handle onTap event here
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        )

        // body: Column(
        //   children: [
        //     // Container(
        //     //   height: size.height * 0.40,
        //     //   margin: EdgeInsets.only(bottom: size.height * 0.72),
        //     //   padding: EdgeInsets.only(top: size.height * 0.02),
        //     //   decoration: const BoxDecoration(
        //     //     color: kDarkBlue,
        //     //     borderRadius: BorderRadius.only(
        //     //       bottomLeft: Radius.circular(30),
        //     //       bottomRight: Radius.circular(30),
        //     //     ),
        //     //   ),
        //     // ),
        //     Padding(
        //       padding: const EdgeInsets.all(20.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             "Pending Requests",
        //             style: TextStyle(
        //               fontFamily: 'SourceSansPro-SemiBold',
        //               fontSize: 20,
        //             ),
        //             textAlign: TextAlign.center,
        //           ),
        //           Text(
        //             "View all",
        //             style: TextStyle(
        //               fontFamily: 'SourceSansPro-SemiBold',
        //               fontSize: 15,
        //               color: kPurple,
        //             ),
        //             textAlign: TextAlign.center,
        //           ),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Container(
        //         margin: EdgeInsets.symmetric(horizontal: size.height * 0.02),
        //         padding: EdgeInsets.only(top: size.height * 0.02),
        //         decoration: const BoxDecoration(
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.grey, //New
        //               blurRadius: 1.0,
        //             )
        //           ],
        //           color: Colors.white,
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(10),
        //             topRight: Radius.circular(10),
        //           ),
        //         ),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 Text(
        //                   "Name",
        //                   style: TextStyle(
        //                     fontFamily: 'SourceSansPro-Regular',
        //                     fontSize: 20,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 Text(
        //                   "Vendor Id",
        //                   style: TextStyle(
        //                     fontFamily: 'SourceSansPro-Regular',
        //                     fontSize: 20,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 Text(
        //                   "Status",
        //                   style: TextStyle(
        //                     fontFamily: 'SourceSansPro-Regular',
        //                     fontSize: 20,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ],
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 20, vertical: 10),
        //               child: Divider(
        //                 thickness: 1,
        //                 color: Colors.grey,
        //               ),
        //             ),
        //             Container(
        //               height: 300,
        //               child: ListView.builder(
        //                 // shrinkWrap: true,
        //                 // physics: const NeverScrollableScrollPhysics(),
        //                 itemCount: Provider.of<ProductProvider>(context)
        //                     .requestList
        //                     .length,
        //                 itemBuilder: (context, index) {
        //                   return ListTile(
        //                       // leading: Icon(Icons.list),
        //                       trailing: Text(
        //                         Provider.of<ProductProvider>(context)
        //                             .requestList[index]
        //                             .id,
        //                         style:
        //                             TextStyle(color: Colors.green, fontSize: 15),
        //                       ),
        //                       title: Text(Provider.of<ProductProvider>(context)
        //                           .requestList[index]
        //                           .name));
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
