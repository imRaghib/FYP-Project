import 'package:cloud_firestore/cloud_firestore.dart';

updateRequestStatus({
  required String vendorUId,
  required String requestStatus,
}) async {
  await FirebaseFirestore.instance
      .collection('Vendor Requests')
      .doc(vendorUId)
      .update({
    'RequestStatus': requestStatus,
  });
}

updateVenuePaymentStatus({
  required String orderId,
  required String vendorUId,
  required String requestStatus,
}) async {
  await FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(vendorUId)
      .collection('Venue Orders')
      .doc(orderId)
      .update({
    'paymentStatus': requestStatus,
  });
}

updateSalonPaymentStatus({
  required String orderId,
  required String vendorUId,
  required String requestStatus,
}) async {
  await FirebaseFirestore.instance
      .collection('Vendor Orders')
      .doc(vendorUId)
      .collection('Salon Orders')
      .doc(orderId)
      .update({
    'paymentStatus': requestStatus,
  });
}
