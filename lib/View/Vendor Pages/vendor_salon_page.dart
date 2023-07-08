import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorSalonAppointmentPage extends StatelessWidget {
  const VendorSalonAppointmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => VendorOrderDetails(
                //             data: data[index],
                //           )),
                // );
              },
              leading: AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/easyshaadi-1311a.appspot.com/o/wedding%20halls%2Fwed4.jpg?alt=media&token=16d957d6-cd33-479f-a746-ef8b6383fca0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                'Order Id:',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              subtitle: Text('Total Amount : 10000 Rs'),
              trailing: Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()),
            ),
          )),
    );
  }
}
