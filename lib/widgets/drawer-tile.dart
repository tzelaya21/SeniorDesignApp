import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      {this.title,
      this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = Colors.black});

  @override
  State<StatefulWidget> createState() => DrawerTileState();
}

class DrawerTileState extends State<DrawerTile> {
  bool darkmode;
  _getuserpreferneces() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      darkmode = preferences.getBool("Theme-Mode") ?? false;
    });
  }

  _getcolor2() {
    return (darkmode) ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    _getuserpreferneces();
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? Color.fromRGBO(0, 86, 142, 1)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Icon(widget.icon,
                      size: 20,
                      color: widget.isSelected
                          ? ((darkmode != null) ? Colors.white : Colors.black)
                          : _getcolor2()),
                ),
                Text(widget.title,
                    style: TextStyle(
                        fontSize: 15,
                        color: widget.isSelected
                            ? ((darkmode != null) ? Colors.white : Colors.black)
                            : _getcolor2())),
              ],
            )));
  }
}
