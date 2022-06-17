import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';

class UserRoutePage extends StatefulWidget {
  const UserRoutePage({Key key}) : super(key: key);

  @override
  State<UserRoutePage> createState() => _UserRoutePageState();
}

class _UserRoutePageState extends State<UserRoutePage> {
  void getData() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Anasayfa",
        widget: SizedBox(),
      ),
    );
  }
}
