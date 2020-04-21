import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './invitations_screen.dart';
import './my_events_screen.dart';
import './create_event_screen.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Center(
          child: Text('Events'),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            button(context, 'View My Events', Color.fromRGBO(37, 151, 234, 1),
                () async {
              FirebaseUser _currentUser = await _firebaseAuth.currentUser();
              Navigator.pushNamed(
                context,
                MyEventsScreen.routeName,
                arguments: {
                  'uid': _currentUser.uid,
                },
              );
            }),
            button(context, 'Create an Event', Color.fromRGBO(206, 37, 234, 1),
                () async {
              FirebaseUser _currentUser = await _firebaseAuth.currentUser();
              Navigator.pushNamed(
                context,
                CreateEventScreen.routeName,
                arguments: {
                  'uid': _currentUser.uid,
                },
              );
            }),
            button(
                context,
                'Join an Event',
                Color.fromRGBO(222, 157, 59, 1),
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvitationsScreen(),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

Widget button(
    BuildContext context, String name, Color color, Function function) {
  return Column(
    children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.8,
        child: RaisedButton(
          onPressed: function,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      )
    ],
  );
}
