import 'package:flutter/material.dart';
import 'package:name_gifts/screens/gifts_screen.dart';

import './screens/welcome_screen.dart';
import './screens/gifts_screen.dart';
import './screens/manage_events_screen.dart';
import './screens/members_screen.dart';
import './screens/my_gifts_screen.dart';
import './screens/invitations_screen.dart';

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
        ManageEventsScreen.routeName: (ctx) => ManageEventsScreen(),
        GiftsScreen.routeName: (ctx) => GiftsScreen(),
        InvitationsScreen.routeName: (ctx) => InvitationsScreen(),
      },
    );
  }
}

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: screen(context));
//   }
// }

// Widget screen(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: _signInButton(context),
//     ),
//   );
// }

// Widget _signInButton(BuildContext context) {
//   return Container(
//     height: 75,
//     width: 350,
//     child: RaisedButton(
//       onPressed: () {},
//       child: Text('Sign In'),
//     ),
//   );
// }
