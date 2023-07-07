import 'package:easy_shaadi/View/Vendor%20Pages/vendor_home_page.dart';
import 'package:easy_shaadi/View/Admin%20Pages/admin_page.dart';
import 'package:easy_shaadi/View/loading_screen.dart';
import 'package:easy_shaadi/View/splash_screen.dart';
import 'package:easy_shaadi/View/vendorWaitScreen.dart';
import 'package:easy_shaadi/View/welcome_page.dart';
import 'package:easy_shaadi/ViewModel/VendorScreenDecide.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/bottom_nav_bar.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

late Size mq;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await Firebase.initializeApp(
  //     // options: FirebaseOptions(
  //     //     apiKey: "AIzaSyDWif1elX8JDxU09iIR6nriSXzeXaWsLos",
  //     //     appId: "1:483108328130:web:7f8889f919258fd599e15b",
  //     //     messagingSenderId: "483108328130",
  //     //     projectId: "easyshaadi-1311a"
  //     // )
  //
  //     );
  // init the hive
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });
}

Widget UserManage(BuildContext context) {
  var info = FirebaseFirestore.instance
      .collection('Accounts')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  info.then((value) {
    if (value.get('Role') == 'admin') {
      Navigator.pushNamedAndRemoveUntil(context, 'admin', (route) => false);
    } else if ((value.get('Role') == 'Customer')) {
      Navigator.pushNamedAndRemoveUntil(context, 'customer', (route) => false);
    } else {
      VendorDecidor(context);
    }
  });
  return LoadingScreen();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: kPurple, useMaterial3: true),
          routes: {
            'StreamPage': (context) => MyApp(),
            'admin': (context) => AdminPage(),
            'customer': (context) => BottomNavBar(),
            'vendorWait': (context) => VendorWaitingScreen(),
            'vendorMain': (context) => VendorHomePage(),
            'mainScreen': (context) => Selection()
          },
          home: SplashScreen()),
    );
  }
}

class Selection extends StatelessWidget {
  const Selection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return UserManage(context);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something Went Wrong'),
              );
            } else {
              return WelcomePage();
            }
          }
        });
  }
}
