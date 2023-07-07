import 'package:cloud_firestore/cloud_firestore.dart';

class status{
  static var confirmed=false;
  static var onDelivery=false;
  static var delivered=false;
  static getStatus(data){
    confirmed=data['order_confirmed'];
    onDelivery = data['order_on_delivery'];
    delivered = data['order_delivered'];
  }

 static changeStatus({title,status,docId}) async {
    var store = FirebaseFirestore.instance.collection('orders').doc(docId);
    await store.set({
      title:status
    },
        SetOptions(
            merge: true
        )
    );
  }
}