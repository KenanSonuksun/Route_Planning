import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GetRoute with ChangeNotifier {
  var data;
  bool loading = true;
  bool error = false;
  getRoute() async {
    await FirebaseFirestore.instance
        .collection("route")
        .doc("calculatedRoute")
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
