import 'package:easy_shaadi/View/Admin%20Pages/admin_home_page.dart';
import 'package:easy_shaadi/View/Admin%20Pages/user_detail_page.dart';
import 'package:easy_shaadi/View/Admin%20Pages/vendor_request_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  List screens = const [
    AdminHomePage(),
    VendorRequestPage(),
    UserDetailPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurpleAccent,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (indexValue) {
            setState(() {
              currentIndex = indexValue;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Vendors'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
          ]),
      // body: ListView(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(
      //           horizontal: kDefaultPadding, vertical: kDefaultPadding),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: const [
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
      //     StreamBuilder<QuerySnapshot>(
      //       stream: FirebaseFirestore.instance
      //           .collection('Vendor Requests')
      //           .where('RequestStatus', isEqualTo: 'waiting')
      //           .snapshots(),
      //       builder: (BuildContext context,
      //           AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasError) {
      //           return const Text('Something went wrong');
      //         }
      //
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //             child: CircularProgressIndicator(
      //               valueColor: AlwaysStoppedAnimation<Color>(
      //                   Theme.of(context).primaryColor),
      //             ),
      //           );
      //         }
      //
      //         return SizedBox(
      //           // height: size.height * 0.21,
      //           child: ListView.separated(
      //             separatorBuilder: (context, index) => const SizedBox(
      //               width: 10,
      //             ),
      //             physics: const ClampingScrollPhysics(),
      //             shrinkWrap: true,
      //             scrollDirection: Axis.vertical,
      //             itemCount: snapshot.data!.docs.length,
      //             itemBuilder: (context, index) {
      //               var data = snapshot.data?.docs[index];
      //               return Padding(
      //                 padding: EdgeInsets.all(5),
      //                 child: ListTile(
      //                   tileColor: Colors.white,
      //                   leading: CircleAvatar(
      //                     backgroundColor: kPink,
      //                     child: Text(
      //                       data!['Name'].toString().toTitleCase()[0],
      //                       style: const TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                   title: Text(
      //                     data['Name'].toString().toTitleCase(),
      //                     style: const TextStyle(
      //                         fontSize: 18.0, fontWeight: FontWeight.bold),
      //                   ),
      //                   subtitle: Text(
      //                     data['Email'].toString().toTitleCase(),
      //                     style: const TextStyle(fontSize: 14.0),
      //                   ),
      //                   trailing: const Icon(
      //                     Icons.arrow_forward,
      //                     color: Colors.grey,
      //                   ),
      //                   onTap: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (context) =>
      //                               VendorDetailsPage(userData: data)),
      //                     );
      //                   },
      //                 ),
      //               );
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // )

      // body: Column(
      //   children: [
      //     Container(
      //       margin: const EdgeInsets.all(kDefaultPadding),
      //       padding: const EdgeInsets.all(kDefaultPadding),
      //       decoration: const BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey, //New
      //             blurRadius: 1.0,
      //           )
      //         ],
      //         color: Colors.white,
      //         borderRadius: BorderRadius.all(
      //           Radius.circular(10),
      //         ),
      //       ),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: const [
      //           Text(
      //             'Vendor Requests',
      //             style: TextStyle(fontSize: 18.0),
      //           ),
      //         ],
      //       ),
      //     ),
      //     SizedBox(
      //       height: kDefaultPadding,
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
      //           borderRadius: BorderRadius.all(
      //             Radius.circular(10),
      //           ),
      //         ),
      //         child: null,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
// Expanded(
//   child: Container(
//     margin: EdgeInsets.symmetric(horizontal: size.height * 0.02),
//     padding: EdgeInsets.only(top: size.height * 0.02),
//     decoration: const BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey, //New
//           blurRadius: 1.0,
//         )
//       ],
//       color: Colors.white,
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10),
//         topRight: Radius.circular(10),
//       ),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //   children: [
//         //     Text(
//         //       "Name",
//         //       style: TextStyle(
//         //         fontFamily: 'SourceSansPro-Regular',
//         //         fontSize: 20,
//         //       ),
//         //       textAlign: TextAlign.center,
//         //     ),
//         //     Text(
//         //       "Vendor Id",
//         //       style: TextStyle(
//         //         fontFamily: 'SourceSansPro-Regular',
//         //         fontSize: 20,
//         //       ),
//         //       textAlign: TextAlign.center,
//         //     ),
//         //     Text(
//         //       "Status",
//         //       style: TextStyle(
//         //         fontFamily: 'SourceSansPro-Regular',
//         //         fontSize: 20,
//         //       ),
//         //       textAlign: TextAlign.center,
//         //     ),
//         //   ],
//         // ),
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(
//         //       horizontal: 20, vertical: 10),
//         //   child: Divider(
//         //     thickness: 1,
//         //     color: Colors.grey,
//         //   ),
//         // ),
//         Container(
//           height: 200,
//           child: ListView.builder(
//             // shrinkWrap: true,
//             // physics: const NeverScrollableScrollPhysics(),
//             itemCount: 0,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 20,
//                 height: 20,
//                 color: Colors.red,
//               );
//               // return ListTile(
//               //     // leading: Icon(Icons.list),
//               //     trailing: Text(
//               //       Provider.of<ProductProvider>(context)
//               //           .requestList[index]
//               //           .id,
//               //       style:
//               //           TextStyle(color: Colors.green, fontSize: 15),
//               //     ),
//               //     title: Text(Provider.of<ProductProvider>(context)
//               //         .requestList[index]
//               //         .name));
//             },
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
