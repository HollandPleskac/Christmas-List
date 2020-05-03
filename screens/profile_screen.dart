import 'package:flutter/material.dart';

import './settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Center(
          child: Text('Profile'),
        ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.13,
          ),
        ],
      ),
      body: background(context),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.075,
        ),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            // this makes sure this thing is a circle :)
            borderRadius: BorderRadius.circular(100000000000000000000),
            side: BorderSide(
              color: Color.fromRGBO(37, 151, 234, 1),
              width: 2,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.settings,
            size: 26,
            color: Color.fromRGBO(37, 151, 234, 1),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

Widget background(BuildContext context) {
  return Container(
    color: Colors.transparent,
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.675,
    child: Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
          ),
          profilePic(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          text(context, 'Doug and Janel'),
        ],
      ),
    ),
  );
}

Widget profilePic(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.205,
    width: MediaQuery.of(context).size.height * 0.205,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: Colors.black,
        width: 3,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.network(
        'https://i.pinimg.com/originals/9e/e8/9f/9ee89f7623acc78fc33fc0cbaf3a014b.jpg',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget text(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.black, fontSize: 34),
  );
}
