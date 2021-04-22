import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_kit_flutter/widgets/animatedAppBar.dart';
import 'package:material_kit_flutter/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:material_kit_flutter/widgets/bezierContainer.dart';
import 'package:material_kit_flutter/screens/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:material_kit_flutter/constants/Theme.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  AnimationController _ColorAnimationController;

  // ignore: non_constant_identifier_names
  AnimationController _TextAnimationController;
  Animation _colorTween, _homeTween, _drawerTween;

  @override
  void initState() {
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
            begin: Colors.transparent,
            end: (darkmode != null) ? _gettextcolor1() : Colors.white)
        .animate(_ColorAnimationController);
    _drawerTween = ColorTween(
            begin: (darkmode != null) ? _gettextcolor1() : Colors.white,
            end: Colors.black)
        .animate(_ColorAnimationController);
    _homeTween = ColorTween(
            begin: (darkmode != null) ? _gettextcolor1() : Colors.white,
            end: Colors.blue)
        .animate(_ColorAnimationController);
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    setState(() {
      switchValueOne = false;
    });
    super.initState();
  }

  _getuserpreferneces() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      switchValueOne = preferences.getBool("Theme-Mode") ?? false;
      darkmode = switchValueOne;
    });
  }

  void setpreferneces() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("Theme-Mode", switchValueOne);
  }

  _getcolor() {
    return (switchValueOne) ? Colors.black87 : MaterialColors.bgColorScreen;
  }

  _getshadowcolor() {
    return (switchValueOne)
        ? <BoxShadow>[
            BoxShadow(
                color: Colors.grey[850],
                offset: Offset(2, 2),
                blurRadius: 10,
                spreadRadius: 2)
          ]
        : <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ];
  }

  _gettextcolor() {
    return (darkmode) ? Colors.white : Colors.black;
  }

  _gettextcolor1() {
    return (darkmode) ? Color(0xfff7892b) : Colors.white;
  }

  _gettextcolor2() {
    return (darkmode) ? Color(0xfff7892b) : Colors.black;
  }

  _gettxtcolor() {
    return (darkmode) ? Color(0xfff7892b) : Colors.black;
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool scrollListener(ScrollNotification scrollInfo) {
    bool scroll = false;
    if (darkmode != null) {
      setState(() {
        _colorTween = ColorTween(
                begin: Colors.transparent,
                end: (darkmode != null) ? _gettextcolor1() : Colors.white)
            .animate(_ColorAnimationController);
        _drawerTween = ColorTween(
                begin: (darkmode != null) ? _gettextcolor() : Colors.white,
                end: Colors.black)
            .animate(_ColorAnimationController);
        _homeTween = ColorTween(
                begin: Colors.white,
                end: (darkmode != null) ? _gettextcolor2() : Colors.blue)
            .animate(_ColorAnimationController);
      });
    }
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 80);

      _TextAnimationController.animateTo(scrollInfo.metrics.pixels);
      return scroll = true;
    }
    return scroll;
  }

  bool _isprocessing = false, switchValueOne, darkmode;
  File imageFile;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final myemailController = TextEditingController();
  final mypassController = TextEditingController();
  final myusrnamController = TextEditingController();
  final mycpassController = TextEditingController();
  bool ishidden = true;
  IconData passIcon = Icons.visibility_outlined;
  void _togglevisibillity() {
    setState(() {
      ishidden = !ishidden;
    });
  }

  void _togglevisibillityIcon() {
    setState(() {
      if (passIcon == Icons.visibility_outlined)
        passIcon = Icons.visibility_off_outlined;
      else
        passIcon = Icons.visibility_outlined;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    mycpassController.dispose();
    myemailController.dispose();
    mypassController.dispose();
    myusrnamController.dispose();
    super.dispose();
  }

  Future<int> _registerUser() async {
    if (imageFile != null) {
      setState(() {
        _isprocessing = true;
      });
      try {
        final User user = (await _auth.createUserWithEmailAndPassword(
          email: myemailController.text,
          password: mypassController.text,
        ))
            .user;
        String fileName = Path.basename(imageFile.path);
        String imageUrl = "";
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
        await uploadTask
            .whenComplete(() => firebaseStorageRef.getDownloadURL().then(
                  (value) => {print("Done: $value"), imageUrl = value},
                ));
        await _auth.currentUser.updateProfile(
            displayName: myusrnamController.text, photoURL: imageUrl);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("Display-Name", _auth.currentUser.displayName);
        preferences.setString("User-Image-URL", _auth.currentUser.photoURL);
        preferences.setString("Email", _auth.currentUser.email);
        preferences.setString("User-UID", _auth.currentUser.uid);
        setState(() {
          _isprocessing = false;
        });
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("User Registered Sucessful."),
                content: Text(_auth.currentUser.displayName +
                    " has been registered, with User ID: " +
                    user.uid +
                    "."),
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
        return 0;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _isprocessing = false;
          });
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Weak Password."),
                  content: Text(
                      "Your pass word is too weak, Use a strong password for your account security."),
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
          return 1;
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _isprocessing = false;
          });
          await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Email alreday in use."),
                  content: Text("This email address is already registered."),
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
          return 1;
        }
      } catch (e) {
        return 1;
      }
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
      setState(() {
        _isprocessing = false;
      });
    } else {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Profile picture not selected."),
              content: Text(
                  "Please select a profile picture before procceding with registration."),
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
      setState(() {
        _isprocessing = false;
      });
    }
    setState(() {
      _isprocessing = false;
    });
    return 1;
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          if (_isprocessing) {
          } else {
            int res = await _registerUser();
            if (res != 1) {
              Navigator.pushReplacementNamed(context, "/home");
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: (darkmode != null)
                  ? _getshadowcolor()
                  : <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfff7892b), Color.fromRGBO(0, 86, 142, 1)])),
          child: (_isprocessing)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: CupertinoActivityIndicator(
                            radius: 10, animating: true),
                      ),
                      Text(
                        'Registering User',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ])
              : Text(
                  'Register Now',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
        ));
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        if (_isprocessing) {
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  color: (darkmode != null) ? _gettextcolor() : Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: TextStyle(
            fontFamily: "Bosch",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'OS',
              style: TextStyle(
                  fontFamily: "Bosch",
                  color: (darkmode != null) ? _gettextcolor() : Colors.black,
                  fontSize: 30),
            ),
            TextSpan(
              text: 'CH',
              style: TextStyle(
                  fontFamily: "Bosch", color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Full Name',
                style: TextStyle(
                    color: (darkmode != null) ? _gettxtcolor() : Colors.black,
                    fontFamily: "Bosch",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter Full Name.",
                  hintStyle: TextStyle(
                    fontFamily: "Bosch",
                    color: Color(0xffe46b10),
                    fontSize: 15.0,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  prefixIcon: Icon(Icons.person),
                ),
                obscureText: false,
                controller: myusrnamController,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Email',
                style: TextStyle(
                    color: (darkmode != null) ? _gettxtcolor() : Colors.black,
                    fontFamily: "Bosch",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter Email.",
                  hintStyle: TextStyle(
                    fontFamily: "Bosch",
                    color: Color(0xffe46b10),
                    fontSize: 15.0,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                ),
                obscureText: false,
                controller: myemailController,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Password',
                style: TextStyle(
                    color: (darkmode != null) ? _gettxtcolor() : Colors.black,
                    fontFamily: "Bosch",
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter Password.",
                  hintStyle: TextStyle(
                    fontFamily: "Bosch",
                    color: Color(0xffe46b10),
                    fontSize: 15.0,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(passIcon),
                    onPressed: () {
                      _togglevisibillity();
                      _togglevisibillityIcon();
                    },
                  ),
                ),
                obscureText: ishidden,
                controller: mypassController,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    setState(() {
      imageFile = File(pickedFile.path);
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    setState(() {
      imageFile = File(pickedFile.path);
    });
    Navigator.pop(context);
  }

  _getappbarcolor() {
    return (darkmode) ? Colors.white : null;
  }

  @override
  Widget build(BuildContext context) {
    _getuserpreferneces();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor:
            (darkmode != null) ? _getcolor() : MaterialColors.bgColorScreen,
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Sign-up",
          backButton: true,
          bgColor: (darkmode != null) ? _getappbarcolor() : null,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: scrollListener,
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .45,
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .15),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                            onTap: () => {
                                  if (_isprocessing)
                                    {}
                                  else
                                    {_showChoiceDialog(context)}
                                },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: (darkmode != null)
                                        ? _getshadowcolor()
                                        : <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: Offset(2, 4),
                                                blurRadius: 5,
                                                spreadRadius: 2)
                                          ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(0, 86, 142, 1),
                                          Color(0xfff7892b)
                                        ])),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      'Select Profile Picture',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ))),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        SizedBox(height: height * .07),
                        _loginAccountLabel(),
                      ],
                    ),
                  ),
                ),
                AnimatedAppBar(
                  drawerTween: _drawerTween,
                  colorTween: _colorTween,
                  homeTween: _homeTween,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/login");
                  },
                  colorAnimationController: _ColorAnimationController,
                  iconTween: _colorTween,
                  workOutTween: _colorTween,
                )
              ],
            ),
          ),
        ));
  }
}
