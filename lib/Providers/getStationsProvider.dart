import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GetStations with ChangeNotifier {
  var stations;
  bool loading = true;
  bool error = false;
  getData() async {
    await FirebaseFirestore.instance
        .collection("stations")
        .doc("stationInfo")
        .get()
        .then((value) {
      if (value != null) {
        print("success");
        stations = value;
        loading = false;
      } else {
        loading = false;
        error = true;
      }
    });
    notifyListeners();
  }
}
