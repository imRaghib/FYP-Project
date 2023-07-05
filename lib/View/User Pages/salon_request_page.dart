import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:easy_shaadi/View/customerMainPage.dart';
import 'package:easy_shaadi/ViewModel/Customer/venue_request_provider.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:easy_shaadi/payment_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class SolonAppointmentPage extends StatefulWidget {
  final imageUrlList;
  final title;
  final address;
  final description;
  final venuePrice;
  final contact;
  final inactiveDates;
  final vendorUID;
  final venueId;
  final selectedPackage;

  SolonAppointmentPage({
    super.key,
    this.imageUrlList,
    this.title,
    this.address,
    this.description,
    this.venuePrice,
    this.contact,
    this.inactiveDates,
    this.vendorUID,
    this.venueId,
    this.selectedPackage,
  });

  @override
  State<SolonAppointmentPage> createState() => _SolonAppointmentPageState();
}

class _SolonAppointmentPageState extends State<SolonAppointmentPage> {
  final double kDefaultTitle = 22;
  final double kDefaultText = 17;

  int guests = 100;
  int count = 100;
  final int platformFee = 5000;
  int total = 0;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 90));

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  List<DateTime> inActiveDates = [
    DateTime.now()
        .add(const Duration(days: 90)), // because it does not allow empty list
  ];

  final today = DateUtils.dateOnly(DateTime.now());
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getCustomerDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Request Appointment",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHallDetails(size),
            buildSizedBox(),
            buildYourBooking(context, size, selectedDates),
            buildSizedBox(),
            buildPriceDetails(context),
            buildSizedBox(),
            buildMessageHost(),
            buildSizedBox(),
            buildPayWith(),
            buildSizedBox(),
          ],
        ),
      ),
    );
  }

  Container buildMessageHost() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.calendar_today_rounded),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: kDefaultPadding),
                    child: Text(
                      "Let the host know about your booking, to avoid any future complications.",
                      style: TextStyle(
                          fontSize: kDefaultText,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Message'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildPayWith() {
    ProductProvider customerDetails = Provider.of<ProductProvider>(context);
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Pay with",
              style: TextStyle(
                fontSize: kDefaultTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
            GooglePayButton(
              paymentConfiguration:
                  PaymentConfiguration.fromJsonString(defaultGooglePay),
              paymentItems: [
                PaymentItem(
                    label: widget.title,
                    amount: returnTotal().toString(),
                    status: PaymentItemStatus.final_price),
              ],
              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) {
                debugPrint("Results: ${result.toString()}");
                try {
                  // bookVenue(
                  //   customerName: customerDetails.customer.Name,
                  //   bookingDate: selectedDate.toString(),
                  //   vendorUID: widget.vendorUID,
                  //   venueId: widget.venueId,
                  //   customerUID: FirebaseAuth.instance.currentUser!.uid,
                  // );

                  bookVenue(
                    payment: total,
                    venueId: widget.venueId,
                    vendorUID: widget.vendorUID,
                    bookingDate: selectedDate.toString(),
                    customerName: customerDetails.customer.Name,
                    customerEmail: customerDetails.customer.Email,
                  );

                  updatePayments(vendorUID: widget.vendorUID, payment: total);

                  updateVenueDate(
                      venueId: widget.venueId,
                      bookingDate: selectedDate.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerMainPage(),
                    ),
                  );
                } catch (error) {
                  debugPrint("Payment request Error: ${error.toString()}");
                }
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (error) {
                debugPrint("Payment Error: ${error.toString()}");
              },
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 15,
    );
  }

  Container buildPriceDetails(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Price details",
              style: TextStyle(
                fontSize: kDefaultTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
            buildSizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Package",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: kDefaultText,
                  ),
                ),
                Text(
                  "${money.format(widget.selectedPackage)} PKR",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: kDefaultText,
                  ),
                ),
              ],
            ),
            buildSizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Platform service fee",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: kDefaultText,
                  ),
                ),
                Text(
                  "${money.format(platformFee)} PKR",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: kDefaultText,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total (PKR)",
                  style: TextStyle(
                    fontSize: kDefaultTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${money.format(returnTotal())} PKR",
                  style: TextStyle(
                    fontSize: kDefaultTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         showModalBottomSheet(
            //             context: context,
            //             builder: (BuildContext context) {
            //               return Container();
            //             });
            //       },
            //       style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //       ),
            //       child: Text(
            //         "More Info",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: kDefaultText,
            //             fontWeight: FontWeight.w500,
            //             decoration: TextDecoration.underline),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Container buildYourBooking(
      BuildContext context, Size size, DateTimeRange selectedDates) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Your Booking",
              style: TextStyle(
                fontSize: kDefaultTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
            buildSizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    getDates(); // this to update datetime object from string back to its object
                    showModalBottomSheet(
                        backgroundColor: Colors.white.withOpacity(0),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            height: size.height * 0.40,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPadding / 2),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                        ),
                                      ),
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: kDefaultText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kDefaultPadding),
                                  child: DatePicker(
                                    height: size.height * 0.26,
                                    DateTime.now(),
                                    daysCount: 30,
                                    inactiveDates: inActiveDates,
                                    initialSelectedDate: selectedDate,
                                    deactivatedColor:
                                        Colors.black.withOpacity(0.2),
                                    selectionColor: Colors.black,
                                    selectedTextColor: Colors.white,
                                    onDateChange: (date) {
                                      setState(() {
                                        selectedDate = date;
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            Text(
              formatDate(),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: kDefaultText,
              ),
            ),
            buildSizedBox(),
          ],
        ),
      ),
    );
  }

  getDates() {
    for (int index = 0; index < widget.inactiveDates.length; index++) {
      inActiveDates.add(DateTime.parse(widget.inactiveDates[index]));
    }
  }

  Container buildHallDetails(Size size) {
    return Container(
      height: size.height * 0.15,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    color: Color(0xFFdce2f7),
                    child: Image.network(
                      widget.imageUrlList,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  returnTotal() {
    total = widget.selectedPackage + platformFee;
    return total;
  }

  formatDate() {
    return DateFormat.yMMMEd().format(selectedDate).toString();
  }

  Widget buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
      firstDate: DateTime.now(),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Multi Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          value: _multiDatePickerValueWithDefaultValue,
          onValueChanged: (dates) => setState(
            () {
              _multiDatePickerValueWithDefaultValue = dates;

              List<DateTime> filter(List<DateTime?> input) {
                input.removeWhere((e) => e == null);
                return List<DateTime>.from(input);
              }

              List<DateTime> filteredList =
                  filter(_multiDatePickerValueWithDefaultValue);
              inActiveDates = filteredList;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
