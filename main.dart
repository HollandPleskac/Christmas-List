import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:name_gifts/screens/create_event_screen.dart';
import 'package:name_gifts/screens/gifts_screen.dart';
import 'package:name_gifts/screens/profile_screen.dart';
import 'package:name_gifts/screens/settings_screen.dart';

import './screens/welcome_screen.dart';
import './tab_page.dart';
import './screens/gifts_screen.dart';
import './screens/my_events_screen.dart';
import './screens/members_screen.dart';
import './screens/my_gifts_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      routes: {
        MembersScreen.routeName: (ctx) => MembersScreen(),
        MyGiftsScreen.routeName: (ctx) => MyGiftsScreen(),
        CreateEventScreen.routeName: (ctx) => CreateEventScreen(),
        MyEventsScreen.routeName: (ctx) => MyEventsScreen(),
        GiftsScreen.routeName: (ctx) => GiftsScreen(),
      },
    );
  }
}
