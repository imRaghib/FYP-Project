import 'package:easy_shaadi/View/Vendor%20Pages/private_mode_status.dart';
import 'package:easy_shaadi/View/Vendor%20Pages/vendor_home_page.dart';
import 'package:easy_shaadi/View/customerMainPage.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/checklist/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/providerclass.dart';

Widget listTile({IconData? icon, String title = ""}) {
  return ListTile(
    leading: Icon(
      icon,
      size: 32,
      color: Colors.tealAccent.shade700,
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black45),
    ),
  );
}

// Future SignOut()async{
//   await FirebaseAuth.instance.signOut();
// }
class VendorDrawer extends StatefulWidget {
  const VendorDrawer({Key? key}) : super(key: key);

  @override
  State<VendorDrawer> createState() => _VendorDrawerState();
}

class _VendorDrawerState extends State<VendorDrawer> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Colors.orange),
                child: Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/prof.jpeg'),
                        backgroundColor: Colors.black45,
                        radius: 50,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(auth.getUserEmail() ?? "Unknown"),
                    ],
                  ),
                )),
            SwitchListTile(
              value: pmode.private,
              onChanged: (val) {
                pmode.privateMode(val);
                setState(() {});
              },
              title: const Text(
                'Private Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return VendorHomePage(
                          val: 0,
                        );
                      }));
                },
                child: listTile(icon: Icons.dashboard, title: "Dashboard")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return VendorHomePage(
                          val: 1,
                        );
                      }));
                },
                child: listTile(icon: Icons.chat, title: "Chats")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return VendorHomePage(
                          val: 2,
                        );
                      }));
                },
                child: listTile(
                    icon: Icons.store_mall_directory,
                    title: "Booking History")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return VendorHomePage(
                          val: 3,
                        );
                      }));
                },
                child: listTile(icon: Icons.library_add, title: "Directory")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return VendorHomePage(
                          val: 4,
                        );
                      }));
                },
                child: listTile(icon: Icons.history, title: "Orders")),
            InkWell(
                onTap: () {
                  auth.signOut().whenComplete(() =>
                  {Navigator.pushReplacementNamed(context, 'mainScreen')});

                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => route.isFirst);
                },
                child:
                listTile(icon: Icons.logout_outlined, title: "Sign out")),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(
                        child: Text(
                          "Support",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                    Center(child: Text("Contact: 042 111 111 111")),
                    Center(child: Text("Email: EasyShaadi@gmail.com"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}