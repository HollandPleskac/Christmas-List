import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:name_gifts/screens/view_family_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Settings'),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(243, 243, 243, 1),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            setting(
              context,
              'Linked Accounts',
              Color.fromRGBO(196, 196, 196, 1),
              Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
              () {},
            ),
            setting(
              context,
              'Profile',
              Color.fromRGBO(132, 43, 147, 1),
              Icon(
                Icons.person,
                color: Colors.white,
              ),
              () {},
            ),
          ],
        ),
      ),
    );
  }
}

Widget setting(BuildContext context, String name, Color containerColor,
    Icon setting, Function function) {
  return Column(
    children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        color: Colors.white,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => print('press'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.06,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.08,
                      width: MediaQuery.of(context).size.width * 0.08,
                      child: setting,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.chevron_right,
                      color: Color.fromRGBO(126, 126, 126, 1),
                      size: 26,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Divider(
        height: 1,
      ),
    ],
  );
}
