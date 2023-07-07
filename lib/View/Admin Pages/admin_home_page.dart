import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/providerclass.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Provider.of<ProductProvider>(context).signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'StreamPage', (route) => false);
                },
                child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
