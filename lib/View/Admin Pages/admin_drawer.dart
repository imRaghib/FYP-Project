import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/providerclass.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);
    return Drawer(
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
    );
  }
}
