import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:name_gifts/screens/view_family_screen.dart';

import '../tab_page.dart';
import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final _fire = Fire();

class ManageEventsScreen extends StatefulWidget {
  static const routeName = 'my-events-screen';
  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _displayNameForEventController =
      TextEditingController();

  var userUid = '';
  var eventId = '';
  String eventData = 'loading';

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

  Future checkYourEventData(uid) async {
    try {
      String data = await _firestore
          .collection("UserData")
          .document(uid)
          .collection('my events')
          .getDocuments()
          .then(
            (value) => value.documents[0].documentID.toString(),
          );
      if (data == null) {
        eventData = null;
      } else {
        eventData = 'true';
      }
    } catch (_) {
      eventData = null;
    }

    // value is a query snapshot of documents
  }

  @override
  void initState() {
    getUserUid().then((_) {
      print('got uid');
      getEventId(userUid).then((value) {
        print('got event id');
        checkYourEventData(userUid).then((_) {
          print("checked if you have an events");
          setState(() {});
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Center(
          child: Text('Manage Events'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _eventNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(126, 126, 126, 1),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey[700],
                              ),
                              hintText: 'name of event',
                              icon: Icon(Icons.adb),
                            ),
                          ),
                          TextFormField(
                            controller: _displayNameForEventController,
                            decoration:
                                InputDecoration(hintText: 'your name in event'),
                          ),
                          RaisedButton(
                              child: Text('create event'),
                              onPressed: () async {
                                String host = await _firestore
                                    .collection("UserData")
                                    .document(userUid)
                                    .get()
                                    .then(
                                      (docSnapshot) =>
                                          docSnapshot.data['email'],
                                    );
                                _fire.createEvent(
                                  _eventNameController.text,
                                  userUid,
                                  host,
                                  eventId,
                                  _displayNameForEventController.text,
                                );
                                setState(() {});
                                Navigator.pop(context);

                                ///
                                /// show dialog to join event with an event name!!
                                ///

                                ///
                                ///
                                ///
                              })
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: eventData == null
          ? noEvents(context)
          : StreamBuilder(
              stream: _firestore
                  .collection("UserData")
                  .document(userUid)
                  .collection('my events')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return Center(
                      child: ListView(
                        children: snapshot.data.documents.map(
                          (DocumentSnapshot document) {
                            // event type does not exist so make it exist in firebase
                            //should be a condition that tells this method if the event is u are part of family or if you are a full member
                            if (document['event type'] == 'event') {
                              return event(context, document['event name'],
                                  document.documentID);
                            } else {
                              return familyMemberInEvent(
                                  context, document['event name'], document.documentID);
                            }
                          },
                        ).toList(),
                      ),
                    );
                }
              },
            ),
    );
  }
}

Widget noEvents(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Text(
          'You have no events',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text(
          'Create an event with the plus',
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text('Join an event from the invitations page'),
      ],
    ),
  );
}

Widget event(BuildContext context, String name, String eventUID) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.0525,
        width: MediaQuery.of(context).size.width * 0.82,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.grey[100],
            ),
          ),
          elevation: 3,
          color: Colors.white,
          onPressed: () async {
            FirebaseUser _currentUser = await _firebaseAuth.currentUser();
            _fire.setSelectedEvent(_currentUser.uid, eventUID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TabPage(),
              ),
            );
          },
          child: Text(
            name,
            style: TextStyle(
                color: Color.fromRGBO(37, 151, 234, 1),
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}

Widget familyMemberInEvent(BuildContext context, String name, String eventUID) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.0525,
        width: MediaQuery.of(context).size.width * 0.82,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.grey[100],
            ),
          ),
          elevation: 3,
          color: Colors.red,
          onPressed: () async {
            FirebaseUser _currentUser = await _firebaseAuth.currentUser();
            _fire.setSelectedEvent(_currentUser.uid, eventUID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TabPage(),
              ),
            );
          },
          child: Text(
            name,
            style: TextStyle(
                color: Color.fromRGBO(37, 151, 234, 1),
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
