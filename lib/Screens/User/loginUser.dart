import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customDialog.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/customTextField.dart';
import 'package:route_planning/Screens/User/homePageUser.dart';
import 'package:route_planning/Screens/User/registerUser.dart';
import 'package:route_planning/Service/service.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();
Animation fadeAnim;
AnimationController animationController;

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage>
    with TickerProviderStateMixin {
  //A function for the firebase progress
  Future<void> _signInUser(
      String email, String password, BuildContext context) async {
    //To get data from Firebase
    FirebaseService _currentUser =
        Provider.of<FirebaseService>(context, listen: false);

    try {
      if (await _currentUser.logIn(email, password)) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageUser(
                      email: email,
                    )));
      } else {
        //Error dialog
        CustomDialog().bigDialog(
            context, "Login Failed. Please check your email and password.", () {
          Navigator.pop(context);
        }, Colors.red);
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
    animationController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              text: "Login",
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
                  child: Column(
                    children: [
                      //Image
                      Image.asset(
                        "assets/images/login.jpg",
                        height: 300,
                      ),
                      //Text field for the email
                      CustomTextField(
                          topPadding: size.height * 0.02,
                          controller: emailController,
                          hintText: "Email",
                          suffixIcon: Icon(CupertinoIcons.mail),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          onChanged: (String value) {}),
                      //Text field for the password
                      CustomTextField(
                          topPadding: size.height * 0.01,
                          controller: passwordController,
                          hintText: "Password",
                          suffixIcon: Icon(CupertinoIcons.lock),
                          readonly: false,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (String value) {}),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      //A button to sign in
                      CustomButton(
                        text: "Login",
                        onpressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            _signInUser(emailController.text,
                                passwordController.text, context);
                          } else {
                            CustomDialog().firstDialog(
                                context,
                                "Login failed.Try again later",
                                Icons.close,
                                Colors.red);
                          }
                          //getEmail();
                        },
                      ),
                      //Do not you have an account text
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserSignupPage()));
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Do not you have an account ? Now ',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width > 500 ? 25 : 17),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xFFFF7643),
                                      ))
                                ]),
                          ),
                        ),
                      )
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
