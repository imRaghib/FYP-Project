import 'package:easy_shaadi/Model/customer.dart';
import 'package:easy_shaadi/ViewModel/Messenger%20Class/apis.dart';
import 'package:easy_shaadi/stringCasingExtension.dart';
import 'package:flutter/material.dart';
import 'package:easy_shaadi/constants.dart';
import '../ViewModel/customer_authentication.dart';
import '../ViewModel/google_login.dart';
import 'Vendor Pages/vendor_signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
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
                    height: size.height * 0.4,
                    width: size.width * 1,
                    child: Image.asset(
                      "assets/signupPage.png",
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
                          "Welcome!",
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
                              buildFullName(),
                              const SizedBox(height: 20),
                              buildEmail(),
                              const SizedBox(height: 20),
                              buildPassword(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Column(
                          children: [
                            buildSignUpButton(),
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

  Customer customer = Customer();

  Row buildBottomText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Become a Vendor,',
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
              MaterialPageRoute(builder: (context) => const VendorSignupPage()),
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          "Invalid email or password $error",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
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
        onSaved: (value) => setState(() => nameController.text = value!),
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
                await customer_signup(
                    name: nameController.text.toTitleCase(),
                    email: emailController.text,
                    password: passController.text);
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
            side: MaterialStateProperty.all(const BorderSide(
                color: kPink, width: 1.0, style: BorderStyle.solid)),
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
                builder: (context) => const Center(
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
