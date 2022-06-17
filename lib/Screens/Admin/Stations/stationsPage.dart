import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/noData.dart';
import 'package:route_planning/Screens/Admin/Stations/addStationPage.dart';

class StationsPage extends StatefulWidget {
  final stations;
  const StationsPage({Key key, this.stations}) : super(key: key);

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Home Page",
        widget: SizedBox(),
      ),
      body: widget.stations.length > 0
          ? ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.stations.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    new ListTile(
                      title: CustomText(
                          text: widget.stations[index]["stationName"],
                          color: Colors.black,
                          sizes: TextSize.small),
                      trailing: new Icon(
                        Icons.ev_station_outlined,
                        color: secondaryColor,
                        size: 25,
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            )
          : NoData(
              text: "Did not find any saved station",
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddStationPage()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}
