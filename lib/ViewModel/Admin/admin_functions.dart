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
