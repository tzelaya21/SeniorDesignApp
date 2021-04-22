import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/widgets/histogram.dart';

//widgets
import 'package:material_kit_flutter/widgets/navbar.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Home> {
  String user, imgUrl;
  bool darkmode = false;
  Map<String, dynamic> values = {
    'AQI': 41,
    'O2': '72%',
    'CO2': '4%',
    'Dust': '10%',
    'Temp': 13.9,
    'PPM': 500.12
  };
  // ignore: non_constant_identifier_names
  int Count = 0;
  String url =
      'https://9pdvqwmof0.execute-api.us-east-1.amazonaws.com/tester_stage/airQ';

  Future<Map> makeRequest() async {
    var response = await http.get(url);
    var extractData = jsonDecode(response.body);
    return extractData;
  }

  _getusername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      Count += 1;
      user = preferences.getString("Display-Name") ?? "";
      imgUrl = preferences.getString("User-Image-URL") ?? "";
      darkmode = preferences.getBool("Theme-Mode") ?? false;
    });
    var val = await makeRequest();
    setState(() {
      values = val ?? null;
      Map<String, dynamic> value = {
        'AQI': 41,
        'O2': '72%',
        'CO2': '4%',
      };
      (values.length <= 2)
          ? values.addEntries(value.entries)
          : print('Read Sucessful.');
    });
  }

  _getcolor() {
    return (darkmode) ? Colors.black87 : MaterialColors.bgColorScreen;
  }

  @override
  Widget build(BuildContext context) {
    (Count == 0) ? _getusername() : print("Welcome.");
    return Scaffold(
        appBar: Navbar(
          title: "Home",
          bgColor: Colors.blue,
          transparent: false,
        ),
        backgroundColor:
            (darkmode != null) ? _getcolor() : MaterialColors.bgColorScreen,
        drawer: MaterialDrawer(currentPage: "Home", user: user, imgUrl: imgUrl),
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
                                        '83%\nAQ Index: ${values['AQI']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Bosch",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          color: Colors.green[800]
                                              .withOpacity(0.9),
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
                              Colors.blue[900],
                              Color.fromRGBO(138, 152, 232, 1),
                              Color.fromRGBO(138, 152, 232, 1)
                            ], angle: 140 + (360 - 140) * (1.0 - 0.9)),
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
                                                '${values['O2']}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: Colors.green[800]
                                                      .withOpacity(0.9),
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
                                      Colors.blue[900],
                                      Color.fromRGBO(138, 152, 232, 1),
                                      Color.fromRGBO(138, 152, 232, 1)
                                    ], angle: 140 + (360 - 140) * (1.0 - 0.9)),
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
                                                '${values['CO2']}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Bosch",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: Colors.red[800]
                                                      .withOpacity(0.9),
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
                                      Colors.blue[900],
                                      Color.fromRGBO(138, 152, 232, 1),
                                      Color.fromRGBO(138, 152, 232, 1)
                                    ], angle: 140 + (360 - 140) * (1.0 - 0.9)),
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
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 370, 10, 10),
                          child: SizedBox(
                              height: 350,
                              width: 350,
                              child: new CustomRoundedBars.withSampleData()),
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
