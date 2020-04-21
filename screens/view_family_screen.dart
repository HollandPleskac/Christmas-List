import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'members_screen.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ViewFamilyScreen extends StatefulWidget {
  @override
  _ViewFamilyScreenState createState() => _ViewFamilyScreenState();
}

class _ViewFamilyScreenState extends State<ViewFamilyScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('View Family'),
        ),
        leading: Container(),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          StreamBuilder(
            stream: _firestore
                .collection("Events")
                .document(eventId)
                .collection("members")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  return Column(
                    children: snapshot.data.documents.map(
                      (DocumentSnapshot document) {
                        return family(
                          context,
                          document.documentID,
                          document['display name'],
                          document['members'],
                          document['gifts'],
                          eventId,
                        );
                      },
                    ).toList(),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget family(BuildContext context, String uid, String name, int members,
    int gifts, String eventId) {
  return Column(
    children: <Widget>[
      Center(
        child: Stack(
          children: <Widget>[
            background(context),
            profilePic(
              context,
            ),
            text(context, name),
            information(context, members, gifts),
            viewButton(context, uid, eventId, name),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
    ],
  );
}

Widget background(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomLeft: Radius.circular(22),
      ),
      boxShadow: [
        BoxShadow(
            blurRadius: 4,
            offset: Offset(9, 9),
            color: Color(000000).withOpacity(.25),
            spreadRadius: -3),
      ],
    ),
    height: MediaQuery.of(context).size.height * 0.3,
    width: MediaQuery.of(context).size.width * 0.925,
  );
}

Widget profilePic(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.16,
    width: MediaQuery.of(context).size.height * 0.16,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: Colors.black,
        width: 3,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: Image.network(
        'https://i.pinimg.com/originals/9e/e8/9f/9ee89f7623acc78fc33fc0cbaf3a014b.jpg',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget text(BuildContext context, String name) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.025,
    left: MediaQuery.of(context).size.height * 0.19,
    child: Text(
      name,
      style: TextStyle(
        color: Colors.black,
        fontSize: 28,
      ),
    ),
  );
}

Widget information(BuildContext context, int members, int gifts) {
  return Positioned(
    bottom: MediaQuery.of(context).size.height * 0.04,
    left: MediaQuery.of(context).size.width * 0.03,
    child: Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
        ),
        Row(
          children: <Widget>[
            Text(
              members.toString(),
              style: TextStyle(
                  fontSize: 32,
                  color: Color.fromRGBO(37, 151, 237, 1),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              ' Members',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(118, 118, 118, 1),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Row(
          children: <Widget>[
            Text(
              gifts.toString(),
              style: TextStyle(
                  fontSize: 32,
                  color: Color.fromRGBO(37, 151, 237, 1),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              ' Gifts',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(118, 118, 118, 1),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget viewButton(
    BuildContext context, String uid, String eventId, String displayName) {
  return Positioned(
    bottom: MediaQuery.of(context).size.height * 0.02,
    right: MediaQuery.of(context).size.width * 0.035,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.2,
      child: FlatButton(
        onPressed: () async {
          Navigator.pushNamed(
            context,
            MembersScreen.routeName,
            arguments: {
              'uid': uid,
              'eventId': eventId,
              'displayName': displayName,
            },
          );
        },
        color: Color.fromRGBO(37, 151, 237, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Text(
          'View',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}
