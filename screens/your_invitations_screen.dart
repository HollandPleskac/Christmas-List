import 'package:flutter/material.dart';
import 'package:name_gifts/screens/invitations_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Business_Logic/fire.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Firestore _firestore = Firestore.instance;
final _fire = Fire();

class YourInvitationsScreen extends StatefulWidget {
  static const routeName = 'your-invitations-screen';
  @override
  _YourInvitationsScreenState createState() => _YourInvitationsScreenState();
}

class _YourInvitationsScreenState extends State<YourInvitationsScreen> {
  var userUid = '';
  var eventId = '';

  Future getUserUid() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    String uid = currentUser.uid;
    userUid = uid;
    print(uid);
  }

  Future getEventId(uid) async {
    String eventID = await _firestore
        .collection("UserData")
        .document(uid)
        .get()
        .then((documentSnapshot) => documentSnapshot.data['selected event']);
    eventId = eventID;
    print(eventId);
  }

  @override
  void initState() {
    getUserUid().then((_) {
      print("got uid");
      getEventId(userUid).then((_) {
        print("got event id");
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final String _eventName = routeArguments['event name'];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('My invitations'),
        ),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('UserData')
            .document(userUid)
            .collection('invites')
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
                    return recievedInvitation(
                      context,
                      document['event name'],
                      document['host'],
                      userUid,
                      document.documentID,
                    );
                  },
                ).toList(),
              );
          }
        },
      ),
    );
  }
}

Widget recievedInvitation(BuildContext context, String name, String host,
    String uid, String eventId) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.04,
    width: double.infinity,
    child: RaisedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text('Event Name : ' + name),
          Text(
            'from : ' + host,
          ),
        ],
      ),
      onPressed: () {
        _fire.acceptInvite(name, uid, host, eventId);
      },
    ),
  );
}
