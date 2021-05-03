import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final bool transparent;
  final bool rightOptions;
  final Function getCurrentPage;
  final bool noShadow;
  final Color bgColor;

  Navbar(
      {this.title = "Home",
      this.transparent = false,
      this.rightOptions = true,
      this.getCurrentPage,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = Colors.white});

  final double _prefferedHeight = 50.0;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _NavbarState extends State<Navbar> {
  bool darkmode;
  void initState() {
    super.initState();
  }

  _getuserpreferneces() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      darkmode = preferences.getBool("Theme-Mode") ?? false;
    });
  }

  BoxDecoration _boxDecore1() {
    return BoxDecoration(
      color: Colors.transparent,
    );
  }

  BoxDecoration _boxDecore2() {
    return BoxDecoration(
        color: !widget.transparent ? widget.bgColor : Colors.transparent,
        boxShadow: [
          BoxShadow(
              color: !widget.transparent && !widget.noShadow
                  ? Colors.black.withOpacity(0.6)
                  : Colors.transparent,
              spreadRadius: -10,
              blurRadius: 12,
              offset: Offset(0, 5))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    _getuserpreferneces();
    return Container(
        decoration: (widget.title == "Sign-up") ? _boxDecore1() : _boxDecore2(),
        child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                  !widget.backButton
                                      ? Icons.menu
                                      : Icons.arrow_back_ios,
                                  color: !widget.transparent
                                      ? Colors.white
                                      : Colors.transparent,
                                  size: 24.0),
                              onPressed: () {
                                if (!widget.backButton)
                                  Scaffold.of(context).openDrawer();
                                else
                                  Navigator.pop(context);
                              }),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(widget.title,
                                style: TextStyle(
                                    color: !widget.transparent
                                        ? Colors.white
                                        : Colors.transparent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
