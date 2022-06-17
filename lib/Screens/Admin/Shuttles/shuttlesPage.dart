import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/noData.dart';
import 'package:route_planning/Screens/Admin/Shuttles/addShuttle.dart';

class ShuttlesPage extends StatefulWidget {
  final shuttles;
  const ShuttlesPage({Key key, this.shuttles}) : super(key: key);

  @override
  State<ShuttlesPage> createState() => _ShuttlesPageState();
}

class _ShuttlesPageState extends State<ShuttlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Shuttles",
        widget: SizedBox(),
      ),
      body: widget.shuttles.loading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : widget.shuttles.error
              ? NoData(
                  text: "Did not find any registered shuttle",
                )
              : SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: widget.shuttles.shuttles["shuttles"].length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              new ListTile(
                                title: CustomText(
                                    text: widget.shuttles.shuttles["shuttles"]
                                        [index]["shuttleLabel"],
                                    color: Colors.black,
                                    sizes: TextSize.small),
                                trailing: CustomText(
                                    text:
                                        "Capacity : ${widget.shuttles.shuttles["shuttles"][index]["shuttleCapacity"]}",
                                    color: Colors.black,
                                    sizes: TextSize.small),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddShuttle()));
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
