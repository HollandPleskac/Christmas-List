import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './my_gifts_screen.dart';
import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final _fire = Fire();

class MyMembersScreen extends StatefulWidget {
  @override
  _MyMembersScreenState createState() => _MyMembersScreenState();
}

class _MyMembersScreenState extends State<MyMembersScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 4,
        backgroundColor: Color.fromRGBO(37, 151, 234, 1),
        title: Center(child: Text('My Members')),
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
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            hintText: 'Member Name',
                            icon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[500],
                              size: 26,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                color: Color.fromRGBO(37, 151, 234, 1),
                                onPressed: () {
                                  _fire.addFamilyMember(
                                      _nameController.text, userUid, eventId);
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
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
                      return member(context, document.documentID, false,
                          userUid, eventId);
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
              Navigator.pushNamed(context, MyGiftsScreen.routeName, arguments: {
                'uid': uid,
                'eventId': eventId,
                'displayName': memberName
              });
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
                      _fire.removeFamilyMember(memberName, uid, eventId);
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
