import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();

class InvitationsScreen extends StatefulWidget {
  static const routeName = 'invitations-screen';
  @override
  _InvitationsScreenState createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  TextEditingController _inviteController = TextEditingController();

  var userUid = '';
  var eventId = '';

  Future getUserUid() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    String uid = currentUser.uid;
    userUid = uid;
    print(uid);
  }

  Future getEventId(uid) async {
    String eventID =
        await _firestore.collection("UserData").document(uid).get().then(
              (documentSnapshot) => documentSnapshot.data['selected event'],
            );
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
          child: Text('Invitations'),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _inviteController,
            ),
            RaisedButton(
              child: Text('click to send invitation'),
              onPressed: () async {
                _fire.sendInvite(userUid, eventId, _inviteController.text, _eventName);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            Text('You have no invitations'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Text('Your invitations will be listed here'),
          ],
        ),
      ),
    );
  }
}

Widget invitation(BuildContext context, String name) {
  return Stack(
    children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.98,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.04,
        left: MediaQuery.of(context).size.width * 0.08,
        child: Text('Beardo invited you to ' + name),
      ),
      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.02,
        right: MediaQuery.of(context).size.width * 0.06,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.45,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Color.fromRGBO(37, 151, 234, 1),
            onPressed: () {},
            child: Text(
              'Beardo invited you to ' + name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
  );
}
