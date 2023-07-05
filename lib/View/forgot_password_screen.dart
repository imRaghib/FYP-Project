import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPassword extends StatefulWidget {
   ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email='';
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  Image.asset('assets/prof.jpeg'),
                  buildShowAlert(),
                  Text('Reset Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  SizedBox(
                    height: 15,
                  ),
                  buildEmail(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 70, vertical: 10),
            child: Column(
              children: [
                buildSignUpButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmail() => TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: kTextFieldDecoration.copyWith(
        hintText: "Enter your Email", labelText: "Email"),
    validator: (value) {
      if (value!.isEmpty ||
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value!)) {
        return "Enter Correct Email";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => emailController.text = value!),
  );

  Column buildSignUpButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              try {
                print(emailController.text);
                await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                Navigator.pushNamedAndRemoveUntil(
                    context, 'StreamPage', (route) => false);
              } catch (e) {
                setState(() {
                  error = e.toString();
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPurple,
          ),
          child: const Text(
            "Reset",
            style: TextStyle(
              fontFamily: 'SourceSansPro-Regular',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  buildShowAlert() {
    if (error != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "Invalid email or password $error",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
  }

}
