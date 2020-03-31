import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:pleskac_christmas_list/screens/sign_in_screen.dart';
import 'package:line_icons/line_icons.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.pushNamed(context, SignInScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(
                0.8, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              const Color(0xFFFFFFEE),
              const Color(0xFF999999)
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.transparent.withOpacity(0.90),
                      radius: 80,
                      child: Icon(
                        Icons.ac_unit,
                        color: Colors.blue[300],
                        size: 110,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Christmas List',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: SpinKitWave(
                  type: SpinKitWaveType.center,
                  color: Colors.blue[200],
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
