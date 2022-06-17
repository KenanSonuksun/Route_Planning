import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/noData.dart';
import 'package:route_planning/Screens/Admin/Passengers/addPassenger.dart';
import '../HomePage/homePageAdmin.dart';

int count = -1;

class PassengersPage extends StatefulWidget {
  final passengers;
  const PassengersPage({Key key, this.passengers}) : super(key: key);

  @override
  State<PassengersPage> createState() => _PassengersPageState();
}

class _PassengersPageState extends State<PassengersPage> {
  check() {
    for (int i = 0; i < widget.passengers.length; i++) {
      if (widget.passengers[i]["isRealUser"]) {
        setState(() {
          count = i;
          userRequest = [
            widget.passengers[i]["locX"],
            widget.passengers[i]["locY"],
            widget.passengers[i]["count"]
          ];
        });
      }
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Passengers Request",
        widget: SizedBox(),
      ),
      body: widget.passengers.length == 0
          ? NoData(
              text: "Did not find any passenger request",
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.passengers.length,
                  itemBuilder: (context, index) {
                    return widget.passengers[index]["district"] == "bosYolcu"
                        ? SizedBox()
                        : Column(
                            children: [
                              new ListTile(
                                title: CustomText(
                                    text: widget.passengers[index]["district"],
                                    color: Colors.black,
                                    sizes: TextSize.small),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      color: Colors.black,
                                      sizes: TextSize.small,
                                      text:
                                          "${widget.passengers[index]["count"].toString()} Person/People",
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    widget.passengers[index]["isRealUser"] ==
                                            true
                                        ? CircleAvatar(
                                            backgroundColor: greyBackground,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    didAccept = true;
                                                  });
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomePageAdmin(
                                                                      email:
                                                                          "kenan@gmail.com")),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                }),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    widget.passengers[index]["isRealUser"] ==
                                            true
                                        ? CircleAvatar(
                                            backgroundColor: greyBackground,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    didAccept = false;
                                                  });
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomePageAdmin(
                                                                      email:
                                                                          "kenan@gmail.com")),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                }),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPassenger()));
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
