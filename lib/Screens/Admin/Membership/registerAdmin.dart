import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customDialog.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/customTextField.dart';
import 'package:route_planning/Providers/validationSignUp.dart';
import 'package:route_planning/Service/service.dart';

final _formKey = GlobalKey<FormState>();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final rePasswordController = TextEditingController();
String repsw = "";
Animation fadeAnim;
AnimationController animationController;

class AdminSignupPage extends StatefulWidget {
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage>
    with TickerProviderStateMixin {
  //A function for the firebase progress
  Future<void> _signUpUser(
      String email, String password, BuildContext context) async {
    FirebaseService _currentUser =
        Provider.of<FirebaseService>(context, listen: false);

    try {
      if (await _currentUser.signUp(email, password)) {
        CustomDialog().bigDialog(context, "Registration Successful", () {
          Navigator.pop(context);
        }, Colors.green);
        //after 5 seconds go to the previous page
        Future.delayed(const Duration(milliseconds: 5000), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        CustomDialog().firstDialog(
            context, "Registration failed", Icons.close, Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    fadeAnim = new CurvedAnimation(
      parent: animationController,
      curve: new Interval(
        0.100,
        0.200,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
    super.initState();
  }

  /*@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    animationController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final validationProvider = Provider.of<SignupValidation>(context);
    return Scaffold(
      //Appbar
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 1,
            title: CustomText(
              color: Colors.black,
              sizes: TextSize.normal,
              text: "Sign Up",
            ),
          )),
      //Body
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              //for the animation
              opacity: fadeAnim,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Image
                      Image.asset("assets/images/signup.jpg"),
                      //Text field for the email
                      CustomTextField(
                          topPadding: size.height * 0.02,
                          controller: emailController,
                          hintText: "E mail",
                          suffixIcon: Icon(CupertinoIcons.mail),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {
                            validationProvider.changeEmail(value);
                          }),
                      //warning about the validation errors
                      validationProvider.email.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  validationProvider.email.error ?? "",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),

                      //Text field for the password
                      CustomTextField(
                          topPadding: size.height * 0.01,
                          controller: passwordController,
                          hintText: "Şifre",
                          suffixIcon: Icon(CupertinoIcons.lock),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (String value) {
                            validationProvider.changePassword(value);
                          }),
                      //warning about the validation errors
                      validationProvider.password.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  validationProvider.password.error ?? "",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),
                      //Text field for the re-Password
                      CustomTextField(
                        topPadding: size.height * 0.01,
                        controller: rePasswordController,
                        hintText: "Şifre tekrar",
                        suffixIcon: Icon(CupertinoIcons.lock),
                        readonly: false,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (String value) {
                          setState(() {
                            repsw = value;
                          });
                        },
                      ),
                      //check that the password and the re-password are the same or not
                      repsw != passwordController.text
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "The passwords are not the same",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      //A button to sign up
                      CustomButton(
                        text: "sign Up",
                        onpressed: () {
                          if (validationProvider.isValid &&
                              passwordController.text ==
                                  rePasswordController.text &&
                              emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              rePasswordController.text.isNotEmpty) {
                            //The progress in Firebase
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(emailController.text)
                                .set({
                              "email": emailController.text,
                              "password": passwordController.text,
                              "isAdmin": true
                            });
                            //signup service
                            _signUpUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            CustomDialog().firstDialog(context,
                                "Registration failed", Icons.close, Colors.red);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
