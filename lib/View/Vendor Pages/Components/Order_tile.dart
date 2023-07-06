// import 'package:flutter/material.dart';
// class OrderTile extends StatelessWidget {
//   OrderTile();
//   final producName;
//   final
//   final orderDate;
//   final buyerName;
//
//   @override
//   Widget build(BuildContext context) {
//     return const ListTile(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     BookingDetailPage(
//                       menuMap: venueData['menus'],
//                       customerName: buyerName,
//                       bookingDate: orderDate,
//                       customerEmail: customerEmail,
//                     )));
//       },
//       tileColor: Colors.white,
//       leading: AspectRatio(
//         aspectRatio: 4 / 3,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10),
//           ),
//           child: Image.network(
//             venueData!['venueImages'][0],
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       title: Text("Venue: ${venueData['venueName']}"),
//       subtitle: Text(
//           '$customerName has booked this venue.\nDate: ${formatDate(bookingDate ?? " ")}'),
//       trailing: const Icon(Icons.touch_app),
//     );
//   }
// }
