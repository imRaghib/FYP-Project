import 'dart:io';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_shaadi/Model/bookings.dart';
import 'package:easy_shaadi/ViewModel/Vendor/venue_provider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';

class VendorListingPage extends StatefulWidget {
  const VendorListingPage({Key? key}) : super(key: key);

  @override
  State<VendorListingPage> createState() => _VendorListingPageState();
}

class _VendorListingPageState extends State<VendorListingPage> {
  void dispose() {
    menuDesController.dispose();
    menuCostController.dispose();
    super.dispose();
  }

  final menuFormKey = GlobalKey<FormState>();
  Map<String, int> menuMap = {};
  int cost = 0;
  String menu = '';
  TextEditingController menuDesController = TextEditingController();
  TextEditingController menuCostController = TextEditingController();
  List<String> inActiveDates = [];

  final today = DateUtils.dateOnly(DateTime.now());
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  List<String> temp = [];

  String imageUrl = "";

  double capacity = 0;
  double parking = 0;
  List<String> cityList = ['Lahore', 'Islamabad', 'Jhelum', 'Sheikhupura'];
  String venueLocation = 'Location';
  Booking venueModel = Booking();
  final formKey = GlobalKey<FormState>();

  List<String> listOfUrls = [];
  File? image;
  final imagePicker = ImagePicker();
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             title: Text(
          //               "Are you sure you want to leave?",
          //               style: TextStyle(fontSize: 18),
          //             ),
          //           );
          //         });
          //   },
          //   icon: Icon(Icons.arrow_back),
          // ),
          ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildAddPhotos(context),
              buildDivider(),
              buildLocation(context),
              buildDivider(),
              buildVenueName(),
              buildVenueDes(),
              buildPrice(),
              buildAddress(),
              buildCapacitySlider(),
              buildParkingSlider(),
              buildDates(context),
              buildMenus(context),
              buildContactInfo(),
              buildName(),
              buildNumber(),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildMenus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white.withOpacity(0),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setModalState) =>
                            Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: SingleChildScrollView(
                        // physics: ScrollPhysics(),
                        child: Form(
                          key: menuFormKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: kPink.withAlpha(40),
                                      radius: 20,
                                      child: const Icon(
                                        size: 25,
                                        color: Colors.black,
                                        Icons.description,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: menuDesController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          hintText: "Tell us about your menu",
                                          labelText: "Menu Description",
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kPink),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kPurple),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !RegExp(r"^[\w\s.,!?@#$%^&*()-]+$")
                                                  .hasMatch(value)) {
                                            return "Add Your Menu";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) =>
                                            setState(() => menu = value!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: kPink.withAlpha(40),
                                      radius: 20,
                                      child: Icon(
                                        size: 30,
                                        color: kPurple,
                                        Icons.attach_money,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: menuCostController,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              color: kPurple.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                          hintText:
                                              "Cost of this menu per person",
                                          labelText: "Cost For Each",
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kPink),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kPurple),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !RegExp(r"^[0-9]+$")
                                                  .hasMatch(value)) {
                                            return "Enter Cost";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (value) => setState(
                                            () => cost = int.parse(value!)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 15.0,
                                    right: 15.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        print('pressed');
                                        if (menuFormKey.currentState!
                                            .validate()) {
                                          menuFormKey.currentState!.save();

                                          setModalState(() {
                                            menuMap[menu] = cost;
                                          });
                                          menuDesController.clear();
                                          menuCostController.clear();
                                        }
                                      },
                                      child: Text(
                                        "Add",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kPurple),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.separated(
                                physics: PageScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: menuMap.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemBuilder: (BuildContext context, int index) {
                                  String key = menuMap.keys.elementAt(index);
                                  int? value = menuMap[key];
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
                                              IconButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    menuMap.remove(key);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: kPurple,
                                                ),
                                              ),
                                            ],
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
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Text(
                                              "Rs. $value",
                                              style: TextStyle(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text("Add Menus"),
            style: ElevatedButton.styleFrom(backgroundColor: kPurple),
          ),
        ],
      ),
    );
  }

  Padding buildDates(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<dynamic>(
                backgroundColor: Colors.white.withOpacity(0),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setModalState) =>
                            Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: buildDefaultMultiDatePickerWithValue(),
                    ),
                  );
                },
              );
            },
            child: Text("Select Non Active Dates"),
            style: ElevatedButton.styleFrom(backgroundColor: kPurple),
          ),
        ],
      ),
    );
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
        const Text('Select Dates On Which Your Venue Is Not Available'),
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

              List<String> DateTimeListAsString =
                  filteredList.map((data) => data.toString()).toList();
              inActiveDates = DateTimeListAsString;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Padding buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 30.0, bottom: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate() ||
                  venueLocation != 'Location' ||
                  image != null) {
                formKey.currentState!.save();

                // venueModel.venueName = vendorName!;
                venueModel.venueCapacity = capacity;
                venueModel.venueParking = parking;

                try {
                  VenueProvider().addVenueData(
                    venueLocation: venueLocation,
                    venueName: venueModel.venueName,
                    venuePrice: venueModel.venuePrice,
                    venueDescription: venueModel.venueDescription,
                    venueAddress: venueModel.venueAddress,
                    venueCapacity: venueModel.venueCapacity,
                    venueParking: venueModel.venueParking,
                    venueImages: listOfUrls,
                    venueRating: 0,
                    venueFeedback: 0,
                    vendorNumber: venueModel.vendorNumber,
                    inActiveDates: inActiveDates,
                    menus: menuMap,
                  ); // default value change later
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'StreamPage', (route) => false);
                } catch (e) {
                  print(e);
                }
              }
            },
            child: Text("Submit"),
            style: ElevatedButton.styleFrom(backgroundColor: kPurple),
          ),
        ],
      ),
    );
  }

  Padding buildAddPhotos(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: image == null
          ? DottedBorder(
              color: Colors.black,
              strokeWidth: 2,
              dashPattern: [8, 4],
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.white.withOpacity(0),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Upload Photos",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: kPurple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: getImage,
                                      // onTap: ()async {
                                      //   ImagePicker imagePicker = ImagePicker();
                                      //
                                      //   // String uniqueFileName = DateTime.now()
                                      //   //     .millisecondsSinceEpoch
                                      //   //     .toString();
                                      //   //
                                      //   XFile? pickedFile = await imagePicker.pickImage(
                                      //       source: ImageSource.camera);
                                      //   setState(() {
                                      //     if (pickedFile != null) {
                                      //       image = File(pickedFile.path);
                                      //     } else {
                                      //       print('no image selected');
                                      //     }
                                      //   });
                                      //   // if (file == null) return;
                                      //   //
                                      //   // Reference referenceRoot =
                                      //   //     FirebaseStorage.instance.ref();
                                      //   // Reference referenceDirImages =
                                      //   //     referenceRoot.child('images');
                                      //   // Reference referenceImageToUpload =
                                      //   //     referenceDirImages.child(uniqueFileName);
                                      //   //
                                      //   // try {
                                      //   //   await referenceImageToUpload
                                      //   //       .putFile(File(file.path));
                                      //   //   imageUrl = await referenceImageToUpload
                                      //   //       .getDownloadURL();
                                      //   // } catch (error) {
                                      //   //   print(
                                      //   //       "Error MESSAGE=================${error}");
                                      //   // }
                                      // },
                                      child: Card(
                                        elevation: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.photo_camera,
                                              color: kPurple,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Take photos with camera",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        ImagePicker imagePicker = ImagePicker();

                                        String uniqueFileName = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();

                                        XFile? file =
                                            await imagePicker.pickImage(
                                                source: ImageSource.gallery);

                                        if (file == null) return;

                                        Reference referenceRoot =
                                            FirebaseStorage.instance.ref();
                                        Reference referenceDirImages =
                                            referenceRoot.child('images');
                                        Reference referenceImageToUpload =
                                            referenceDirImages
                                                .child(uniqueFileName);

                                        try {
                                          await referenceImageToUpload
                                              .putFile(File(file.path));
                                          imageUrl =
                                              await referenceImageToUpload
                                                  .getDownloadURL();
                                        } catch (error) {
                                          print(
                                              "Error MESSAGE=================${error}");
                                        }
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              color: kPurple,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Upload photos from gallery",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                      height: 150,
                      width: double.infinity,
                      color: kPink.withAlpha(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 35,
                            color: Colors.grey,
                            Icons.camera_alt_outlined,
                          ),
                          Text('Add Photo'),
                        ],
                      ))),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height * 0.15,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 5,
                    ),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listOfUrls.length,
                    itemBuilder: (context, index) => SizedBox(
                      width: size.width * 0.35,
                      child: Stack(
                        children: [
                          AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.network(
                                listOfUrls[index],
                                fit: BoxFit.cover,
                              )),

                          // Positioned(
                          //   bottom: 10,
                          //   child: IconButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           isUploading = true;
                          //           uploadFile().then((url) {
                          //             if (url != null) {
                          //               setState(() {
                          //                 isUploading = false;
                          //               });
                          //             }
                          //           });
                          //         });
                          //       },
                          //       icon: Icon(Icons.turn_right_outlined)),
                          // ),
                          IconButton(
                              onPressed: () {
                                try {
                                  FirebaseStorage.instance
                                      .refFromURL(listOfUrls[index])
                                      .delete();
                                } catch (error) {
                                  print(
                                      "Error MESSAGE=================${error}");
                                }
                                setState(() {
                                  listOfUrls.removeAt(index);
                                });
                                // print(imageUrl);
                                // listOfUrls.remove(imageUrl);
                                // print("after removing $listOfUrls");
                              },
                              icon: Icon(Icons.clear)),
                          if (isUploading)
                            Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: getImage,
                    child: Text("Add More Photos"),
                    style: ElevatedButton.styleFrom(backgroundColor: kPurple),
                  ),
                ),
              ],
            ),
    );
  }

  Padding buildNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.black,
              Icons.numbers,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              decoration: InputDecoration(
                labelText: "Mobile Number",
                hintText: "Enter Mobile Number",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d{11}$").hasMatch(value)) {
                  return "Enter Number eg: 0333";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => venueModel.vendorNumber = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 25,
              color: Colors.black,
              Icons.perm_contact_cal_sharp,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: vendorName?.toUpperCase(),
              ),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              decoration: const InputDecoration(
                labelText: "Name",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildParkingSlider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPink.withAlpha(40),
                radius: 20,
                child: Icon(
                  size: 25,
                  color: Colors.black,
                  Icons.local_parking,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                "Venue Parking",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: kPink.withAlpha(100),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  height: 30,
                  width: 80,
                  child: Center(
                    child: Text(
                      parking.round().toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Slider(
              activeColor: kPurple,
              inactiveColor: kPink,
              value: parking,
              max: 200,
              divisions: 10,
              label: parking.round().toString(),
              onChanged: (newParking) {
                setState(() {
                  parking = newParking;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCapacitySlider() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPink.withAlpha(40),
                radius: 20,
                child: Icon(
                  size: 25,
                  color: Colors.black,
                  Icons.people,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                "Venue Capacity",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: kPink.withAlpha(100),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  height: 30,
                  width: 80,
                  child: Center(
                    child: Text(
                      capacity.round().toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Slider(
              activeColor: kPurple,
              inactiveColor: kPink,
              value: capacity,
              max: 1000,
              divisions: 10,
              label: capacity.round().toString(),
              onChanged: (newCapacity) {
                setState(() {
                  capacity = newCapacity;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.black,
              Icons.add_location_alt,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Venue Address",
                labelText: "Address",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Address";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => venueModel.venueAddress = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 30,
              color: Colors.black,
              Icons.attach_money,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Price for booking the venue",
                labelText: "Price",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^\d+$").hasMatch(value)) {
                  return "Enter Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(
                () => venueModel.venuePrice = int.parse(value!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildVenueDes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.black,
              Icons.description,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Tell us about your venue",
                labelText: "Description",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[\w\s.,!?@#$%^&*()-]+$").hasMatch(value)) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => venueModel.venueDescription = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildVenueName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 25,
              color: Colors.black,
              Icons.add_business,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Venue Name",
                labelText: "Venue",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                  return "Enter Venue Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => venueModel.venueName = value!),
            ),
          ),
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
      color: kPurple.withOpacity(0.2),
    );
  }

  GestureDetector buildLocation(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white.withOpacity(0),
          context: context,
          builder: (BuildContext context) {
            return Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Select City'),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: cityList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                venueLocation = cityList[index];
                              });
                              Navigator.pop(context);
                            },
                            child: ListTile(
                              title: Text(cityList[index]),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ));
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kPink.withAlpha(40),
          radius: 20,
          child: Icon(
            size: 25,
            color: Colors.black,
            Icons.location_on,
          ),
        ),
        title: Text(venueLocation),
        trailing: Icon(
          size: 25,
          color: Colors.black,
          Icons.keyboard_arrow_down_outlined,
        ),
      ),
    );
  }

  Future getImage() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        // Navigator.pop(context);
        setState(() {
          isUploading = true;
          uploadFile().then((url) {
            if (url != null) {
              setState(() {
                isUploading = false;
              });
            }
          });
        });
      } else {
        print('no image selected');
      }
    });
  }

  Future uploadFile() async {
    File file = File(image!.path);

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(file);
      imageUrl = await referenceImageToUpload.getDownloadURL();

      if (imageUrl != null) {
        setState(() {
          listOfUrls.add(imageUrl);
        });
      }
    } catch (error) {
      print("Error MESSAGE=================${error}");
    }
    return imageUrl;
  }
}
