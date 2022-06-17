import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customDialog.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Components/noData.dart';
import 'package:route_planning/Providers/getPassengersProvider.dart';
import 'package:route_planning/Providers/getShuttlesProvider.dart';
import 'package:route_planning/Providers/getStationsProvider.dart';
import 'package:route_planning/Screens/Admin/Route/routePage.dart';
import 'package:route_planning/Screens/Admin/Shuttles/shuttlesPage.dart';
import 'package:route_planning/Screens/Admin/Passengers/passengers.dart';
import 'package:route_planning/Screens/Admin/Stations/stationsPage.dart';
import '../../Splash/splashPage.dart';

class HomePageAdmin extends StatefulWidget {
  final String email;
  const HomePageAdmin({Key key, this.email}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  double temp = 0.0;
  bool didCalculate = true;
  var totalArray = [], route1 = [], route2 = [], route3 = [];
  var tempArray = [];
  //to get the passengers from Firebase
  void getPassengers() {
    final getPassengers = Provider.of<GetPassengers>(context, listen: false);
    getPassengers.getData(widget.email);
  }

  //to get the stations from Firebase
  void getStations() {
    final getStations = Provider.of<GetStations>(context, listen: false);
    getStations.getData();
  }

  //to get the shuttles from Firebase
  void getShuttles() {
    final getShuttles = Provider.of<GetShuttles>(context, listen: false);
    getShuttles.getData();
  }

  void checkUserState(passengers) {
    if (didAccept) {
      for (int i = 0; i < passengers.length; i++) {
        if (passengers[i]["locX"] == userRequest[0] &&
            !passengers[i]["isRealUser"]) {
          setState(() {
            passengers[i]["count"] = passengers[i]["count"] + 1;
            FirebaseFirestore.instance
                .collection('passengers')
                .doc('passengerRequest')
                .update({"passengers": passengers});
          });
        }
      }
      for (int i = 0; i < passengers.length; i++) {
        if (passengers[i]["isRealUser"] == false &&
            passengers[i]["district"] != "bosYolcu") {
          setState(() {
            tempArray.add(passengers[i]);
          });
        }
      }
    }
  }

  @override
  void initState() {
    getPassengers();
    getStations();
    getShuttles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GetPassengers getPassengers = Provider.of<GetPassengers>(context);
    GetStations getStations = Provider.of<GetStations>(context);
    GetShuttles getShuttles = Provider.of<GetShuttles>(context);
    final double width = MediaQuery.of(context).size.width;

    if (didAccept && !getPassengers.error && !getPassengers.loading) {
      setState(() {
        checkUserState(getPassengers.data["passengers"]);
        for (int i = 0; i < getPassengers.data["passengers"].length; i++) {
          getPassengers.data["passengers"][i] = tempArray[i];
        }
      });
    }
    //for the drawer menu
    final List _menu = [
      [
        "Shuttles",
        Icons.car_rental,
        () {
          if (getShuttles.shuttles["shuttles"].length > 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShuttlesPage(
                          shuttles: getShuttles,
                        )));
          }
        }
      ],
      [
        "Passengers",
        Icons.car_rental,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PassengersPage(
                        passengers: getPassengers.data["passengers"],
                      )));
        }
      ],
      [
        "Stations",
        Icons.transfer_within_a_station_rounded,
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StationsPage(
                        stations: getStations.stations["stations"],
                      )));
        }
      ],
      [
        "Route",
        Icons.alt_route_sharp,
        () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RoutePage()));
        }
      ],
      [
        "Log Out",
        Icons.exit_to_app,
        () {
          _onBackPressed();
        }
      ],
    ];
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            //header
            UserAccountsDrawerHeader(
              accountName: CustomText(
                color: Colors.white,
                sizes: TextSize.big,
                text: "Admin",
              ),
              accountEmail: CustomText(
                color: Colors.white,
                sizes: TextSize.small,
                text: widget.email,
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text(
                  "A",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            //menu
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _menu.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: width > 500
                          ? EdgeInsets.only(top: 15.0)
                          : EdgeInsets.only(top: 0.0),
                      child: new ListTile(
                        title: new Text(_menu[index][0],
                            style: TextStyle(
                                fontSize: width > 500
                                    ? 22
                                    : width < 390
                                        ? 15
                                        : 17)),
                        trailing: new Icon(
                          _menu[index][1],
                          color: secondaryColor,
                          size: width > 500
                              ? 40
                              : width < 390
                                  ? 15
                                  : 25,
                        ),
                        onTap: _menu[index][2],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      appBar: CustomAppBar(
        text: "Home Page",
        widget: SizedBox(),
      ),
      body: getPassengers.loading || getShuttles.loading || getStations.loading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : getPassengers.error || getShuttles.error || getStations.error
              ? NoData(
                  text: "No data",
                )
              : !didCalculate
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: const CircularProgressIndicator(),
                          ),
                          Center(
                            child: const CustomText(
                              color: Colors.black,
                              sizes: TextSize.small,
                              text:
                                  "The route is calculating. It can take few minutes",
                            ),
                          )
                        ],
                      ),
                    )
                  : WillPopScope(
                      onWillPop: _onBackPressed,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            //Stations and Number of Passengers
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount:
                                  getPassengers.data["passengers"].length,
                              itemBuilder: (context, index) {
                                return getPassengers.data["passengers"][index]
                                                ["isRealUser"] ==
                                            true ||
                                        getPassengers.data["passengers"][index]
                                                ["district"] ==
                                            "bosYolcu"
                                    ? SizedBox()
                                    : Column(
                                        children: [
                                          new ListTile(
                                            title: CustomText(
                                                text: getPassengers
                                                        .data["passengers"]
                                                    [index]["district"],
                                                color: Colors.black,
                                                sizes: TextSize.small),
                                            trailing: CustomText(
                                                text:
                                                    "${getPassengers.data["passengers"][index]["count"].toString()} People",
                                                color: Colors.black,
                                                sizes: TextSize.small),
                                          ),
                                          Divider(),
                                        ],
                                      );
                              },
                            ),
                            //The calculating system
                            getPassengers.data["passengers"].length <= 1
                                ? SizedBox()
                                : CustomButton(
                                    onpressed: () async {
                                      setState(() {
                                        didCalculate = false;
                                      });
                                      if (getStations
                                                  .stations["stations"].length >
                                              0 &&
                                          getPassengers
                                                  .data["passengers"].length >
                                              0 &&
                                          getShuttles
                                                  .shuttles["shuttles"].length >
                                              0) {
                                        calculateRoute1(
                                            getStations.stations["stations"],
                                            getPassengers.data["passengers"],
                                            getShuttles.shuttles["shuttles"]);
                                      } else {
                                        CustomDialog().firstDialog(context,
                                            "Error", Icons.error, Colors.red);
                                      }
/*
                            var totalArray = [];

                            var locArray1 = [
                              [
                                40.832885682326214,
                                29.36984166460072,
                                "Çayırova"
                              ], //Cayırova
                              [
                                40.7737725329276,
                                29.400274319251032,
                                "Darıca"
                              ], //Darıca
                              [
                                40.80270625063124,
                                29.438109559325984,
                                "Gebze"
                              ], //Gebze
                              [
                                40.78472295356009,
                                29.535900584593907,
                                "Dilovası"
                              ], //Dilovası
                              [
                                40.77630774450331,
                                29.73598998793284,
                                "Körfez"
                              ], //Körfez
                              [
                                40.755681531821445,
                                29.831249500201313,
                                "Derince"
                              ], //Derince
                            ];

                            var locArray2 = [
                              [
                                40.69128966303792,
                                29.61747769400684,
                                "Karamürsel"
                              ], //Karamürsel
                              [
                                40.71617585652615,
                                29.820569259277022,
                                "Gölcük"
                              ], //Gölcük
                              [
                                40.71408084044044,
                                29.928567219270928,
                                "Başiskele"
                              ], //Başiskele
                              [
                                40.776438630930265,
                                29.948405092906928,
                                "İzmit"
                              ], //İzmit
                            ];

                            var locArray3 = [
                              [
                                41.0699717868362,
                                30.15258806142084,
                                "Kandıra"
                              ], //Kandıra
                              [
                                40.754114886630546,
                                30.022028942013034,
                                "Kartepe"
                              ], //Kartepe
                            ];

                            totalArray.add(locArray1);
                            totalArray.add(locArray2);
                            totalArray.add(locArray3);
                            for (int i = 0; i < totalArray.length; i++) {
                              if (totalArray[i].length > 0) {
                                for (int j = 0; j < totalArray[i].length; j++) {
                                  await FirebaseFirestore.instance
                                      .collection("route")
                                      .doc("calculatedRoute")
                                      .update({
                                    "route-$i": FieldValue.arrayUnion([
                                      {
                                        "locX": totalArray[i][j][0],
                                        "locY": totalArray[i][j][1],
                                      }
                                    ])
                                  });
                                }
                              }
                            }
                            totalArray.length = 0;
                            locArray1.length = 0;
                            locArray2.length = 0;
                            locArray3.length = 0;*/
                                    },
                                    text: "Calculate",
                                  ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  //for onBackPress
  Future<bool> _onBackPressed() async {
    CustomDialog().secondDialog(context, "Are you sure you want to sign out?",
        () async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false);
    }, () {
      Navigator.pop(context);
    });
  }

  //to calculate the route with the limited shuttles
  calculateRoute1(stations, passengers, shuttles) async {
    int currentCapacity = 0;
    int i = 0;
    double firstLocX = kouLocX;
    double firstLocY = kouLocY;
    var currentLoc;
    for (i = 0; i < shuttles.length; i++) {
      if (currentCapacity == 0) currentCapacity = selectShuttle(i, shuttles);

      while (currentCapacity > 0) {
        //print("kapasite : $currentCapacity // firstLocX : $firstLocX // firstLocY : $firstLocY");

        await nearestStation(stations, passengers, firstLocX, firstLocY)
            .then((value) {
          setState(() {
            currentLoc = value;
            //print(currentLoc);
            //currentCapacity = 0;
          });
          if (currentLoc != null) {
            if (currentLoc["count"] <= currentCapacity) {
              setState(() {
                print(
                    "Durak : ${currentLoc["district"]} - Aldığı yolcu sayısı : ${currentLoc["count"].toString()}");

                currentCapacity = currentCapacity - currentLoc["count"];
                firstLocX = currentLoc["locX"];
                firstLocY = currentLoc["locY"];
                for (int x = 0; x < passengers.length; x++) {
                  if (passengers[x]["district"] == currentLoc["district"]) {
                    passengers[x]["count"] = 0;
                    FirebaseFirestore.instance
                        .collection('passengers')
                        .doc('passengerRequest')
                        .update({"passengers": passengers});
                  }
                }
                if (i == 0)
                  route1.add([currentLoc["locX"], currentLoc["locY"]]);
                else if (i == 1)
                  route2.add([currentLoc["locX"], currentLoc["locY"]]);
                else if (i == 2)
                  route3.add([currentLoc["locX"], currentLoc["locY"]]);
              });
            } else {
              setState(() {
                //database o durağın yolcu sayısını kapasite kadar azalt,
                var res = currentLoc["count"] - currentCapacity;

                print(
                    "Durak : ${currentLoc["district"]} - Aldığı yolcu sayısı : ${currentCapacity.toString()}");

                currentCapacity = 0;
                for (int x = 0; x < passengers.length; x++) {
                  if (passengers[x]["district"] == currentLoc["district"]) {
                    passengers[x]["count"] = res;
                    FirebaseFirestore.instance
                        .collection('passengers')
                        .doc('passengerRequest')
                        .update({"passengers": passengers});
                  }
                }
                if (i == 0)
                  route1.add([currentLoc["locX"], currentLoc["locY"]]);
                else if (i == 1)
                  route2.add([currentLoc["locX"], currentLoc["locY"]]);
                else if (i == 2)
                  route3.add([currentLoc["locX"], currentLoc["locY"]]);
              });
            }
            if (currentCapacity == 0) {
              setState(() {
                firstLocX = kouLocX;
                firstLocY = kouLocY;
              });
            }
          } else {
            print("Durak yok");
            setState(() {
              currentCapacity = 0;
              firstLocX = kouLocX;
              firstLocY = kouLocY;
            });
          }
        });
      }

      print("----------------------");
    }
    setState(() {
      currentCapacity = 0;
      i = 0;
      firstLocX = kouLocX;
      firstLocY = kouLocY;
      totalArray.add(route1);
      totalArray.add(route2);
      totalArray.add(route3);
      numberOfShuttles = totalArray.length;
      for (int i = 0; i < totalArray.length; i++) {
        if (totalArray[i].length > 0) {
          for (int j = 0; j < totalArray[i].length; j++) {
            FirebaseFirestore.instance
                .collection("route")
                .doc("calculatedRoute")
                .update({
              "route-$i": FieldValue.arrayUnion([
                {
                  "locX": totalArray[i][j][0],
                  "locY": totalArray[i][j][1],
                }
              ])
            });
          }
        }
      }
      didCalculate = true;
    });
  }

  //to get distance between two locations
  Future getDistanceMatrix(lat1, lng1, lat2, lng2) async {
    BaseOptions options = BaseOptions(
      baseUrl: "https://maps.googleapis.com/maps/api/distancematrix/json?",
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    Response resp;
    Dio dio = Dio(options);
    try {
      resp = await dio.get(
        "/get",
        queryParameters: {
          "destinations": "${lat1.toString()},${lng1.toString()}",
          "origins": "${lat2.toString()},${lng2.toString()}",
          "key": "AIzaSyClqzhv58g0Ov_9rrmXiNNABQS2dKx9rsE"
        },
      );
      //print("${resp.data["rows"][0]["elements"][0]["distance"]["text"].toString().substring(0, 4)}");
      setState(() {
        temp = double.tryParse(resp.data["rows"][0]["elements"][0]["distance"]
                ["text"]
            .toString()
            .substring(0, 4));
        //print(temp);
      });
    } catch (e) {
      print("Exception: $e");
    }
  }

  int selectShuttle(int index, shuttles) {
    int capacity = int.tryParse(shuttles[index]["shuttleCapacity"]);
    return capacity;
  }

  //to find the nearest station
  Future nearestStation(stations, passengers, lat, lng) async {
    //print("{$firstLocX  $firstLocY}");
    int index = 0;
    bool check = false;
    double minDistance = 10000000.0;
    double kouDistance = 10000000.0;
    double dist = 0.0;
    /*if (lat != kouLocX) {
      await getDistanceMatrix(lat, lng, kouLocX, kouLocY).whenComplete(() {
        setState(() {
          kouDistance = temp;
        });
      });
    } else {
      setState(() {
        kouDistance = 100000000.0;
      });
    }*/
    //double maxDistance = getDistance(lat, lng, kouLocX, kouLocY);
    //to find the nearest station
    for (int a = 0; a < stations.length; a++) {
      if (lat != stations[a]["locX"]) {
        await getDistanceMatrix(
                lat, lng, stations[a]["locX"], stations[a]["locY"])
            .whenComplete(() {
          if (temp < kouDistance) {
            if (temp < minDistance) {
              for (int b = 0; b < passengers.length; b++) {
                if (stations[a]["stationName"] == passengers[b]["district"] &&
                    passengers[b]["count"] > 0) {
                  setState(() {
                    minDistance = temp;
                    index = b;
                    //print(index);
                    check = true;
                    dist = temp;
                  });
                  //print("${passengers[index]["district"]}----${temp.toString()}");
                  break;
                }
              }
            }
          }
        });
      }
    }
    print(dist);
    return check ? passengers[index] : null;
  }
}
