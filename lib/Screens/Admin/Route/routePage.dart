import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_planning/Components/consts.dart';
import '../../../Components/noData.dart';
import '../../../Providers/getRouteProvider.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  GoogleMapController mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyClqzhv58g0Ov_9rrmXiNNABQS2dKx9rsE";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  //to get the route information from Firebase
  void getRoute() {
    final getRoute = Provider.of<GetRoute>(context, listen: false);
    getRoute.getRoute();
  }

  @override
  void initState() {
    getRoute();
    super.initState();
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
    addPolyLine(polylineCoordinates, i);
  }

  addPolyLine(List<LatLng> polylineCoordinates, i) {
    PolylineId id = PolylineId(i.toString());
    Polyline polyline = Polyline(
      polylineId: id,
      color: i == 0
          ? Colors.red
          : i == 1
              ? Colors.purple
              : Colors.orange,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    GetRoute getRoute = Provider.of<GetRoute>(context);
    if (!getRoute.loading && !getRoute.error) {
      for (int i = 0; i < numberOfShuttles; i++) {
        markers.add(Marker(
          //add start location marker
          markerId: MarkerId(i.toString()),
          position: LatLng(
              getRoute.data["route-$i"][getRoute.data["route-$i"].length - 1]
                  ["locX"],
              getRoute.data["route-$i"][getRoute.data["route-$i"].length - 1]
                  ["locY"]), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: 'Starting Point ',
            snippet: 'Start Marker',
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));

        getDirections(
            getRoute.data["route-$i"][getRoute.data["route-$i"].length - 1]
                ["locX"],
            getRoute.data["route-$i"][getRoute.data["route-$i"].length - 1]
                ["locY"],
            i); //fetch direction polylines from Google API
      }
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
    }

    return Scaffold(
      body: getRoute.loading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : getRoute.error
              ? NoData()
              : GoogleMap(
                  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(getRoute.data["route-0"][0]["locX"],
                        getRoute.data["route-0"][0]["locY"]), //initial position
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
                ),
    );
  }
}
