import 'package:flutter/material.dart';
import 'package:route_planning/Components/animations.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Screens/Admin/Membership/loginAdmin.dart';
import 'package:route_planning/Screens/User/loginUser.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final controller = PageController(viewportFraction: 0.8);
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Content about buttons
    final List content = [
      //A button to contiune as a admin
      CustomButton(
        onpressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminLoginPage()));
        },
        text: "Continue as a admin",
      ),
      //A button to contiune as a user
      CustomButton(
        onpressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserLoginPage()));
        },
        text: "Continue as a user",
      ),
    ];
    //Screen size
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Header
                //Welcome text
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CustomText(
                    color: secondaryColor,
                    sizes: TextSize.title,
                    text: "WELCOME",
                  ),
                ),
                //Information text
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "This application plans passengers and routes for a shuttle. While getting requested station information from the passengers, calculates the best path-cost optimization.",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                    ),
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                //Images
                SizedBox(
                  height: 300,
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset("assets/images/image1.jpg"),
                      Image.asset("assets/images/image2.jpg"),
                      Image.asset("assets/images/image3.jpg"),
                    ],
                  ),
                ),
                //Page Indicator
                Container(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 4,
                    ),
                  ),
                ),
                //Buttons
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return SlideAnimation(
                      animationController: animationController,
                      itemCount: 2,
                      position: index,
                      slideDirection: SlideDirection.fromBottom,
                      child: Column(
                        children: [
                          content[index],
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
