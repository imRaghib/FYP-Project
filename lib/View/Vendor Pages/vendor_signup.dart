import 'package:easy_shaadi/ViewModel/vendor_authentication.dart';

import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';

import '../../Model/vendor.dart';

class VendorSignupPage extends StatefulWidget {
  const VendorSignupPage({Key? key}) : super(key: key);

  @override
  State<VendorSignupPage> createState() => _VendorSignupPageState();
}

class _VendorSignupPageState extends State<VendorSignupPage> {
  final formKey = GlobalKey<FormState>();
  Vendor obj = Vendor();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: size.height * 0.32,
                child: Image.asset(
                  "assets/vendor.png",
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Become a Vendor!",
                style: TextStyle(
                  fontFamily: 'SourceSansPro-SemiBold',
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Welcome! Please enter your details.",
                style: TextStyle(
                  fontFamily: 'SourceSansPro-Regular',
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    buildFullName(),
                    const SizedBox(height: 16),
                    buildEmail(),
                    const SizedBox(height: 16),
                    buildBusinessName(),
                    const SizedBox(height: 16),
                    buildPassword(),
                    const SizedBox(height: 16),
                    buildCNIC(),
                    const SizedBox(height: 16),
                    buildNumber(),
                    const SizedBox(height: 16),
                    buildAddress(),
                    const SizedBox(height: 32),
                    buildSignUp_Button()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFullName() => TextFormField(
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your full name", labelText: "Full Name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please Enter Correct Name";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.name = value!),
      );

  Widget buildCNIC() => TextFormField(
        keyboardType: TextInputType.number,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your CNIC Number", labelText: "CNIC"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return "Please Enter Correct CNIC";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.cnic = value!),
      );

  Widget buildNumber() => TextFormField(
        keyboardType: TextInputType.number,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Phone Number", labelText: "Number"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return "Please Enter Correct Phone Number";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.number = value!),
      );

  Widget buildEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Email", labelText: "Email"),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return "Please Enter Correct Email";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.email = value!),
      );

  Widget buildBusinessName() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Business Name", labelText: "Business Name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please Enter Correct Business Name";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.businessName = value!),
      );

  Widget buildPassword() => TextFormField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Password", labelText: "Password"),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$')
                  .hasMatch(value)) {
            return "Password must have "
                "\nleast one upper case "
                "\nleast one lower case"
                "\nleast one digit"
                "\nleast one Special character"
                "\nleast one Special character";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.password = value!),
      );

  Widget buildAddress() => TextFormField(
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Address", labelText: "Address"),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r'^[#.0-9a-zA-Z\s,-]+$').hasMatch(value)) {
            return "Please Enter Correct Address";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => obj.address = value!),
      );

  Widget buildSignUp_Button() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                await vendorSignup(
                    name: obj.name,
                    email: obj.email,
                    businessName: obj.businessName,
                    password: obj.password,
                    cnic: obj.cnic,
                    number: obj.number,
                    address: obj.address);

                showDialog(context: context, builder: (context){
                  return Center(child: CircularProgressIndicator(),);
                });
                Navigator.pushNamedAndRemoveUntil(
                    context, 'mainScreen', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurple,
            ),
            child: Text(
              "Sign up",
              style: TextStyle(
                fontFamily: 'SourceSansPro-Regular',
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
