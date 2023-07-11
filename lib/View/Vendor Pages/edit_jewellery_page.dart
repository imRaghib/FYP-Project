import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_shaadi/Model/Vendor/add_jewellery_model.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../ViewModel/Vendor/jewellwery_provider.dart';
import '../../ViewModel/Vendor/venue_provider.dart';

class JewelleryEditPage extends StatefulWidget {
  final jewelleryData;
  const JewelleryEditPage({Key? key, required this.jewelleryData})
      : super(key: key);

  @override
  State<JewelleryEditPage> createState() => _JewelleryEditPageState();
}

class _JewelleryEditPageState extends State<JewelleryEditPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  JewelleryModel jewelleryModel = JewelleryModel();

  late bool isPrivate = widget.jewelleryData["isPrivate"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text(
                    'Make Private',
                    style: TextStyle(fontSize: 20),
                  ),
                  value: isPrivate,
                  onChanged: (value) {
                    setState(() {
                      isPrivate = value;
                    });
                  }),
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
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                try {
                  updateJeweleryData(
                    productLocation: jewelleryModel.productAddress,
                    productName: jewelleryModel.productName,
                    productPrice: jewelleryModel.productPrice,
                    productDescription: jewelleryModel.productDescription,
                    productNumber: jewelleryModel.productNumber,
                    productQuantity: jewelleryModel.availableQuantity,
                    productSize: jewelleryModel.productSize,
                    productCarrots: jewelleryModel.productCarrots,
                    productDelivery: jewelleryModel.productDelivery,
                    productId: widget.jewelleryData['productId'],
                    isPrivate: isPrivate,
                  );

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
              initialValue: widget.jewelleryData['sellerNumber'],
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
                  setState(() => jewelleryModel.productNumber = value!),
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
              color: Colors.black,
              Icons.add_location_alt,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              initialValue: widget.jewelleryData['productAddress'],
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
                  setState(() => jewelleryModel.productAddress = value!),
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
              initialValue: widget.jewelleryData["productName"],
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
                    !RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                  return "Enter Product Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => jewelleryModel.productName = value!),
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
              initialValue: widget.jewelleryData["productDescription"],
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
                if (value!.isEmpty || !RegExp(r"^[\s\S]*$").hasMatch(value)) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => jewelleryModel.productDescription = value!),
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
              initialValue: widget.jewelleryData["productPrice"].toString(),
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
              onSaved: (value) => setState(
                  () => jewelleryModel.productPrice = int.parse(value!)),
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
              initialValue: widget.jewelleryData["productSize"],
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
                if (value!.isEmpty || !RegExp(r"^[\s\S]*$").hasMatch(value)) {
                  return "Enter Product Weight";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => jewelleryModel.productSize = value!),
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
              initialValue: widget.jewelleryData["productDelivery"].toString(),
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
                  () => jewelleryModel.productDelivery = int.parse(value!)),
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
                  initialValue: widget.jewelleryData["productCarrots"],
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: kPurple.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    hintText: "eg: 24K Carats",
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
                        !RegExp(r"^[\s\S]*$").hasMatch(value)) {
                      return "Enter Variation";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) =>
                      setState(() => jewelleryModel.productCarrots = value!),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  initialValue:
                      widget.jewelleryData["availableQuantity"].toString(),
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
                  onSaved: (value) => setState(() =>
                      jewelleryModel.availableQuantity = int.parse(value!)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
