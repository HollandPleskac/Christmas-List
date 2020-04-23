import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:name_gifts/screens/gifts_screen.dart';

import './my_gifts_screen.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class MembersScreen extends StatefulWidget {
  static const routeName = 'members-screen';
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final String userUid = routeArguments['uid'];
    final String eventId = routeArguments['eventId'];
    final String displayName = routeArguments['displayName'];
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Color.fromRGBO(37, 151, 234, 1),
        title: Center(child: Text(displayName)),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _firestore
              .collection("Events")
              .document(eventId)
              .collection('members')
              .document(userUid)
              .collection('members')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Column(
                  children: snapshot.data.documents.map(
                    (DocumentSnapshot document) {
                      return member(
                        context,
                        document.documentID,
                        false,
                        userUid,
                        eventId,
                      );
                    },
                  ).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}

Widget member(BuildContext context, String memberName, bool isLinkedAccount,
    String uid, String eventId) {
      print(memberName);
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.017,
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.12,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Color.fromRGBO(37, 151, 234, 1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              print('go to screen');
              Navigator.pushNamed(
                context,
                GiftsScreen.routeName,
                arguments: {
                  'uid': uid,
                  'eventId': eventId,
                  'displayName': memberName,
                },
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  isLinkedAccount == false
                      ? Icon(
                          Icons.person_outline,
                          color: Colors.black,
                          size: 42,
                        )
                      : Icon(
                          Icons.verified_user,
                          color: Colors.black,
                          size: 42,
                        ),
                  Text(
                    memberName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('remove member');
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.039,
                      width: MediaQuery.of(context).size.height * 0.039,
                      child: Icon(
                        Icons.remove,
                        size: 20,
                        color: Color.fromRGBO(37, 151, 234, 1),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(37, 151, 234, 1),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                offset: Offset(8, 8),
                color: Color(000000).withOpacity(.25),
                spreadRadius: -8),
          ],
        ),
      ),
    ],
  );
}
