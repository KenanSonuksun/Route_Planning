import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GetShuttles with ChangeNotifier {
  var shuttles;
  bool loading = true;
  bool error = false;
  getData() async {
    await FirebaseFirestore.instance
        .collection("shuttles")
        .doc("shuttlesList")
        .get()
        .then((value) {
      if (value != null) {
        shuttles = value;
        loading = false;
      } else {
        loading = false;
        error = true;
      }
    });
    notifyListeners();
  }
}
