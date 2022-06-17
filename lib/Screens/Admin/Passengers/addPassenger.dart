import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_planning/Components/appBar.dart';
import 'package:route_planning/Components/customButton.dart';
import 'package:route_planning/Screens/Admin/HomePage/homePageAdmin.dart';

int sayac = 0;

//senaryo 1
final locArray1 = [
  [40.832885682326214, 29.36984166460072, "Çayırova", 5], //Cayırova
  [40.7737725329276, 29.400274319251032, "Darıca", 20], //Darıca
  [40.80270625063124, 29.438109559325984, "Gebze", 15], //Gebze
  [40.78472295356009, 29.535900584593907, "Dilovası", 30], //Dilovası
  [40.77630774450331, 29.73598998793284, "Körfez", 5], //Körfez
  [40.755681531821445, 29.831249500201313, "Derince", 20], //Derince
  [40.69128966303792, 29.61747769400684, "Karamürsel", 20], //Karamürsel
  [40.71617585652615, 29.820569259277022, "Gölcük", 15], //Gölcük
  [40.71408084044044, 29.928567219270928, "Başiskele", 10], //Başiskele
  [40.776438630930265, 29.948405092906928, "İzmit", 25], //İzmit
  [41.0699717868362, 30.15258806142084, "Kandıra", 15], //Kandıra
  [40.754114886630546, 30.022028942013034, "Kartepe", 10] //Kartepe
];
//senaryo 2
final locArray2 = [
  [40.832885682326214, 29.36984166460072, "Çayırova", 5], //Cayırova
  [40.7737725329276, 29.400274319251032, "Darıca", 20], //Darıca
  [40.80270625063124, 29.438109559325984, "Gebze", 5], //Gebze
  [40.78472295356009, 29.535900584593907, "Dilovası", 10], //Dilovası
  [40.77630774450331, 29.73598998793284, "Körfez", 5], //Körfez
  [40.755681531821445, 29.831249500201313, "Derince", 5], //Derince
  [40.69128966303792, 29.61747769400684, "Karamürsel", 5], //Karamürsel
  [40.71617585652615, 29.820569259277022, "Gölcük", 5], //Gölcük
  [40.71408084044044, 29.928567219270928, "Başiskele", 10], //Başiskele
  [40.776438630930265, 29.948405092906928, "İzmit", 15], //İzmit
  [41.0699717868362, 30.15258806142084, "Kandıra", 5], //Kandıra
  [40.754114886630546, 30.022028942013034, "Kartepe", 10] //Kartepe
];
//senaryo 3
final locArray3 = [
  [40.832885682326214, 29.36984166460072, "Çayırova", 10], //Cayırova
  [40.7737725329276, 29.400274319251032, "Darıca", 0], //Darıca
  [40.80270625063124, 29.438109559325984, "Gebze", 0], //Gebze
  [40.78472295356009, 29.535900584593907, "Dilovası", 0], //Dilovası
  [40.77630774450331, 29.73598998793284, "Körfez", 0], //Körfez
  [40.755681531821445, 29.831249500201313, "Derince", 0], //Derince
  [40.69128966303792, 29.61747769400684, "Karamürsel", 0], //Karamürsel
  [40.71617585652615, 29.820569259277022, "Gölcük", 0], //Gölcük
  [40.71408084044044, 29.928567219270928, "Başiskele", 10], //Başiskele
  [40.776438630930265, 29.948405092906928, "İzmit", 0], //İzmit
  [41.0699717868362, 30.15258806142084, "Kandıra", 0], //Kandıra
  [40.754114886630546, 30.022028942013034, "Kartepe", 0] //Kartepe
];
//senaryo 4
final locArray4 = [
  [40.832885682326214, 29.36984166460072, "Çayırova", 0], //Cayırova
  [40.7737725329276, 29.400274319251032, "Darıca", 0], //Darıca
  [40.80270625063124, 29.438109559325984, "Gebze", 40], //Gebze
  [40.78472295356009, 29.535900584593907, "Dilovası", 0], //Dilovası
  [40.77630774450331, 29.73598998793284, "Körfez", 0], //Körfez
  [40.755681531821445, 29.831249500201313, "Derince", 0], //Derince
  [40.69128966303792, 29.61747769400684, "Karamürsel", 50], //Karamürsel
  [40.71617585652615, 29.820569259277022, "Gölcük", 0], //Gölcük
  [40.71408084044044, 29.928567219270928, "Başiskele", 0], //Başiskele
  [40.776438630930265, 29.948405092906928, "İzmit", 0], //İzmit
  [41.0699717868362, 30.15258806142084, "Kandıra", 0], //Kandıra
  [40.754114886630546, 30.022028942013034, "Kartepe", 10] //Kartepe
];

class AddPassenger extends StatefulWidget {
  const AddPassenger({Key key}) : super(key: key);

  @override
  State<AddPassenger> createState() => _AddPassengerState();
}

class _AddPassengerState extends State<AddPassenger> {
  final passengerLoc = TextEditingController();
  final countOfPassenger = TextEditingController();

  Future<void> dataolustur(sayac) async {
    for (int i = 0; i < locArray1.length; i++) {
      if (sayac == 1) {
        await FirebaseFirestore.instance
            .collection("passengers")
            .doc("passengerRequest")
            .update({
          "passengers": FieldValue.arrayUnion([
            {
              "locX": locArray1[i][0],
              "locY": locArray1[i][1],
              "isRealUser": false,
              "count": locArray1[i][3],
              "state": "unknown",
              "email": "",
              "district": locArray1[i][2],
            }
          ])
        });
      } else if (sayac == 2) {
        await FirebaseFirestore.instance
            .collection("passengers")
            .doc("passengerRequest")
            .update({
          "passengers": FieldValue.arrayUnion([
            {
              "locX": locArray2[i][0],
              "locY": locArray2[i][1],
              "isRealUser": false,
              "count": locArray2[i][3],
              "state": "unknown",
              "email": "",
              "district": locArray2[i][2],
              //"stationName": locArray1[i][2],
            }
          ])
        });
      } else if (sayac == 3) {
        await FirebaseFirestore.instance
            .collection("passengers")
            .doc("passengerRequest")
            .update({
          "passengers": FieldValue.arrayUnion([
            {
              "locX": locArray3[i][0],
              "locY": locArray3[i][1],
              "isRealUser": false,
              "count": locArray3[i][3],
              "state": "unknown",
              "email": "",
              "district": locArray3[i][2],
              //"stationName": locArray1[i][2],
            }
          ])
        });
      } else if (sayac == 4) {
        await FirebaseFirestore.instance
            .collection("passengers")
            .doc("passengerRequest")
            .update({
          "passengers": FieldValue.arrayUnion([
            {
              "locX": locArray4[i][0],
              "locY": locArray4[i][1],
              "isRealUser": false,
              "count": locArray4[i][3],
              "state": "unknown",
              "email": "",
              "district": locArray4[i][2],
              //"stationName": locArray1[i][2],
            }
          ])
        });
      }
    }
  }

  Future<void> pushFirebase(locX, locY, district) async {
    //print(locX);
    //print(locY);
    await FirebaseFirestore.instance
        .collection("passengers")
        .doc("passengerRequest")
        .update({
      "passengers": FieldValue.arrayUnion([
        {
          "locX": locX,
          "locY": locY,
          "isRealUser": false,
          "count": int.tryParse(countOfPassenger.text),
          "state": "unknown",
          "email": "",
          "district": district,
        }
      ])
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePageAdmin(email: "kenan@gmail.com")),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var loc = [0.0, 0.0];
    var ilce;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        text: "Add Passenger",
        widget: SizedBox(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: "Senaryo 1",
                onpressed: () {
                  setState(() {
                    sayac = 1;
                  });
                  dataolustur(sayac).whenComplete(() => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePageAdmin(email: "kenan@gmail.com")),
                            (Route<dynamic> route) => false),
                        locArray1.clear()
                      });
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Senaryo 2",
                onpressed: () {
                  setState(() {
                    sayac = 2;
                  });
                  dataolustur(sayac).whenComplete(() => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePageAdmin(email: "kenan@gmail.com")),
                            (Route<dynamic> route) => false),
                        locArray1.clear()
                      });
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Senaryo 3",
                onpressed: () {
                  setState(() {
                    sayac = 3;
                  });
                  dataolustur(sayac).whenComplete(() => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePageAdmin(email: "kenan@gmail.com")),
                            (Route<dynamic> route) => false),
                        locArray1.clear()
                      });
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: "Senaryo 4",
                onpressed: () {
                  setState(() {
                    sayac = 4;
                  });
                  dataolustur(sayac).whenComplete(() => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePageAdmin(email: "kenan@gmail.com")),
                            (Route<dynamic> route) => false),
                        locArray1.clear()
                      });
                },
              ),

              /*Image.asset("assets/images/login.jpg"),
              CustomTextField(
                  topPadding: size.height * 0.02,
                  controller: passengerLoc,
                  hintText: "District",
                  suffixIcon: Icon(Icons.location_city),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {}),
              CustomTextField(
                  topPadding: size.height * 0.02,
                  controller: countOfPassenger,
                  hintText: "Number of Passengers",
                  suffixIcon: Icon(Icons.people),
                  readonly: false,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (String value) {}),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                onpressed: () {
                  if (passengerLoc.text.isNotEmpty &&
                      countOfPassenger.text.isNotEmpty) {
                    setState(() {
                      switch (passengerLoc.text) {
                        case "Çayırova":
                          loc[0] = 40.832885682326214;
                          loc[1] = 29.36984166460072;
                          ilce = "Çayırova";
                          break;
                        case "Darıca":
                          loc[0] = 40.7737725329276;
                          loc[1] = 29.400274319251032;
                          ilce = "Darıca";
                          break;
                        case "Gebze":
                          loc[0] = 40.80270625063124;
                          loc[1] = 29.438109559325984;
                          ilce = "Gebze";
                          break;
                        case "Dilovası":
                          loc[0] = 40.78472295356009;
                          loc[1] = 29.535900584593907;
                          ilce = "Dilovası";
                          break;
                        case "Körfez":
                          loc[0] = 40.77630774450331;
                          loc[1] = 29.73598998793284;
                          ilce = "Körfez";
                          break;
                        case "Derince":
                          loc[0] = 40.755681531821445;
                          loc[1] = 29.831249500201313;
                          ilce = "Derince";
                          break;
                        case "Karamürsel":
                          loc[0] = 40.69128966303792;
                          loc[1] = 29.61747769400684;
                          ilce = "Karamürsel";
                          break;
                        case "Gölcük":
                          loc[0] = 40.71617585652615;
                          loc[1] = 29.820569259277022;
                          ilce = "Gölcük";
                          break;
                        case "Başiskele":
                          loc[0] = 40.71408084044044;
                          loc[1] = 29.928567219270928;
                          ilce = "Başiskele";
                          break;
                        case "İzmit":
                          loc[0] = 40.776438630930265;
                          loc[1] = 29.948405092906928;
                          ilce = "İzmit";
                          break;
                        case "Kartepe":
                          loc[0] = 40.754114886630546;
                          loc[1] = 30.022028942013034;
                          ilce = "Kartepe";
                          break;
                        case "Kandıra":
                          loc[0] = 41.0699717868362;
                          loc[1] = 30.15258806142084;
                          ilce = "Kandıra";
                          break;
                      }
                      pushFirebase(loc[0], loc[1], ilce);
                    });
                  }
                },
                text: "Add",
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
