import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/salon_appointment_history.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/Messenger Models/chat_user.dart';
import '../../View/Messenger Screens/chat_screen.dart';
import '../../View/User Pages/booking_history.dart';
import '../Messenger Class/apis.dart';
import '../providerclass.dart';

Widget listTile({IconData? icon, String title = ""}) {
  return ListTile(
    leading: Icon(
      icon,
      size: 32,
      color: kPurple,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
  );
}

// Future SignOut()async{
//   await FirebaseAuth.instance.signOut();
// }
late ChatUser me;

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context, listen: true);

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: kPink),
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
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BottomNavBar(
                      val: 0,
                    );
                  }));
                },
                child: listTile(icon: Icons.home_outlined, title: "Home")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BottomNavBar(
                      val: 1,
                    );
                  }));
                },
                child: listTile(icon: Icons.mail_outlined, title: "Messages")),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingHistory()),
                  );
                },
                child: listTile(icon: Icons.store, title: "Booking History")),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SalonAppointmentHistory()),
                  );
                },
                child: listTile(icon: Icons.brush, title: "Salon History")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BottomNavBar(
                      val: 2,
                    );
                  }));
                },
                child: listTile(
                    icon: Icons.inventory_outlined, title: "Check List")),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BottomNavBar(
                      val: 3,
                    );
                  }));
                },
                child:
                    listTile(icon: Icons.person_add_alt, title: "Guest List")),
            InkWell(
                onTap: () async {
                  APIs.addChatUser("admin@gmail.com");
                  await FirebaseFirestore.instance
                      .collection('Accounts')
                      .doc('LAoaR0zKlehD4c25N8zZxsdckQs2')
                      .get()
                      .then((user) async {
                    if (user.exists) {
                      me = ChatUser.fromJson(user.data()!);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ChatScreen(user: me)));
                    }
                  });
                },
                child: listTile(icon: Icons.person, title: "Contact Admin")),
            InkWell(
                onTap: () {
                  auth.signOut().whenComplete(() =>
                      Navigator.pushReplacementNamed(context, 'mainScreen')
                      );

                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => route.isFirst);
                },
                child:
                    listTile(icon: Icons.logout_outlined, title: "Sign out")),
            const SizedBox(
              height: 2,
            ),
            const SizedBox(
               height: 220,
              child:  Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      "Support",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    Center(child: Text("Contact: 042 111 111 111")),
                    Center(child: Text("Email: EasyShaadi@gmail.com")),
                    SizedBox(
                      height: 60,
                    )
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
