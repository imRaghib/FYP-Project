import 'package:cloud_firestore/cloud_firestore.dart';

void updateJeweleryData({
  required String productId,
  required String productLocation,
  required String productName,
  required int productPrice,
  required String productDescription,
  required String productNumber,
  required int productQuantity,
  required String productSize,
  required String productCarrots,
  required int productDelivery,
  required bool isPrivate,
}) async {
  await FirebaseFirestore.instance
      .collection("Jewelerys")
      .where("productId", isEqualTo: productId)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "productAddress": productLocation,
        "productName": productName,
        "productPrice": productPrice,
        "productDescription": productDescription,
        "sellerNumber": productNumber,
        "isPrivate": isPrivate,
        "availableQuantity": productQuantity,
        "productSize": productSize,
        "productCarrots": productCarrots,
        "productDelivery": productDelivery,
      });
    });
  });
}

deleteJewelery(String productId) async {
  await FirebaseFirestore.instance
      .collection("Jewelerys")
      .where("productId", isEqualTo: productId)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  });
}
