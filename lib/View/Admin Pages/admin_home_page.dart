import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/providerclass.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () {
                  auth.signOut().whenComplete(() =>
                      {Navigator.pushReplacementNamed(context, 'mainScreen')});
                },
                child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
