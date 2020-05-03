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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var userUid = '';
  var eventId = '';
  var eventName = '';
  String inviteData = 'loading';

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

  Future getEventName(eventId, uid) async {
    try {
      String eeventName = await _firestore
          .collection("Events")
          .document(eventId)
          .collection('members')
          .document(uid)
          .get()
          .then(
            (docSnapshot) => docSnapshot.data['event name'],
          );
      eventName = eeventName;
      print(eventName);
    } catch (_) {
      eventName = null;
    }
  }

  Future checkInviteData(uid) async {
    // try block is needed because without it - it fails to call the invites collection if it isnt there and then it throws an error which means that the value of inviteData never changes
    try {
      String data = await _firestore
          .collection("UserData")
          .document(uid)
          .collection('invites')
          .getDocuments()
          .then(
            (value) => value.documents[0].documentID.toString(),
          );
      if (data == null) {
        inviteData = null;
      } else {
        inviteData = 'true';
      }
    } catch (_) {
      inviteData = null;
    }

    // value is a query snapshot of documents
  }

  @override
  void initState() {
    getUserUid().then((_) {
      print("got uid");
      getEventId(userUid).then((_) {
        print('got event id');
        getEventName(eventId, userUid).then((_) {
          print('got event data');
          checkInviteData(userUid).then((_) {
            print("checked invite data");
            setState(() {});
          });
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
          child: Text('Invitations'),
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
                            controller: _inviteController,
                          ),
                          RaisedButton(
                            child: Text('click to send invitation'),
                            onPressed: () async {
                              // getting host's email
                              FirebaseUser _user =
                                  await _firebaseAuth.currentUser();
                              String hostEmailAddress = await _firestore
                                  .collection('UserData')
                                  .document(_user.uid)
                                  .get()
                                  .then((docSnapshot) =>
                                      docSnapshot.data['email']);
                              // successfully got the host's email address

                              _fire.sendInvite(
                                  userUid,
                                  eventId,
                                  _inviteController.text,
                                  eventName,
                                  hostEmailAddress);
                            },
                          ),
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
      body: inviteData == null
          ? noInvitations(context)
          : StreamBuilder(
              stream: _firestore
                  .collection('UserData')
                  .document(userUid)
                  .collection('invites')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error : ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return Column(
                      children: snapshot.data.documents.map(
                        (DocumentSnapshot document) {
                          if (document['invite type'] == 'event') {
                            return recievedInvitationForEvent(
                              context,
                              document['event name'],
                              document['host'],
                              userUid,
                              document.documentID,
                            );
                          } else {
                            return recienvedInvitationForFamily(
                                context,
                                document['event name'],
                                document['host'],
                                userUid,
                                eventId);
                          }
                        },
                      ).toList(),
                    );
                }
              },
            ),
    );
  }
}

Widget noInvitations(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
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
  );
}

Widget recievedInvitationForEvent(BuildContext context, String name,
    String host, String uid, String eventId) {
  TextEditingController _displayNameForEventController =
      TextEditingController();

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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'adding to event display name',
                  style: TextStyle(
                      color: Colors.red[800], fontWeight: FontWeight.w800),
                ),
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: _displayNameForEventController,
                      decoration: InputDecoration(
                          hintText:
                              'enter the name that you would like to be known as in the event'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        _fire.acceptInviteToEvent(name, uid, host, eventId,
                            _displayNameForEventController.text);
                        Navigator.pop(context);
                      },
                      child: Text('enter'),
                    )
                  ],
                ),
              );
            });
      },
    ),
  );
}

Widget recienvedInvitationForFamily(BuildContext context, String name,
    String host, String uid, String eventId) {
  TextEditingController _familyMemberNameController = TextEditingController();

  return Container(
    height: MediaQuery.of(context).size.height * 0.04,
    width: double.infinity,
    child: RaisedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[Text('family invite')],
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  'adding to family',
                  style: TextStyle(
                      color: Colors.red[800], fontWeight: FontWeight.w800),
                ),
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: _familyMemberNameController,
                      decoration: InputDecoration(
                          hintText:
                              'enter the name that you would like to be known as in family'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        _fire.acceptInviteToFamily(
                            uid, eventId, _familyMemberNameController.text);
                        Navigator.pop(context);
                      },
                      child: Text('enter'),
                    )
                  ],
                ),
              );
            });
      },
    ),
  );
}
