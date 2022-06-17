import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customTextField.dart';

import '../HomePage/homePageAdmin.dart';

final stationName = TextEditingController();
final stationLocX = TextEditingController();
final stationLocY = TextEditingController();

class AddStationPage extends StatefulWidget {
  const AddStationPage({Key key}) : super(key: key);

  @override
  State<AddStationPage> createState() => _AddStationPageState();
}

class _AddStationPageState extends State<AddStationPage> {
  Future<void> pushFirebase(stationName, stationLocX, stationLocY) async {
    await FirebaseFirestore.instance
        .collection("stations")
        .doc("stationInfo")
        .update({
      "stations": FieldValue.arrayUnion([
        {
          "stationName": stationName,
          "locX": stationLocX,
          "locY": stationLocY,
        }
      ])
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePageAdmin(email: "kenan@gmail.com")),
        (Route<dynamic> route) => false);
  }

  /*@override
  void dispose() {
    stationName.dispose();
    stationLocX.dispose();
    stationLocY.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        text: "Add Passenger",
        widget: SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/login.jpg"),
                CustomTextField(
                    topPadding: size.height * 0.02,
                    controller: stationName,
                    hintText: "Station Name",
                    suffixIcon: Icon(Icons.location_city),
                    readonly: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (String value) {}),
                CustomTextField(
                    topPadding: size.height * 0.02,
                    controller: stationLocX,
                    hintText: "Station Latitude",
                    suffixIcon: Icon(Icons.people),
                    readonly: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (String value) {}),
                CustomTextField(
                    topPadding: size.height * 0.02,
                    controller: stationLocY,
                    hintText: "Station Longitude",
                    suffixIcon: Icon(Icons.people),
                    readonly: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (String value) {}),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onpressed: () async {
                    pushFirebase(
                        stationName.text, stationLocX.text, stationLocY.text);
                  },
                  text: "Add",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
