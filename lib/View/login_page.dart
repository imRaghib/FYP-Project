import 'package:easy_shaadi/View/forgot_password_screen.dart';
import 'package:easy_shaadi/View/signup_page.dart';
import 'package:easy_shaadi/ViewModel/google_login.dart';
import 'package:flutter/material.dart';
import '../Model/login_screen_model.dart';

import 'package:easy_shaadi/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? error;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Image.asset(
                  "assets/loginPage.png",
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.010),
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.8,
                    child: Image.asset(
                      "assets/loginPage_couple.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.32),
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontFamily: 'SourceSansPro-SemiBold',
                            fontSize: size.width * 0.10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 05),
                        child: Text(
                          "Please enter your details.",
                          style: TextStyle(
                            fontFamily: 'SourceSansPro-Regular',
                            fontSize: size.width * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Column(
                            children: [
                              buildShowAlert(),
                              buildEmail(),
                              const SizedBox(height: 20),
                              buildPassword(),
                              buildForgotPass(size),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Column(
                          children: [
                            buildSignInButton(),
                            buildGoogleButton(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildBottomText(context),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildBottomText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontFamily: 'SourceSansPro-Regular',
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          child: const Text(
            'Sign up!',
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              fontSize: 15,
              color: kPurple,
            ),
          ),
        ),
      ],
    );
  }

  buildShowAlert() {
    if (error != null) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "Invalid email or password",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
  }

  Column buildSignInButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              try {
                await LoginScreenModel().signInWithEmailAndPassword(
                    email: emailController.text, password: passController.text);
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
            "Sign in",
            style: TextStyle(
              fontFamily: 'SourceSansPro-Regular',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Align buildForgotPass(Size size) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: Text(
          "Forgot Password",
          style: TextStyle(
            color: kPurple,
            fontFamily: 'SourceSansPro-Regular',
            fontSize: size.width * 0.04,
          ),
        ),
      ),
    );
  }

  Widget buildEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your Email", labelText: "Email"),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return "Enter Correct Email";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => emailController.text = value!),
      );

  Widget buildPassword() => TextFormField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(
          hintText: "Enter your Password", labelText: "Password"),
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Correct Password";
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => passController.text = value!));

  Widget buildGoogleButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: kPink, width: 1.0, style: BorderStyle.solid)),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          onPressed: () {
            googleLogin();
            showDialog(
                context: context,
                builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage("assets/google_logo.png"),
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
