
// Make linked member and dependant member hte exact same thing again
// have an islinked maybe or something idk to differentiate the icons like I used to have it

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';

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
  TextEditingController _emailController = TextEditingController();

  var userUid = '';
  var eventId = '';
  var eventName = '';
  // var type = 'loading';
  var memberOfEventData = 'loading';

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

  Future getEventName(uid, eventId) async {
    String nameOfEvent = await _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .get()
        .then(
          (documentSnapshot) => documentSnapshot.data['event name'],
        );
    eventName = nameOfEvent;
    print('EVENT NAME : ' + eventName);
  }

  // Future getType(uid, eventId) async {
  //   String typE = await _firestore
  //       .collection('Events')
  //       .document(eventId)
  //       .collection('members')
  //       .document(uid)
  //       .get()
  //       .then(
  //         (documentSnapshot) => documentSnapshot.data['type'],
  //       );
  //   type = typE;
  //   print('type : ' + type);
  // }

  Future checkMemberOfEventData(uid, eventId) async {
    try {
      String data = await _firestore
          .collection("Events")
          .document(eventId)
          .collection('members')
          .document(uid)
          .collection('members')
          .getDocuments()
          .then(
            (value) => value.documents[0].documentID.toString(),
          );
      if (data == null) {
        memberOfEventData = null;
      } else {
        memberOfEventData = 'true';
      }
    } catch (_) {
      memberOfEventData = null;
    }

    // value is a query snapshot of documents
  }

  @override
  void initState() {
    getUserUid().then((_) {
      print("got uid");
      getEventId(userUid).then((_) {
        print("got event id");
        checkMemberOfEventData(userUid, eventId).then((_) {
          print('checked member of Event');
          getEventName(userUid, eventId).then((_) {
            setState(() {});
            print('got event name');
          });
        });
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
            icon: Icon(Icons.adb),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: <Widget>[
                        Text('Add an active user to ' + eventName),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            hintText: 'enter the member\'s email',
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
                                  _fire.inviteToFamily(userUid, eventId,
                                      _emailController.text, eventName);
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
          IconButton(
            icon: Icon(LineIcons.plus_square_o),
            onPressed: () {
              _fire.acceptInviteToFamily(userUid, eventId, "max");
            },
          ),
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
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.125,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              hintText: 'Member Name',
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: FlatButton(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed: () {
                                  _fire.addFamilyMember(
                                    _nameController.text,
                                    userUid,
                                    eventId,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: memberOfEventData == null
          ? noMembers(context)
          : StreamBuilder(
              stream: _firestore
                  .collection('Events')
                  .document(eventId)
                  .collection('members')
                  .document(userUid)
                  .collection('members')
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
                      child: Column(
                        children: snapshot.data.documents.map(
                          (DocumentSnapshot document) {
                            if (document['linked?'] == '') {
                              return dependantMember(
                                context,
                                document.documentID,
                                userUid,
                                eventId,
                              );
                            } else {
                              return linkedMember(context, document.documentID,
                                  userUid, eventId);
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

Widget noMembers(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        Text('You have no members'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text('Click the plus to add a member'),
      ],
    ),
  );
}

Widget dependantMember(
    BuildContext context, String memberName, String uid, String eventId) {
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
                  Icon(
                    Icons.person_outline,
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

Widget linkedMember(
    BuildContext context, String memberName, String uid, String eventId) {
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
                  Icon(
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

// Widget joinEventAsButton(
//     BuildContext context, String joinOption, Function function) {
//   return Container(
//     height: MediaQuery.of(context).size.height * 0.03,
//     width: MediaQuery.of(context).size.width * 0.8,
//     child: FlatButton(
//       color: Color.fromRGBO(37, 151, 234, 1),
//       child: Text(
//         'Join event as : ' + joinOption,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//         ),
//       ),
//       onPressed: function,
//     ),
//   );
// }

// Container(
//                       child: Column(
//                         children: <Widget>[
//                           Expanded(
//                             flex: 1,
//                             child: Container(),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               children: <Widget>[
//                                 joinEventAsButton(
//                                   context,
//                                   'Family',
//                                   () {
//                                     _fire.joinEventAsGroup(userUid, eventId);
//                                     type = 'group';
//                                     setState(() {});
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.03,
//                                 ),
//                                 joinEventAsButton(
//                                   context,
//                                   'Individual',
//                                   () {
//                                     _fire.joinEventAsIndividual(
//                                         userUid, eventId);
//                                     type = 'individual';
//                                     setState(() {});
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Container(),
//                           ),
//                         ],
//                       ),
//                     ),

// _fire.addFamilyMember(
//                                       _nameController.text,
//                                       userUid,
//                                       eventId,
//                                     );

// showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 builder: (context) {
//                   return Padding(
//                     padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                     ),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.15,
//                       child: Column(
//                         children: <Widget>[
//                           TextFormField(
//                             controller: _nameController,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintStyle: TextStyle(color: Colors.grey[700]),
//                               labelStyle: TextStyle(color: Colors.grey[700]),
//                               hintText: 'Member Name',
//                               icon: Icon(
//                                 Icons.person_outline,
//                                 color: Colors.grey[500],
//                                 size: 26,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               right: MediaQuery.of(context).size.width * 0.05,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: <Widget>[
//                                 RaisedButton(
//                                   color: Color.fromRGBO(37, 151, 234, 1),
//                                   onPressed: () {

//                                   },
//                                   child: Text(
//                                     'Add',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
