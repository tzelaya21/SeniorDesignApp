import 'package:flutter/material.dart';
import 'package:material_kit_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_kit_flutter/screens/signup.dart';
import 'package:material_kit_flutter/widgets/bezierContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  bool _isprocessing = false, switchValueOne, darkmode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final myemailController = TextEditingController();
  final mypassController = TextEditingController();
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
    myemailController.dispose();
    mypassController.dispose();
    super.dispose();
  }

  @override
  void initState() {
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

  _getcolor1() {
    return (switchValueOne) ? Color(0xfff7892b) : null;
  }

  _gettextcolor() {
    return (darkmode) ? Colors.white : Colors.black;
  }

  _gettextcolor1() {
    return (darkmode) ? Color(0xfff7892b) : Colors.black;
  }

  _authenticateUser() async {
    setState(() {
      _isprocessing = true;
    });
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: myemailController.text, password: mypassController.text))
          .user;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("Display-Name", user.displayName);
      preferences.setString("User-Image-URL", user.photoURL);
      preferences.setString("Email", user.email);
      preferences.setString("User-UID", user.uid);
      setState(() {
        _isprocessing = false;
      });
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Login Sucessful."),
              content: Text("Welcome, " + user.displayName + "."),
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
      if (e.code == 'user-not-found') {
        setState(() {
          _isprocessing = false;
        });
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("User not Found."),
                content: Text(
                    "Email is not registered, kindly check the email or register to use the app."),
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
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isprocessing = false;
        });
        await showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Incorrect Password"),
                content: Text(
                    "The password entered is incorrect, kindly enter correct password and try again."),
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
      setState(() {
        _isprocessing = false;
      });
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
    return 1;
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          if (_isprocessing) {
          } else {
            int res = await _authenticateUser();
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
                  colors: [Color.fromRGBO(0, 86, 142, 1), Color(0xfff7892b)])),
          child: (_isprocessing)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Text(
                        'Authenticating User',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: CupertinoActivityIndicator(
                            radius: 10, animating: true),
                      ),
                    ])
              : Text(
                  'Login',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
        ));
  }

  Widget _registerButton() {
    return InkWell(
        onTap: () {
          if (_isprocessing) {
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
          child: Text(
            'Register',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: (darkmode != null) ? _getcolor1() : null,
                thickness: 1,
              ),
            ),
          ),
          Text('or',
              style: TextStyle(
                color: (darkmode != null) ? _gettextcolor() : Colors.black,
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: (darkmode != null) ? _getcolor1() : Colors.black,
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: (darkmode != null) ? _gettextcolor() : Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Register',
            style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _darkmode() {
    final height = MediaQuery.of(context).size.height;
    return Container(
        height: height * .1,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
              child: Icon(
                Icons.nights_stay_outlined,
                size: 25,
                color: (darkmode != null) ? _gettextcolor() : Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
              child: Text("Dark Mode",
                  style: TextStyle(
                    fontSize: 25,
                    color: (darkmode != null) ? _gettextcolor() : Colors.black,
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(160.0, 10.0, 0.0, 0.0),
              child: Switch.adaptive(
                value: switchValueOne,
                onChanged: (bool newValue) => {
                  setState(() => switchValueOne = newValue),
                  setpreferneces()
                },
                activeColor: Color(0xffe46b10),
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: TextStyle(
            fontFamily: "Bosch",
            fontSize: 30,
            fontWeight: FontWeight.w700,
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
                'Email',
                style: TextStyle(
                    color: (darkmode != null) ? _gettextcolor1() : Colors.black,
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
                    color: (darkmode != null) ? _gettextcolor1() : Colors.black,
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

  @override
  Widget build(BuildContext context) {
    _getuserpreferneces();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor:
            (darkmode != null) ? _getcolor() : MaterialColors.bgColorScreen,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .45,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 30),
                      _divider(),
                      _createAccountLabel(),
                      _registerButton(),
                      _darkmode(),
                      SizedBox(height: height * .055),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
