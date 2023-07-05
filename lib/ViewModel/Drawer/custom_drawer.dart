import 'package:easy_shaadi/View/customerMainPage.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/checklist/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providerclass.dart';

Widget listTile({IconData ?icon, String title=""}){
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
class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ProductProvider>(context,listen: true);

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                    color: Colors.orange
                ),
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
                      Text( auth.getUserEmail() ?? "Unknown"),
                    ],
                  ),
                )
            ),

            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                    return BottomNavBar(val: 0,);
                  }));
                },
                child: listTile(icon: Icons.home_outlined,title: "Home")
            ),

            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                    return BottomNavBar(val: 1,);
                  }));
                },
                child: listTile(icon:Icons.mail_outlined,title: "Messages")),

            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                    return BottomNavBar(val: 2,);
                  }));
                },
                child: listTile(icon:Icons.inventory_outlined,title: "Check List")),

            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                    return BottomNavBar(val: 3,);
                  }));
                },
                child: listTile(icon:Icons.person_add_alt,title: "Guest List")),


            InkWell(
                onTap: (){
                  auth.signOut().whenComplete(() => {
                    Navigator.pushReplacementNamed(context, 'mainScreen')
                  });

                 // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => route.isFirst);
                  },
                child: listTile(icon: Icons.logout_outlined,title: "Sign out")),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(child: Text("Support",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
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