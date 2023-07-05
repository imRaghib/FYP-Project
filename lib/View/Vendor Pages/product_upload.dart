import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_shaadi/Model/Vendor/product_model.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final formKey = GlobalKey<FormState>();
  final quantityFormKey = GlobalKey<FormState>();

  var quantityMap = {};
  int quantity = 0;
  String variation = '';
  TextEditingController controller = TextEditingController();

  ProductModel productModel = ProductModel();

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
              // buildDivider(),
              buildAddPhotos(context),
              buildDivider(),
              buildProductName(),
              buildProductDes(),
              buildProductPrice(),
              // buildProductQuantity(),
              buildProductVariation(),
              // buildAddress(),
              // buildCapacitySlider(),
              // buildParkingSlider(),
              // buildContactInfo(),
              // buildName(),
              // buildNumber(),
              // buildSubmitButton(),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         showModalBottomSheet<dynamic>(
              //           backgroundColor: Colors.white.withOpacity(0),
              //           context: context,
              //           builder: (BuildContext context) {
              //             return StatefulBuilder(
              //               builder: (BuildContext context,
              //                       StateSetter setModalState) =>
              //                   Container(
              //                 decoration: const BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.only(
              //                     topLeft: Radius.circular(10),
              //                     topRight: Radius.circular(10),
              //                   ),
              //                 ),
              //                 child: buildDefaultMultiDatePickerWithValue(),
              //               ),
              //             );
              //           },
              //         );
              //       },
              //       child: Text("Select Dates"),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
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
      print("Error Message ${error}");
    }

    return imageUrl;
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
                  onTap: getImage,
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
                              Icons.camera_alt_outlined),
                          Text('Add Photo'),
                        ],
                      ))),
            )
          : DottedBorder(
              color: Colors.black,
              strokeWidth: 2,
              dashPattern: [8, 4],
              child: Center(
                child: Column(
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
                              IconButton(
                                  onPressed: () {
                                    try {
                                      FirebaseStorage.instance
                                          .refFromURL(listOfUrls[index])
                                          .delete();
                                    } catch (error) {
                                      print("Error Message ${error}");
                                    }
                                    setState(() {
                                      listOfUrls.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.clear)),
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
                        style:
                            ElevatedButton.styleFrom(backgroundColor: kPurple),
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
            child: Icon(
              size: 25,
              color: kPurple,
              Icons.add_box_rounded,
            ),
          ),
          SizedBox(
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
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return "Enter Product Name";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productName = value!),
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
            child: Icon(
              size: 25,
              color: kPurple,
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
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Tell us about your product",
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
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return "Enter Description";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productDescription = value!),
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
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Price of Product",
                labelText: "Price",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return "Enter Price";
                } else {
                  return null;
                }
              },
              onSaved: (value) =>
                  setState(() => productModel.productPrice = int.parse(value!)),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProductQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPink.withAlpha(40),
            radius: 20,
            child: Icon(
              size: 30,
              color: kPurple,
              Icons.adb_rounded,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: kPurple.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                hintText: "Product Quantity",
                labelText: "Quantity",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPink),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPurple),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                  return "Enter Quantity";
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(
                  () => productModel.productQuantity = int.parse(value!)),
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
                child: Icon(
                  size: 25,
                  color: kPurple,
                  Icons.add_business,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          // isScrollControlled: true,
                          backgroundColor: Colors.white.withOpacity(0),
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter setModalState) =>
                                  Container(
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: Form(
                                    key: quantityFormKey,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                // controller: controller,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: kPurple
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  hintText:
                                                      "eg: Red Color, Size 14",
                                                  labelText: "Variations",
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPink),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPurple),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      !RegExp(r"^[a-zA-Z\s]+$")
                                                          .hasMatch(value)) {
                                                    return "Enter Variation";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onSaved: (value) => setState(
                                                    () => variation = value!),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                // controller: controller,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: kPurple
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  hintText: "eg: 50",
                                                  labelText: "Quantity",
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPink),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPurple),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      !RegExp(r"^[0-9]+$")
                                                          .hasMatch(value)) {
                                                    return "Enter Quantity";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onSaved: (value) => setState(
                                                    () => quantity =
                                                        int.parse(value!)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  if (quantityFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    quantityFormKey
                                                        .currentState!
                                                        .save();

                                                    setModalState(() {
                                                      quantityMap[variation] =
                                                          quantity;
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: kPurple,
                                                ),
                                                // padding: EdgeInsets.all(10.0),
                                                shape: CircleBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: quantityMap.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String key = quantityMap.keys
                                                .elementAt(index);
                                            int value = quantityMap[key];
                                            return ListTile(
                                              title: Text('$key'),
                                              subtitle: Text('Value: $value'),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    quantityMap.remove(key);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: kPurple,
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
                      icon: Icon(
                        size: 25,
                        color: kPurple,
                        Icons.add,
                      ),
                    ),
                    hintStyle: TextStyle(
                        color: kPurple.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                    hintText: "eg: Color, Size",
                    labelText: "Variation Name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPink),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPurple),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return "Enter Variation";
                    } else {
                      return null;
                    }
                  },
                  // onSaved: (value) =>
                  //     setState(() => productModel.productVariation = value!),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.21,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: quantityMap.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 15,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 200,
                  width: 200,
                  color: red,
                );
                // return ListTile(
                //   title: Text('${variationList[index]}'),
                //   // trailing: IconButton(
                //   //   onPressed: () {
                //   //     setState(() {
                //   //       variationList.removeAt(index);
                //   //     });
                //   //   },
                //   //   icon: Icon(
                //   //     Icons.minimize,
                //   //     color: kPurple,
                //   //   ),
                //   // ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
