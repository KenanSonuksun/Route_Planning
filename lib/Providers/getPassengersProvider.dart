import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GetPassengers with ChangeNotifier {
  var data;
  bool loading = true;
  bool error = false;
  getData(email) async {
    await FirebaseFirestore.instance
        .collection("passengers")
        .doc("passengerRequest")
        .get()
        .then((value) {
      if (value != null) {
        data = value;
        loading = false;
      } else {
        loading = false;
        error = true;
      }
    });
    notifyListeners();
  }
}
