import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_shaadi/Model/Vendor/add_jewellery_model.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../ViewModel/Vendor/venue_provider.dart';

class AddDressPage extends StatefulWidget {
  const AddDressPage({Key? key}) : super(key: key);

  @override
  State<AddDressPage> createState() => _AddDressPageState();
}

class _AddDressPageState extends State<AddDressPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  JewelleryModel DressModel = JewelleryModel();

  List<String> listOfUrls = [];
  File? image;
  final imagePicker = ImagePicker();
  bool isUploading = false;
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildAddPhotos(),
              buildDivider(),
              buildProductName(),
              buildProductDes(),
              buildAddress(),
              buildProductPrice(),
              buildProductVariation(),
              buildProductWeight(),
              buildProductDelivery(),
              const SizedBox(
                height: 20,
              ),
              buildDivider(),
              buildContactInfo(),
              buildNumber(),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
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
              if (listOfUrls.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Please add images!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  fontSize: 15,
                );
              }
              if (formKey.currentState!.validate() && listOfUrls.isNotEmpty) {
                formKey.currentState!.save();

                try {
                  VenueProvider().addDressData(
                      productImages: listOfUrls,
                      productLocation: DressModel.productAddress,
                      productName: DressModel.productName,
                      productPrice: DressModel.productPrice,
                      productDescription: DressModel.productDescription,
                      productRating: 0,
                      productFeedback: 0,
                      productNumber: DressModel.productNumber,
                      productQuantity: DressModel.availableQuantity,
                      productSize: DressModel.productSize,
                      productDelivery: DressModel.productDelivery);

                  Navigator.pushNamedAndRemoveUntil(
                      context, 'StreamPage', (route) => false);
                } catch (error) {
                  Fluttertoast.showToast(
                    msg: error.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    fontSize: 15,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPurple),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
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
            child: const Icon(
              size: 25,
              color: Colors.black,
              Icons.numbers,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              decoration: const InputDecoration(
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
                  setState(() => DressModel.productNumber = value!),
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
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
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

  Padding buildAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 25,
              color: kPurple,
              Icons.add_location_alt,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Shop Address",
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
                  setState(() => DressModel.productAddress = value!),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
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
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        fontSize: 15,
      );
    }

    return imageUrl;
  }

  Padding buildAddPhotos() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: image == null
          ? DottedBorder(
              color: Colors.black,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              child: InkWell(
                  onTap: getImage,
                  child: Container(
                      height: 150,
                      width: double.infinity,
                      color: kPink.withAlpha(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                              size: 35,
                              color: Colors.grey,
                              Icons.camera_alt_outlined),
                          Text('Add Photo'),
                        ],
                      ))),
            )
          : DottedBorder(
              color: Colors.black,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                        physics: const ClampingScrollPhysics(),
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
                              IconButton(
                                  onPressed: () {
                                    try {
                                      FirebaseStorage.instance
                                          .refFromURL(listOfUrls[index])
                                          .delete();
                                    } catch (error) {
                                      Fluttertoast.showToast(
                                        msg: error.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.grey,
                                        fontSize: 15,
                                      );
                                    }
                                    setState(() {
                                      listOfUrls.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.clear)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: getImage,
                        style:
                            ElevatedButton.styleFrom(backgroundColor: kPurple),
                        child: const Text(
                          "Add More Photos",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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
    );
  }

  Divider buildDivider() {
    return Divider(
      thickness: 1,
      color: kPurple.withOpacity(0.2),
    );
  }

  Padding buildProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Product Name",
                labelText: "Product",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Product Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => DressModel.productName = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductDes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 25,
              color: kPurple,
              Icons.description,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Tell us about your product",
                labelText: "Description",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => DressModel.productDescription = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 30,
              color: kPurple,
              Icons.attach_money,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Price of Product",
                labelText: "Price",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Enter Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => DressModel.productPrice = int.parse(value!)),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductWeight() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 30,
              color: kPurple,
              Icons.adb_rounded,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Product Weight",
                labelText: "Weight",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                  return "Enter Product Weight";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => DressModel.productSize = value!),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductDelivery() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: const Icon(
              size: 30,
              color: kPurple,
              Icons.delivery_dining,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Product Delivery Price",
                labelText: "Delivery",
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return "Enter Product Delivery Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(
                  () => DressModel.productDelivery = int.parse(value!)),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductVariation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPink.withAlpha(40),
                radius: 20,
                child: const Icon(
                  size: 25,
                  color: kPurple,
                  Icons.add_business,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: kPurple.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    hintText: "eg: Size",
                    labelText: "Variation",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPink),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPurple),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9\s.,#\-]+$").hasMatch(value)) {
                      return "Enter Variation";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) =>
                      setState(() => DressModel.productCarrots = value!),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  // controller: controller,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: kPurple.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    hintText: "eg: 50",
                    labelText: "Quantity",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPink),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kPurple),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[0-9]+$").hasMatch(value)) {
                      return "Enter Quantity";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => setState(
                      () => DressModel.availableQuantity = int.parse(value!)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
