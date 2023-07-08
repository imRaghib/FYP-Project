import 'package:easy_shaadi/Model/Messenger%20Models/dialogs.dart';
import 'package:easy_shaadi/ViewModel/Messenger%20Class/apis.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatefulWidget {
  final menuMap;
  final customerName;
  final bookingDate;
  final customerEmail;

  BookingDetailPage({
    this.menuMap,
    this.customerName,
    this.bookingDate,
    this.customerEmail,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

formatDate(String date) {
  return date.substring(0, date.indexOf(' '));
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  // String name = 'Raghib Ahmed';
  final double kDefaultTitle = 22;
  final double kDefaultText = 17;
  bool status = false;

  @override
  Widget build(BuildContext context) {
    Divider buildDivider() {
      return Divider(
        thickness: 1,
        color: kPurple.withOpacity(0.2),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Booking Details"),
        ),
        body: ListView(
          children: [
            SwitchListTile(
                title: const Text(
                  'Booking Confirmed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                value: status,
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                  // value = true;
                }),
            buildDivider(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Summary",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            "Booking number: 5357889",
                          ),
                          Text("Booking time: 7/7/2023"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer Name: ${widget.customerName}"),
                          const SizedBox(height: 10),
                          Text("Customer Email: ${widget.customerEmail}"),
                          const SizedBox(height: 10),
                          // Text("Venue Booked On: ${widget.date}"),
                          const SizedBox(height: 10),
                          Text("Expect Guests: 100"),
                          const SizedBox(height: 10),
                          Text("Selected Menu: "),
                          // SizedBox(
                          //   height: 200,
                          //   child: ListView.separated(
                          //     physics: PageScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemCount: widget.menuMap.length,
                          //     separatorBuilder:
                          //         (BuildContext context, int index) =>
                          //             const Divider(),
                          //     itemBuilder: (BuildContext context, int index) {
                          //       String key =
                          //           widget.menuMap.keys.elementAt(index);
                          //       int value = widget.menuMap[key];
                          //       return Container(
                          //         decoration: BoxDecoration(
                          //           color: kPink.withAlpha(50),
                          //           borderRadius: const BorderRadius.all(
                          //               Radius.circular(15)),
                          //         ),
                          //         child: Padding(
                          //           padding:
                          //               const EdgeInsets.all(kDefaultPadding),
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.stretch,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             children: [
                          //               const Text(
                          //                 'Chosen Menu',
                          //                 style: TextStyle(
                          //                   fontSize: 20,
                          //                   fontWeight: FontWeight.w500,
                          //                 ),
                          //               ),
                          //               const SizedBox(
                          //                 height: 10,
                          //               ),
                          //               ExpandableText(
                          //                 key,
                          //                 expandText: '\n\nShow More',
                          //                 collapseText: '\n\nShow Less',
                          //                 maxLines: 6,
                          //                 linkColor: kPurple,
                          //               ),
                          //               const SizedBox(
                          //                 height: 20,
                          //               ),
                          //               Container(
                          //                 padding: const EdgeInsets.all(10),
                          //                 decoration: BoxDecoration(
                          //                   color: kPink.withOpacity(0.4),
                          //                   borderRadius:
                          //                       const BorderRadius.all(
                          //                           Radius.circular(15)),
                          //                 ),
                          //                 child: Text(
                          //                   "Rs. $value",
                          //                   style: const TextStyle(
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.w700,
                          //                     color: kPurple,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          ElevatedButton(
                              onPressed: () async {
                                print(widget.customerEmail);
                                if (widget.customerEmail.isNotEmpty) {
                                  await APIs.addChatUser(widget.customerEmail)
                                      .then((value) {
                                    if (!value) {
                                      Dialogs.showSnackbar(
                                          context, 'User does not Exists!');
                                    }
                                  });
                                }
                              },
                              child: Text("Message"))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
        // body: Padding(
        //   padding: const EdgeInsets.all(kDefaultPadding),
        //   child: Column(
        //     children: [
        //       const Text("Customer Information"),
        //       Text("Name: ${widget.customerName}"),
        //       Text("Booking Date: ${formatDate(widget.bookingDate ?? " ")}"),
        //
        //
        //     ],
        //   ),
        // ),
        );
  }
}
