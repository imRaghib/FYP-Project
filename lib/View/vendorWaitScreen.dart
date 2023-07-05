import 'package:easy_shaadi/ViewModel/signout.dart';
import 'package:flutter/material.dart';
class VendorWaitingScreen extends StatelessWidget {
  const VendorWaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Request Has been Sent Kindly wait for Admins Response'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: (){
              signout();
              Navigator.pushNamedAndRemoveUntil(context, 'StreamPage', (route) => false);
            }, child: Text('signout'))
          ],
        )),
      ),
    );
  }
}
