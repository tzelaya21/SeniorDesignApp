import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:material_kit_flutter/services/fireStoreService.dart';
import 'package:material_kit_flutter/widgets/button_widget.dart';
import 'package:material_kit_flutter/widgets/drawer.dart';
import 'package:material_kit_flutter/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';
  // ignore: non_constant_identifier_names
  String user, imgUrl, user_UID;
  bool darkmode;

  _getusername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("Display-Name") ?? "";
      imgUrl = preferences.getString("User-Image-URL") ?? "";
      user_UID = preferences.getString("User-UID") ?? "";
      darkmode = preferences.getBool("Theme-Mode") ?? "";
    });
  }

  _getcolor() {
    return (darkmode) ? Colors.black87 : MaterialColors.bgColorScreen;
  }

  _gettextcolor() {
    return (darkmode) ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    _getusername();
    return Scaffold(
        appBar: Navbar(
          title: "QR-Code Scanner",
          bgColor: Colors.blue,
        ),
        backgroundColor:
            (darkmode != null) ? _getcolor() : MaterialColors.bgColorScreen,
        drawer: MaterialDrawer(
            currentPage: "QR-Code Scanner", user: user, imgUrl: imgUrl),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/bg.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: Text(
                    'Scan Result',
                    style: TextStyle(
                      fontFamily: 'Bosch',
                      fontSize: 24,
                      color:
                          (darkmode != null) ? _gettextcolor() : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    qrCode,
                    style: TextStyle(
                      fontFamily: 'Bosch',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color:
                          (darkmode != null) ? _gettextcolor() : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 420),
                ButtonWidget(
                  text: 'Start QR scan',
                  onClicked: () => scanQRCode(),
                ),
                ButtonWidget(
                  text: 'Save Result',
                  onClicked: () => saveToFireStore(),
                ),
                ButtonWidget(
                  text: 'Show Result',
                  onClicked: () => readFromFireStore(),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> readFromFireStore() async {
    if (user_UID != "") {
      try {
        Map<String, dynamic> results =
            await DB_service_write(uid: user_UID).getuserData();
        if (results.length >= 1) {
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Device Found."),
                  content: Text(
                      "Your device has been registered, under the User-ID: $user_UID & Device-ID: ${results['Device-ID']}."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Device not found."),
                  content: Text(
                      "No device is registered with the User-ID kindly register your Device-ID first, by scanning it's Qr-Code on the back."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      } catch (e) {
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Error."),
                content: Text(
                    "Your request can not be processed at the moment, Try again later."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Error."),
              content: Text(
                  "Your request can not be processed at the moment, Try again later."),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> saveToFireStore() async {
    if (user_UID != "") {
      try {
        if (qrCode == "Unknown" ||
            qrCode == "-1" ||
            qrCode == "Failed to get platform version.") {
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Error."),
                  content: Text(
                      "Your request can not be processed at this moment, Please Scan again your device's Qr-code and try again."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else {
          await DB_service_write(uid: user_UID).setuserData(qrCode);
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Device Registered."),
                  content: Text(
                      "Your device has been registered, under the User-ID: $user_UID & Device-ID: $qrCode ."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      } catch (e) {
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Error."),
                content: Text(
                    "Your request can not be processed at the moment, Try again later."),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Error."),
              content: Text(
                  "Your request can not be processed at the moment, Try again later."),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
