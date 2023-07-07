import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/stringCasingExtension.dart';
import 'package:flutter/material.dart';
import '../../ViewModel/Admin/admin_functions.dart';

class VendorDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot userData;
  const VendorDetailsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Name'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Email'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Address'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Business Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['BusinessName'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Role:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Role'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Number:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['Number'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Request Status:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              userData['RequestStatus'].toString().toTitleCase(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['RequestStatus'] == "waiting" ||
                            userData['RequestStatus'] == "rejected"
                        ? () {
                            updateRequestStatus(
                                vendorUId: userData['Id'],
                                requestStatus: 'approved');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['RequestStatus'] == "approved"
                        ? () {
                            updateRequestStatus(
                                vendorUId: userData['Id'],
                                requestStatus: 'rejected');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}