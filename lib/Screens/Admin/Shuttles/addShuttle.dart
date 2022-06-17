import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customTextField.dart';
import '../HomePage/homePageAdmin.dart';

final shuttleLabel = TextEditingController();
final shuttleCapacity = TextEditingController();

class AddShuttle extends StatefulWidget {
  const AddShuttle({Key key}) : super(key: key);

  @override
  State<AddShuttle> createState() => _AddShuttleState();
}

class _AddShuttleState extends State<AddShuttle> {
  Future<void> pushFirebase(shuttleLabel, shuttleCapacity) async {
    await FirebaseFirestore.instance
        .collection("shuttles")
        .doc("shuttlesList")
        .update({
      "shuttles": FieldValue.arrayUnion([
        {"shuttleLabel": shuttleLabel, "shuttleCapacity": shuttleCapacity}
      ])
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePageAdmin(email: "kenan@gmail.com")),
        (Route<dynamic> route) => false);
  }

  /*@override
  void dispose() {
    shuttleCapacity.dispose();
    shuttleLabel.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        text: "Add Shuttle",
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
                    controller: shuttleLabel,
                    hintText: "Shuttle Label",
                    suffixIcon: Icon(Icons.location_city),
                    readonly: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (String value) {}),
                CustomTextField(
                    topPadding: size.height * 0.02,
                    controller: shuttleCapacity,
                    hintText: "Capacity",
                    suffixIcon: Icon(Icons.people),
                    readonly: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (String value) {}),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onpressed: () {
                    pushFirebase(shuttleLabel.text, shuttleCapacity.text);
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
