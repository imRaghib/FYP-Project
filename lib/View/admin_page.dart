import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/ViewModel/signout.dart';
import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: kBackgroundColor,
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
      body: null,
      // body: Column(
      //   children: [
      //     Container(
      //       height: size.height * 0.40,
      //       // margin: EdgeInsets.only(bottom: size.height * 0.72),
      //       // padding: EdgeInsets.only(top: size.height * 0.02),
      //       decoration: const BoxDecoration(
      //         color: kDarkBlue,
      //         borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(30),
      //           bottomRight: Radius.circular(30),
      //         ),
      //       ),
      //     ),
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
      //                       leading: Icon(Icons.list),
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
      //             ElevatedButton(
      //                 onPressed: () {
      //                   signout();
      //                   Navigator.pushNamedAndRemoveUntil(
      //                       context, 'StreamPage', (route) => false);
      //                 },
      //                 child: Text('Signout'))
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
