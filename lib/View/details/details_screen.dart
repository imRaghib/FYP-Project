import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/booking_request_page.dart';
import 'package:easy_shaadi/View/details/components/bottom_buttons.dart';
import 'package:easy_shaadi/View/details/components/custom_app_bar.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/Messenger Models/chat_user.dart';
import '../../ViewModel/Messenger Class/apis.dart';
import '../Messenger Screens/chat_screen.dart';
import '../User Pages/vendor_profile.dart';

class DetailsScreen extends StatefulWidget {
  final imageUrlList;
  final title;
  final address;
  final description;
  final price;
  final isFav;
  final contact;
  final inactiveDates;
  final vendorUID;
  final venueId;
  final menuMap;
  final email;
  final parking;
  final capacity;

  DetailsScreen(
      {super.key,
      this.imageUrlList,
      this.title,
      this.address,
      this.description,
      this.price,
      this.isFav,
      this.contact,
      this.inactiveDates,
      this.vendorUID,
      this.venueId,
      this.menuMap,
      this.email,
      this.parking,
      this.capacity});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int activeIndex = 0;
  int cost = 0;
  int? selectedCheckboxIndex;
  Map<String, int>? selectedMenu;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final money = NumberFormat("#,##0", "en_US");

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.imageUrlList.length,
                    itemBuilder:
                        (BuildContext context, index, int pageViewIndex) {
                      final imageUrl = widget.imageUrlList[index];
                      return buildImage(imageUrl, index);
                    },
                    options: CarouselOptions(
                        height: size.height * 0.45,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.43),
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: appPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Rs. ${money.format(widget.price)}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '   per Person',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: black.withOpacity(0.6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.address,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: black.withOpacity(0.4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: kDefaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Venue information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              vendorUID: widget.vendorUID)),
                                    );
                                  },
                                  child: const Text("View Profile")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: kDefaultPadding,
                          ),
                          child: ExpandableText(
                            widget.description,
                            expandText: '\nShow More',
                            collapseText: '\nShow Less',
                            maxLines: 4,
                            linkColor: kPurple,
                            style: TextStyle(
                              color: black.withOpacity(0.4),
                              height: 1.5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: kPurple.withOpacity(0.2),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Venue Features',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPurple,
                              ),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Venue Capacity",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    int.parse(widget.capacity
                                            .toString()
                                            .split('.')[0])
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPurple,
                              ),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Car Parking",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    int.parse((widget.parking)
                                            .toString()
                                            .split('.')[0])
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: kPurple.withOpacity(0.2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Choose Your Menu",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kPink.withOpacity(0.4),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: const Text(
                                "Required",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: kPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Select one",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kPurple,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.menuMap.length != null
                            ? ListView.separated(
                                physics: const PageScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.menuMap.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemBuilder: (BuildContext context, int index) {
                                  String menuKey =
                                      widget.menuMap.keys.elementAt(index);
                                  int value = widget.menuMap[menuKey];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: kPink.withAlpha(50),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(kDefaultPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Menu',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Radio(
                                                  value: index,
                                                  groupValue:
                                                      selectedCheckboxIndex,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      selectedCheckboxIndex =
                                                          value!;
                                                      cost = widget
                                                          .menuMap[menuKey];
                                                      selectedMenu = {
                                                        menuKey: cost
                                                      };
                                                    });
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ExpandableText(
                                            menuKey,
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
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
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
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding + 5),
                          child: Divider(
                            thickness: 2,
                            color: kPurple.withOpacity(0.2),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: kDefaultPadding),
                          child: Text(
                            'Contact Seller',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        BottomButtons(
                          contact: widget.contact,
                          email: widget.email,
                          vendorId: widget.vendorUID,
                        ),
                        const SizedBox(
                          height: 110,
                        )
                      ],
                    ),
                  ),
                  buildIndicator(),
                  CustomAppBar(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(),
                  ),
                ),
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "You Selected",
                          style: TextStyle(),
                        ),
                        Text(
                          "Rs. $cost per Person",
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                      child: InkWell(
                        onTap: () {
                          selectedMenu == null
                              ? Fluttertoast.showToast(
                                  msg: 'Please select a Menu!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  fontSize: 15,
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingPage(
                                      imageUrlList: widget.imageUrlList[0],
                                      title: widget.title,
                                      address: widget.address,
                                      description: widget.description,
                                      venuePrice: widget.price,
                                      contact: widget.contact,
                                      inactiveDates: widget.inactiveDates,
                                      vendorUID: widget.vendorUID,
                                      venueId: widget.venueId,
                                      perPerson: cost,
                                      selectedMenu: selectedMenu,
                                      email: widget.email,
                                      capacity: widget.capacity,
                                    ),
                                  ),
                                );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kPink.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Text(
                            "   Reserve   ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl, int index) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() => Positioned(
        left: 0,
        right: 0,
        top: MediaQuery.of(context).size.height * 0.39,
        child: Align(
          alignment: AlignmentDirectional.topCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: widget.imageUrlList.length,
            effect: JumpingDotEffect(
                dotHeight: 14,
                dotWidth: 14,
                dotColor: Colors.white.withOpacity(0.6),
                activeDotColor: kPurple),
          ),
        ),
      );
}

late ChatUser me;

class BottomButtons extends StatelessWidget {
  const BottomButtons(
      {required this.contact, required this.email, required this.vendorId});

  final String contact;
  final String email;
  final String vendorId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            APIs.addChatUser(email);
            await FirebaseFirestore.instance
                .collection('Accounts')
                .doc(vendorId)
                .get()
                .then((user) async {
              if (user.exists) {
                me = ChatUser.fromJson(user.data()!);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ChatScreen(user: me)));
              }
            });
          },
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.mail_rounded),
                  color: white,
                ),
                Text(
                  ' Message',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _launchTel,
          child: Container(
            width: size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
              color: kPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  (Icons.call_rounded),
                  color: white,
                ),
                Text(
                  ' Call',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchTel() async {
    if (!await launchUrl(Uri.parse("tel:$contact"))) {
      throw Exception('Could not launch $contact');
    }
  }
}
