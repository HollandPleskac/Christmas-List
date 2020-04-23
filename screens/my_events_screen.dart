import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final _fire = Fire();

class MyEventsScreen extends StatefulWidget {
  static const routeName = 'my-events-screen';
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {


  @override


  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final String _uid = routeArguments['uid'];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('My Events'),
        ),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("UserData")
            .document(_uid)
            .collection('my events')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return Column(
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    return event(context, document['event name'],
                        document.documentID, document['hosting']);
                  },
                ).toList(),
              );
          }
        },
      ),
    );
  }
}

Widget event(BuildContext context, String name, String eventUID, bool hosting) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.8,
        child: RaisedButton(
          onPressed: () async {
            FirebaseUser _currentUser = await _firebaseAuth.currentUser();
            _fire.setSelectedEvent(_currentUser.uid, eventUID);
          },
          child: Text(name),
        ),
      ),
    ],
  );
}
