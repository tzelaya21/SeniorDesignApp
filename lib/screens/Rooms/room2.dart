import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:material_kit_flutter/constants/Theme.dart';

//widgets
import 'package:material_kit_flutter/widgets/navbar.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Room2 extends StatefulWidget {
  @override
  Room2PageState createState() => Room2PageState();
}

class Room2PageState extends State<Room2> {
  String user, imgUrl;
  bool darkmode = false;
  // ignore: avoid_init_to_null
  Map<String, dynamic> values = null;
  // ignore: non_constant_identifier_names
  int Count = 0;
  String url =
      'https://biani1hvil.execute-api.us-east-1.amazonaws.com/final_testing_stage';

  Future<Map> makeRequest() async {
    var response = await http.get(url);
    var extractData = jsonDecode(response.body);
    return jsonDecode(extractData['body']);
  }

  _getusername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      Count += 1;
      user = preferences.getString("Display-Name") ?? "";
      imgUrl = preferences.getString("User-Image-URL") ?? "";
      darkmode = preferences.getBool("Theme-Mode") ?? "";
    });
    var val = await makeRequest();
    setState(() {
      values = val ?? null;
      Map<String, dynamic> value = {
        'AQI': double.parse(values['AQI'].toString()),
        'O2': double.parse(values['MQ2'].toString()),
        'CO2': double.parse(values['MQ9'].toString()),
        'Temp': double.parse(values['Temp'].toString()),
        'Gas': double.parse(values['MQ5'].toString())
      };
      (values.length <= 7)
          ? values.addEntries(value.entries)
          : print('Read failed.');
    });
  }

  _getcolor() {
    return darkmode ? Colors.black : MaterialColors.bgColorScreen;
  }

  _geto2values() {
    double aqi = (values == null) ? 0.0 : double.parse(values['O2'].toString());
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _geto2angle() {
    double aqi =
        (values == null) ? 601.0 : double.parse(values['O2'].toString());
    double angle = 360 - ((aqi / 601) * 360);
    return angle;
  }

  _geto2color1() {
    double aqi = (values == null) ? 0.0 : double.parse(values['O2'].toString());
    if (aqi >= 0 && aqi <= 325) return Colors.lightGreenAccent[700];
    if (aqi >= 326 && aqi <= 600) return Colors.yellowAccent[700];
    if (aqi >= 601) return Colors.red[800];
  }

  _geto2color2() {
    double aqi = (values == null) ? 0.0 : double.parse(values['O2'].toString());
    if (aqi >= 0 && aqi <= 325) return Colors.lightGreenAccent[400];
    if (aqi >= 326 && aqi <= 600) return Colors.yellowAccent[600];
    if (aqi >= 601) return Colors.red[600];
  }

  _geto2color3() {
    double aqi = (values == null) ? 0.0 : double.parse(values['O2'].toString());
    if (aqi >= 0 && aqi <= 325) return Colors.lightGreenAccent;
    if (aqi >= 326 && aqi <= 600) return Colors.yellowAccent;
    if (aqi >= 601) return Colors.red;
  }

  _getco2values() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['CO2'].toString());
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _getco2angle() {
    double aqi =
        (values == null) ? 501.0 : double.parse(values['CO2'].toString());
    double angle = 360 - ((aqi / 501) * 360);
    return angle;
  }

  _getco2color1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['CO2'].toString());
    if (aqi >= 0 && aqi <= 350) return Colors.lightGreenAccent[700];
    if (aqi >= 351 && aqi <= 500) return Colors.yellowAccent[700];
    if (aqi >= 501) return Colors.red[800];
  }

  _getco2color2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['CO2'].toString());
    if (aqi >= 0 && aqi <= 350) return Colors.lightGreenAccent[400];
    if (aqi >= 351 && aqi <= 500) return Colors.yellowAccent[600];
    if (aqi >= 501) return Colors.red[600];
  }

  _getco2color3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['CO2'].toString());
    if (aqi >= 0 && aqi <= 350) return Colors.lightGreenAccent;
    if (aqi >= 351 && aqi <= 500) return Colors.yellowAccent;
    if (aqi >= 501) return Colors.red;
  }

  _gettempvalues(int type) {
    if (type == 1) {
      double aqi =
          (values == null) ? 0.0 : double.parse(values['Temp'].toString());
      return "${aqi.toStringAsFixed(1).toString()}";
    } else {
      double aqi =
          (values == null) ? 0.0 : double.parse(values['Temp'].toString());
      aqi = (aqi * (9 / 5)) + 32;
      return "${aqi.toStringAsFixed(1).toString()}";
    }
  }

  _gettempangle() {
    double aqi =
        (values == null) ? 110.0 : double.parse(values['Temp'].toString());
    double angle = 360 - ((aqi / 110) * 360);
    return angle;
  }

  _gettempcolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Temp'].toString());
    if (aqi >= -10 && aqi <= 25) return Colors.lightGreenAccent[700];
    if (aqi >= 26 && aqi <= 65) return Colors.yellowAccent[700];
    if (aqi >= 66) return Colors.red[800];
  }

  _gettempcolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Temp'].toString());
    if (aqi >= -10 && aqi <= 25) return Colors.lightGreenAccent[400];
    if (aqi >= 26 && aqi <= 65) return Colors.yellowAccent[600];
    if (aqi >= 66) return Colors.red[600];
  }

  _gettempcolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Temp'].toString());
    if (aqi >= -10 && aqi <= 25) return Colors.lightGreenAccent;
    if (aqi >= 26 && aqi <= 65) return Colors.yellowAccent;
    if (aqi >= 66) return Colors.red;
  }

  _getdustvalues() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['PPM'].toString());
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _getdustangle() {
    double aqi =
        (values == null) ? 1051.0 : double.parse(values['PPM'].toString());
    double angle = 360 - ((aqi / 110) * 360);
    return angle;
  }

  _getdustcolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['PPM'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent[700];
    if (aqi >= 51 && aqi <= 150) return Colors.limeAccent[700];
    if (aqi >= 151 && aqi <= 1050) return Colors.yellowAccent[700];
    if (aqi >= 1051) return Colors.red[800];
  }

  _getdustcolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['PPM'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent[400];
    if (aqi >= 51 && aqi <= 150) return Colors.limeAccent[400];
    if (aqi >= 151 && aqi <= 1050) return Colors.yellowAccent[600];
    if (aqi >= 1051) return Colors.red[600];
  }

  _getdustcolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['PPM'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent;
    if (aqi >= 51 && aqi <= 150) return Colors.limeAccent;
    if (aqi >= 151 && aqi <= 1050) return Colors.yellowAccent;
    if (aqi >= 1051) return Colors.red;
  }

  _gethumidityvalues() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Humidity'].toString());
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _gethumidityangle() {
    double aqi =
        (values == null) ? 76.0 : double.parse(values['Humidity'].toString());
    double angle = 360 - ((aqi / 76) * 360);
    return angle;
  }

  _gethumiditycolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Humidity'].toString());
    if (aqi >= 0 && aqi <= 55) return Colors.lightGreenAccent[700];
    if (aqi >= 56 && aqi <= 70) return Colors.yellowAccent[700];
    if (aqi >= 71) return Colors.red[800];
  }

  _gethumiditycolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Humidity'].toString());
    if (aqi >= 0 && aqi <= 55) return Colors.lightGreenAccent[400];
    if (aqi >= 56 && aqi <= 70) return Colors.yellowAccent[600];
    if (aqi >= 71) return Colors.red[600];
  }

  _gethumiditycolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Humidity'].toString());
    if (aqi >= 0 && aqi <= 55) return Colors.lightGreenAccent;
    if (aqi >= 56 && aqi <= 70) return Colors.yellowAccent;
    if (aqi >= 71) return Colors.red;
  }

  _getpropanevalues() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['MQ9'].toString());
    aqi -= 15;
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _getpropaneangle() {
    double aqi =
        (values == null) ? 276 : double.parse(values['MQ9'].toString());
    aqi -= 15;
    double angle = 360 - ((aqi / 276) * 360);
    return angle;
  }

  _getpropanecolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['MQ9'].toString());
    aqi -= 15;
    if (aqi >= 0 && aqi <= 190) return Colors.lightGreenAccent[700];
    if (aqi >= 191 && aqi <= 275) return Colors.yellowAccent[700];
    if (aqi >= 276) return Colors.red[800];
  }

  _getpropanecolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['MQ9'].toString());
    aqi -= 15;
    if (aqi >= 0 && aqi <= 190) return Colors.lightGreenAccent[400];
    if (aqi >= 191 && aqi <= 275) return Colors.yellowAccent[600];
    if (aqi >= 276) return Colors.red[600];
  }

  _getpropanecolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['MQ9'].toString());
    aqi -= 15;
    if (aqi >= 0 && aqi <= 190) return Colors.lightGreenAccent;
    if (aqi >= 191 && aqi <= 275) return Colors.yellowAccent;
    if (aqi >= 276) return Colors.red;
  }

  _getgasvalues() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Gas'].toString());
    return "${aqi.toStringAsFixed(1).toString()}";
  }

  _getgasangle() {
    double aqi =
        (values == null) ? 201.0 : double.parse(values['Gas'].toString());
    double angle = 360 - ((aqi / 201) * 360);
    return angle;
  }

  _getgascolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Gas'].toString());
    if (aqi >= 0 && aqi <= 125) return Colors.lightGreenAccent[700];
    if (aqi >= 126 && aqi <= 200) return Colors.yellowAccent[700];
    if (aqi >= 201) return Colors.red[800];
  }

  _getgascolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Gas'].toString());
    if (aqi >= 0 && aqi <= 125) return Colors.lightGreenAccent[400];
    if (aqi >= 126 && aqi <= 200) return Colors.yellowAccent[600];
    if (aqi >= 201) return Colors.red[600];
  }

  _getgascolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['Gas'].toString());
    if (aqi >= 0 && aqi <= 125) return Colors.lightGreenAccent;
    if (aqi >= 126 && aqi <= 200) return Colors.yellowAccent;
    if (aqi >= 201) return Colors.red;
  }

  _getaqivalues() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['AQI'].toString());
    double percentage = 100 - ((aqi / 351) * 100);
    return "${percentage.toStringAsFixed(1).toString()}%\nAQ Index: ${aqi.toStringAsFixed(1).toString()}";
  }

  _getaqiangle() {
    double aqi =
        (values == null) ? 351.0 : double.parse(values['AQI'].toString());
    double angle = 360 - ((aqi / 351) * 360);
    return angle;
  }

  _getaqicolor1() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['AQI'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent[700];
    if (aqi >= 51 && aqi <= 100) return Colors.yellowAccent[700];
    if (aqi >= 101 && aqi <= 150) return Colors.deepOrange[700];
    if (aqi >= 151 && aqi <= 200) return Colors.red[800];
    if (aqi >= 201 && aqi <= 300) return Colors.purple[700];
    if (aqi >= 301) return Color.fromARGB(255, 126, 0, 35);
  }

  _getaqicolor2() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['AQI'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent[400];
    if (aqi >= 51 && aqi <= 100) return Colors.yellowAccent[400];
    if (aqi >= 101 && aqi <= 150) return Colors.deepOrange[600];
    if (aqi >= 151 && aqi <= 200) return Colors.red[600];
    if (aqi >= 201 && aqi <= 300) return Colors.purple[600];
    if (aqi >= 301) return Color.fromARGB(255, 126, 0, 35);
  }

  _getaqicolor3() {
    double aqi =
        (values == null) ? 0.0 : double.parse(values['AQI'].toString());
    if (aqi >= 0 && aqi <= 50) return Colors.lightGreenAccent;
    if (aqi >= 51 && aqi <= 100) return Colors.yellowAccent;
    if (aqi >= 101 && aqi <= 150) return Colors.deepOrange;
    if (aqi >= 151 && aqi <= 200) return Colors.red;
    if (aqi >= 201 && aqi <= 300) return Colors.purple;
    if (aqi >= 301) return Color.fromARGB(255, 126, 0, 35);
  }

  @override
  Widget build(BuildContext context) {
    (Count == 0) ? _getusername() : print("Welcome.");
    return Scaffold(
        appBar: Navbar(
          title: "Room-2",
          bgColor: Color.fromRGBO(0, 86, 142, 1),
        ),
        backgroundColor:
            darkmode != null ? _getcolor() : MaterialColors.bgColorScreen,
        drawer:
            MaterialDrawer(currentPage: "Room-2", user: user, imgUrl: imgUrl),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/bg.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 175,
                            height: 175,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(200.0),
                              ),
                              border: new Border.all(
                                  width: 4,
                                  color: Colors.blue[500].withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Air Quality',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Bosch",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.0,
                                    color: Colors.blue[300],
                                  ),
                                ),
                                (values == null)
                                    ? CupertinoActivityIndicator(
                                        radius: 10, animating: true)
                                    : Text(
                                        _getaqivalues(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Bosch",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: _getaqicolor1(),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomPaint(
                            painter: CurvePainter(colors: [
                              _getaqicolor1(),
                              _getaqicolor2(),
                              _getaqicolor3()
                            ], angle: _getaqiangle()),
                            child: SizedBox(
                              width: 183,
                              height: 183,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Oxygen\n(O2)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _geto2values(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _geto2color1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _geto2color1(),
                                      _geto2color2(),
                                      _geto2color3()
                                    ], angle: _geto2angle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Carbon\nDioxide\n(CO2)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _getco2values(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _getco2color1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _getco2color1(),
                                      _getco2color2(),
                                      _getco2color3()
                                    ], angle: _getco2angle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 330),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Dust',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _getdustvalues(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _getdustcolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _getdustcolor1(),
                                      _getdustcolor2(),
                                      _getdustcolor3()
                                    ], angle: _getdustangle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Humidity',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _gethumidityvalues(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _gethumiditycolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _gethumiditycolor1(),
                                      _gethumiditycolor2(),
                                      _gethumiditycolor3()
                                    ], angle: _gethumidityangle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 460),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Propane',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _getpropanevalues(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _getpropanecolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _getpropanecolor1(),
                                      _getpropanecolor2(),
                                      _getpropanecolor3()
                                    ], angle: _getpropaneangle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Gas\nPresence\n(MQ2)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _getgasvalues(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: _getgascolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _getgascolor1(),
                                      _getgascolor2(),
                                      _getgascolor3()
                                    ], angle: _getgasangle()),
                                    child: SizedBox(
                                      width: 118,
                                      height: 118,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 590),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Temperature',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _gettempvalues(1) + ' °C',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                  color: _gettempcolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _gettempcolor1(),
                                      _gettempcolor2(),
                                      _gettempcolor3()
                                    ], angle: _gettempangle()),
                                    child: SizedBox(
                                      width: 125,
                                      height: 125,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200.0),
                                      ),
                                      border: new Border.all(
                                          width: 4,
                                          color: Colors.blue[500]
                                              .withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Temperature',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Bosch",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            letterSpacing: 0.0,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                        (values == null)
                                            ? CupertinoActivityIndicator(
                                                radius: 10, animating: true)
                                            : Text(
                                                _gettempvalues(2) + ' °F',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  letterSpacing: 0.0,
                                                  color: _gettempcolor1(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: CustomPaint(
                                    painter: CurvePainter(colors: [
                                      _gettempcolor1(),
                                      _gettempcolor2(),
                                      _gettempcolor3()
                                    ], angle: _gettempangle()),
                                    child: SizedBox(
                                      width: 125,
                                      height: 125,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
