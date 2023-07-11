import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/constants.dart';

import 'package:flutter/material.dart';
import 'package:easy_shaadi/stringCasingExtension.dart';

import '../../ViewModel/Admin/admin_functions.dart';

class SalonPayment extends StatelessWidget {
  final QueryDocumentSnapshot userData;
  const SalonPayment({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Material(
              elevation: 2,
              child: Table(
                border: TableBorder.all(color: kPurple),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Field',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Value',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildTableRow(
                      name: 'Appointment Completed',
                      value: userData['appointmentCompleted']),
                  buildTableRow(
                      name: 'bookingDate', value: userData['bookingDate']),
                  buildTableRow(
                      name: 'customerEmail', value: userData['customerEmail']),
                  buildTableRow(
                      name: 'customerName', value: userData['customerName']),
                  buildTableRow(name: 'orderId', value: userData['orderId']),
                  buildTableRow(
                      name: 'orderStatus', value: userData['orderStatus']),
                  buildTableRow(name: 'payment', value: userData['payment']),
                  buildTableRow(
                      name: 'paymentStatus', value: userData['paymentStatus']),
                  buildTableRow(
                      name: 'salonBookedOn', value: userData['salonBookedOn']),
                  buildTableRow(name: 'salonId', value: userData['salonId']),
                  buildTableRow(
                      name: 'salonName', value: userData['salonName']),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['paymentStatus'] == "onHold"
                        ? () {
                            updateSalonPaymentStatus(
                                orderId: userData['orderId'],
                                vendorUId: userData['vendorUID'],
                                requestStatus: 'onHoldByAdmin');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Block'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: userData['paymentStatus'] == "onHoldByAdmin"
                        ? () {
                            updateSalonPaymentStatus(
                                orderId: userData['orderId'],
                                vendorUId: userData['vendorUID'],
                                requestStatus: 'onHold');
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('UnBlock'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildTableRow({
    required name,
    required value,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name.toString().toTitleCase(),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value.toString().toTitleCase(),
            ),
          ),
        ),
      ],
    );
  }
}
