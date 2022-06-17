import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/consts.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Components/customDialog.dart';
import 'package:route_planning/Components/customText.dart';
import 'package:route_planning/Providers/getPassengersProvider.dart';
import '../../Providers/getRouteProvider.dart';
import '../Splash/splashPage.dart';

List selectedLoc = [];
var selectedPlace = "";
var didRequest = false;
var personIndex = 0;
bool didFind = false;

class HomePageUser extends StatefulWidget {
  final String email;
  const HomePageUser({Key key, this.email}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  GoogleMapController mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyClqzhv58g0Ov_9rrmXiNNABQS2dKx9rsE";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  //to get data from Firebase
  void getData() {
    final getPassengers = Provider.of<GetPassengers>(context, listen: false);
    getPassengers.getData(widget.email);
  }

  //to get the route information from Firebase
  void getRoute() {
    final getRoute = Provider.of<GetRoute>(context, listen: false);
    getRoute.getRoute();
  }

  getDirections(double lat1, double lng1, i) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(lat1, lng1),
      PointLatLng(kouLocX, kouLocY),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orange,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  @override
  void initState() {
    getData();
    getRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userRequest[0]);
    print("Did Accept ? $didAccept");
    GetPassengers getPassengers = Provider.of<GetPassengers>(context);
    GetRoute getRoute = Provider.of<GetRoute>(context);

    //to check data that any station selected or not
    if (!getPassengers.error && !getPassengers.loading) {
      for (int i = 0; i < getPassengers.data["passengers"].length; i++) {
        if (getPassengers.data["passengers"][i]["name"] == widget.email) {
          setState(() {
            didRequest = true;
            personIndex = i;
          });
        }
      }
    }

    if (didAccept) {
      if (!getRoute.error && !getRoute.loading) {
        //print("girdi");
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < getRoute.data["route-$i"].length; j++) {
            //print(getRoute.data["route-$i"][j]["locX"]);
            //print(userRequest[0]);
            if (getRoute.data["route-$i"][j]["locX"] == userRequest[0]) {
              setState(() {
                didFind = true;
                getDirections(userRequest[0], userRequest[1], i);
                markers.add(Marker(
                  //add distination location marker
                  markerId: MarkerId("kou"),
                  position: LatLng(kouLocX, kouLocY), //position of marker
                  infoWindow: InfoWindow(
                    //popup info
                    title: 'Destination Point ',
                    snippet: 'Destination Marker',
                  ),
                  icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                ));
                markers.add(Marker(
                  //add distination location marker
                  markerId: MarkerId("koum"),
                  position: LatLng(
                      userRequest[0], userRequest[1]), //position of marker
                  infoWindow: InfoWindow(
                    //popup info
                    title: 'Destination Point ',
                    snippet: 'Destination Marker',
                  ),
                  icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                ));
              });
            }
          }
        }
      }
    } else if (!didAccept && didRequest) {
      //reddedildi yazdır
    }

    final List districts = [
      [
        "Başiskele",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.71408084044044, 29.928567219270928];
            selectedPlace = "Başiskele";
          });
        }
      ],
      [
        "Çayırova",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.832885682326214, 29.36984166460072];
            selectedPlace = "Çayırova";
          });
        }
      ],
      [
        "Darıca",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.7737725329276, 29.400274319251032];
            selectedPlace = "Darıca";
          });
        }
      ],
      [
        "Derince",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.755681531821445, 29.831249500201313];
            selectedPlace = "Derince";
          });
        }
      ],
      [
        "İzmit",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.776438630930265, 29.948405092906928];
            selectedPlace = "İzmit";
          });
        }
      ],
      [
        "Dilovası",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.78472295356009, 29.535900584593907];
            selectedPlace = "Dilovası";
          });
        }
      ],
      [
        "Gebze",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.80270625063124, 29.438109559325984];
            selectedPlace = "Gebze";
          });
        }
      ],
      [
        "Gölcük",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.71617585652615, 29.820569259277022];
            selectedPlace = "Gölcük";
          });
        }
      ],
      [
        "Kandıra",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [41.0699717868362, 30.15258806142084];
            selectedPlace = "Kandıra";
          });
        }
      ],
      [
        "Karamürsel",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.69128966303792, 29.61747769400684];
            selectedPlace = "Karamürsel";
          });
        }
      ],
      [
        "Kartepe",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.754114886630546, 30.022028942013034];
            selectedPlace = "Kartepe";
          });
        }
      ],
      [
        "Körfez",
        Icons.map_outlined,
        () {
          setState(() {
            selectedLoc = [40.77630774450331, 29.73598998793284];
            selectedPlace = "Körfez";
          });
        }
      ],
    ];

    return Scaffold(
      appBar: CustomAppBar(
        text: "Home Page",
        widget: SizedBox(),
      ),
      body: didRequest && !didAccept
          ? Center(
              child: CustomText(
                  color: Colors.black,
                  sizes: TextSize.small,
                  text: "Your station request has been sent to the admin."),
            )
          : didAccept
              ? GoogleMap(
                  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(
                        userRequest[0], userRequest[1]), //initial position
                    zoom: 16.0, //initial zoom level
                  ),
                  markers: markers, //markers to show on map
                  polylines: Set<Polyline>.of(polylines.values), //polylines
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    //method called when map is created
                    setState(() {
                      mapController = controller;
                    });
                  },
                )
              : WillPopScope(
                  onWillPop: _onBackPressed,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: didRequest
                        ? ListTile(
                            title: CustomText(
                              color: Colors.black,
                              sizes: TextSize.small,
                              text: getPassengers.data["passengers"]
                                  [personIndex]["ilce"],
                            ),
                            trailing: CustomText(
                              color: Colors.black,
                              sizes: TextSize.small,
                              text: "Accepted/Rejected/On Hold",
                            ),
                          )
                        : Column(
                            children: [
                              //Warning Text
                              Container(
                                color: Colors.grey[200],
                                child: ListTile(
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.red,
                                  ),
                                  title: CustomText(
                                      text:
                                          "Select the station where you want to get into the shuttle",
                                      color: Colors.black,
                                      sizes: TextSize.small),
                                ),
                              ),
                              //Districts
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: districts.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      new ListTile(
                                        title: CustomText(
                                            text: districts[index][0],
                                            color: Colors.black,
                                            sizes: TextSize.small),
                                        trailing: new Icon(
                                          districts[index][1],
                                          color: secondaryColor,
                                          size: 25,
                                        ),
                                        onTap: districts[index][2],
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 80,
                              )
                            ],
                          ),
                  ),
                ),
      floatingActionButton: selectedPlace == null
          ? SizedBox()
          : didAccept
              ? SizedBox()
              : CustomButton(
                  onpressed: selectedLoc.length == 0
                      ? null
                      : () async {
                          await FirebaseFirestore.instance
                              .collection("passengers")
                              .doc("passengerRequest")
                              .update({
                            "passengers": FieldValue.arrayUnion([
                              {
                                "locX": selectedLoc[0],
                                "locY": selectedLoc[1],
                                "isRealUser": true,
                                "count": 1,
                                "state": "unkown",
                                "email": widget.email,
                                "district": selectedPlace,
                              }
                            ])
                          });
                          setState(() {
                            didRequest = true;
                          });
                        },
                  text: "$selectedPlace Submit",
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
}


//toplam alınan yolu tuttur
//senaryolar
//sınırsız sayıda servis problemi
