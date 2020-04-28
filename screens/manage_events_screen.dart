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

  var userUid = '';
  String eventData = 'loading';

  Future getUserUid() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    String uid = currentUser.uid;
    userUid = uid;
    print(uid);
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
      checkYourEventData(userUid).then((_) {
        print("checked if you have an events");
        setState(() {});
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
                                _fire.createEvent(_eventNameController.text,
                                    userUid, host, true);
                                setState(
                                  () {},
                                );
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
                            return event(context, document['event name'],
                                document.documentID, document['hosting']);
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
        Text(
          'You have no events',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text(
          'Create an event with the plus or join an event from the invitations page',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Widget event(BuildContext context, String name, String eventUID, bool hosting) {
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
