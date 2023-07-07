import 'dart:math';

import 'package:easy_shaadi/Model/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Order.dart';
import '../Model/VendorRequest.dart';
import '../Model/bookings.dart';
import 'Messenger Class/apis.dart';
import 'google_login.dart';

class ProductProvider with ChangeNotifier {
  List<Booking> hallsList = [];
  late Booking halls;
  List<Requests> requestList = [];
  late Requests request;
  List<ProductOrder> cartList=[];
  List<ProductOrder> cartHistoryList=[];
  late ProductOrder cartHistory;
  var products=[];
  void addToCart(String pname, int pprice, String pimage, int pquantity, int deliveryCost,String seller,String buyer,String size){
    var cart=ProductOrder(
        ProductName: pname,
        ProductQuantity: pquantity,
        ProductPrice: pprice,
        ProductImages: pimage,
        deliveryCharges: deliveryCost,
        sellerId: seller,
        buyerId: buyer,
        size: size

    );
    cartList.add(cart);

  }
  getProductDetails(){
    for(int i=0;i<cartList.length;i++){
      products.add({
        'ProductImage':cartList[i].ProductImages,
        'ProductName':cartList[i].ProductName,
        'ProductQuantity':cartList[i].ProductQuantity,
        'size':cartList[i].size,
        'buyerId':cartList[i].buyerId,
        'sellerId':cartList[i].sellerId,
        'deliveryCharges':cartList[i].deliveryCharges,
        'totalAmount':cartList[i].totalPrice()
      });
    }
  }

  Future setcartdata()async{
    for(int i=0;i<cartList.length;i++){
      var basedata = await FirebaseFirestore.instance.collection("mycart").doc(FirebaseAuth.instance.currentUser!.uid).collection('reviewcart').doc();
      basedata.set({
        "imageAddress":cartList[i].ProductImages,
        "name":cartList[i].ProductName,
        "price":cartList[i].totalPrice(),
        "quantity":cartList[i].ProductQuantity,
      });
    }
  }
  int getTotalDelivery(){
    int cost=0;
    for(int i=0;i<cartList.length;i++)
    {
      cost=cost+cartList[i].deliveryCharges;
    }
    return cost;
  }

  int getTotalAmount() {
    int cost = 0;
    for (int i = 0; i < cartList.length; i++) {
      cost = cost + cartList[i].ProductPrice;
    }
    //cost = cost + getTotalAmount();
    return cost;
  }
  Future getCartData()async{
    List<ProductOrder> newlist=[];
    var basedata = await FirebaseFirestore.instance.collection("mycart").doc(FirebaseAuth.instance.currentUser!.uid).collection('reviewcart').get();
    basedata.docs.forEach((element){
      cartHistory=ProductOrder(
          ProductImages: element.get('imageAddress'),
          ProductName: element.get('name'),
          ProductPrice: element.get('price'),
          ProductQuantity: element.get('quantity')
      );
      newlist.add(cartHistory);
    }
    );
    cartHistoryList=newlist;
    notifyListeners();
  }

  Future placeOrder ({String address='',String city='',String state='',String phone='',String postalcode=''}) async{
    await FirebaseFirestore.instance.collection('orders').doc().set({
      'order_id': Random().nextInt(10000000),
      'order_date': FieldValue.serverTimestamp(),
      'buyer_id':  FirebaseAuth.instance.currentUser!.uid,
      'buyer_email':FirebaseAuth.instance.currentUser!.email,
      'buyer_address':address,
      'buyer_city':city,
      'buyer_state':state,
      'buyer_phone':phone,
      'buyer_postalcode':postalcode,
      'payment_method':'GooglePay',
      'order_placed':true,
      'order_confirmed':false,
      'order_on_delivery':false,
      'order_delivered':false,
      'total_amount':'1500',
      'orderlist':FieldValue.arrayUnion(products)
    });
  }
  
  getAllOrders(){
    return FirebaseFirestore.instance.collection('orders').where('buyer_id',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  }

  Future fetchHallsData() async {
    var document = await FirebaseFirestore.instance.collection("Venues").get();

    for (var element in document.docs) {
      halls = Booking(
        venueId: element.get('venueId'),
        venueImages: List.from(element.get('venueImages')),
        venueLocation: element.get('venueLocation'),
        venueName: element.get('venueName'),
        venuePrice: element.get('venuePrice'),
        venueDescription: element.get('venueDescription'),
        venueAddress: element.get('venueAddress'),
        venueCapacity: element.get('venueCapacity'),
        venueParking: element.get('venueParking'),
        vendorUID: element.get('vendorUID'),
        venueRating: element.get('venueRating'),
        venueFeedback: element.get('venueFeedback'),
        vendorNumber: element.get('vendorNumber'),
        inActiveDates: List.from(element.get('inActiveDates')),
        menus: Map.from(element.get('menus')),
      );
      hallsList.add(halls);
    }
    notifyListeners();
  }

  getUserEmail() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  Future fetchRequests() async {
    var document =
        await FirebaseFirestore.instance.collection('Vendor Requests').get();
    for (var element in document.docs) {
      request = Requests(id: element.get('Id'), name: element.get('Name'));
      requestList.add(request);
      // print(requestList.length);
    }
    notifyListeners();
  }

  Future signOut() async {
    APIs.updateActiveStatus(false);
    if (await googleSignin.isSignedIn()) {
      await googleSignin.disconnect();
    }

    await FirebaseAuth.instance.signOut();
  }

  late Customer customer;
  Future getCustomerDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      customer = Customer(
        Name: snapshot.get('Name').toString(),
        Email: snapshot.get('Email').toString(),
      );
    }

    notifyListeners();
  }
}
Future signout() async {
  APIs.updateActiveStatus(false);
  if (await googleSignin.isSignedIn()) {
    await googleSignin.disconnect();
  }

  await FirebaseAuth.instance.signOut();
}
deleteDocument(String venueId) async {
  var document = await FirebaseFirestore.instance;
  document.collection("Venues").doc(venueId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}
