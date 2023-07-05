import 'package:easy_shaadi/Model/Messenger%20Models/dialogs.dart';
import 'package:easy_shaadi/ViewModel/Messenger%20Class/apis.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  String name = 'Raghib Ahmed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            const Text("Customer Information"),
            Text("Name: ${widget.customerName}"),
            Text("Booking Date: ${formatDate(widget.bookingDate ?? " ")}"),
            ListView.separated(
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.menuMap.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                String key = widget.menuMap.keys.elementAt(index);
                int value = widget.menuMap[key];
                return Container(
                  decoration: BoxDecoration(
                    color: kPink.withAlpha(50),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Chosen Menu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ExpandableText(
                          key,
                          expandText: '\n\nShow More',
                          collapseText: '\n\nShow Less',
                          maxLines: 6,
                          linkColor: kPurple,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kPink.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text(
                            "Rs. $value",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  print(widget.customerEmail);
                  if (widget.customerEmail.isNotEmpty) {
                    await APIs.addChatUser(widget.customerEmail).then((value) {
                      if (!value) {
                        Dialogs.showSnackbar(context, 'User does not Exists!');
                      }
                    });
                  }
                },
                child: Text("Message"))
          ],
        ),
      ),
    );
  }
}
