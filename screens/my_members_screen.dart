// Make linked member and dependant member hte exact same thing again
// have an islinked maybe or something idk to differentiate the icons like I used to have it

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  var eventId = 'loading';
  var familyName = '...';
  var type = 'loading';
  var hostUid = '';
  var displayName = '';
  var memberOfEventData = 'loading';

  Future getUserUid() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    String uid = currentUser.uid;
    userUid = uid;
    print(uid);
  }

  Future getEventId(uid) async {
    try {
      String eventID = await _firestore
          .collection("UserData")
          .document(uid)
          .get()
          .then((documentSnapshot) => documentSnapshot.data['selected event']);
      eventId = eventID;
    } catch (_) {
      eventId = '';
    }

    print(eventId);
  }

  Future getFamilyName(String uid, String eventId, type) async {
    if (type == 'event') {
      try {
        String famName = await _firestore
            .collection('Events')
            .document(eventId)
            .collection('members')
            .document(uid)
            .get()
            .then(
              (documentSnapshot) => documentSnapshot.data['family name'],
            );
        familyName = famName;
        print(
          'EVENT NAME : ' + familyName.toString(),
        );
      } catch (_) {
        familyName = null;
      }
    } else {
      try {
        String _ownerUid = await _firestore
            .collection('UserData')
            .document(uid)
            .collection('my events')
            .document(eventId)
            .get()
            .then((value) => value.data['host uid']);
        String _famName = await _firestore
            .collection('Events')
            .document(eventId)
            .collection('members')
            .document(_ownerUid)
            .get()
            .then((documentSnapshot) => documentSnapshot.data['family name']);
        initializeData(userUid, eventId, type);
        familyName = _famName;
      } catch (_) {
        familyName = null;
      }
    }
  }

  Future getType(uid, eventId) async {
    String typE = await _firestore
        .collection('UserData')
        .document(uid)
        .collection('my events')
        .document(eventId)
        .get()
        .then(
          (documentSnapshot) => documentSnapshot.data['event type'],
        );
    type = typE;
    print('type : ' + type);
  }

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

  Future initializeData(userUid, eventId, type) async {
    // gets information needed to turn this screen into a gifts screen if the type is fam view
    // need the host uid and display name
    String ddisplayName = await _firestore
        .collection('UserData')
        .document(userUid)
        .collection('my events')
        .document(eventId)
        .get()
        .then((value) => value.data['display name']);
    String hhostUid = await _firestore
        .collection('UserData')
        .document(userUid)
        .collection('my events')
        .document(eventId)
        .get()
        .then((value) => value.data['host uid']);
    displayName = ddisplayName;
    hostUid = hhostUid;
    print("DDDDDISSSPLAY " + displayName);
    print('HOOOST UU IIDID ' + hostUid);
  }

  @override
  void initState() {
    getUserUid().then((_) {
      print("got uid");
      getEventId(userUid).then((_) {
        print("got event id");
        checkMemberOfEventData(userUid, eventId).then((_) {
          print('checked member of Event');
          getType(userUid, eventId).then((_) {
            print('got type');
            getFamilyName(userUid, eventId, type).then((_) {
              print('got fam name');
              setState(() {});
            });
          });
        });
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    TextEditingController _giftNameController = TextEditingController();
    TextEditingController _giftPriceController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 4,
        backgroundColor: Color.fromRGBO(37, 151, 234, 1),
        title: Center(
          child:
              Text(type == 'event' ? 'My Members' : familyName + '\'s members'),
        ),
        actions: <Widget>[
          type == 'event'
              ? IconButton(
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
                              Text('Add an active user to ' + familyName),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
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
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Color.fromRGBO(37, 151, 234, 1),
                                      onPressed: () {
                                        _fire.inviteToFamily(userUid, eventId,
                                            _emailController.text, familyName);
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
                )
              : Container(),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              type == 'event'
                  ? showModalBottomSheet(
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
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
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _giftNameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    hintText: 'Gift Name',
                                    icon: Icon(
                                      Icons.card_giftcard,
                                      color: Colors.grey[500],
                                      size: 26,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _giftPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    hintText: 'Gift Price',
                                    icon: Icon(
                                      Icons.attach_money,
                                      color: Colors.grey[500],
                                      size: 26,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.02,
                                    right: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      RaisedButton(
                                        color: Color.fromRGBO(37, 151, 234, 1),
                                        onPressed: () async {
                                          String displayName = await _firestore
                                              .collection('UserData')
                                              .document(userUid)
                                              .collection('my events')
                                              .document(eventId)
                                              .get()
                                              .then((value) =>
                                                  value.data['display name']);
                                          String hostUid = await _firestore
                                              .collection('UserData')
                                              .document(userUid)
                                              .collection('my events')
                                              .document(eventId)
                                              .get()
                                              .then((value) =>
                                                  value.data['host uid']);
                                          _fire.addGift(
                                            displayName,
                                            _giftNameController.text,
                                            hostUid,
                                            eventId,
                                            int.parse(
                                                _giftPriceController.text),
                                          );
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
                          ),
                        );
                      },
                    );
              ;
            },
          ),
        ],
      ),
      body: eventId == ''
          ? noEventSelected(context)
          : type == 'family'
              ? familyView(context, familyName, eventId, hostUid, displayName)
              : memberOfEventData == null
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
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
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
                                      return linkedMember(
                                          context,
                                          document.documentID,
                                          userUid,
                                          eventId);
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

Widget familyView(BuildContext context, String familyName, String eventId,
    String hostUid, String displayName) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Add a Gift with the plus',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      StreamBuilder(
        stream: _firestore
            .collection('Events')
            .document(eventId)
            .collection('members')
            .document(hostUid)
            .collection('members')
            .document(displayName)
            .collection('gifts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              );
            default:
              return Column(
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    return _gift(context, document.documentID,
                        document['giftPrice'], hostUid, eventId, displayName);
                  },
                ).toList(),
              );
          }
        },
      ),
    ],
  );
}

Widget noMembers(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        Text('You have no members'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Text('Click the plus to add a member'),
      ],
    ),
  );
}

Widget noEventSelected(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        Text('No Event Selected'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text('Select an Event my the manage events page'),
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

Widget _gift(
  BuildContext context,
  String giftName,
  int giftPrice,
  String uid,
  String eventId,
  String memberName,
) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: InkWell(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                  side: BorderSide(width: 1.5, color: Colors.grey[300]),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                  vertical: MediaQuery.of(context).size.height * 0.0085,
                ),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Icon(
                      LineIcons.gift,
                      size: 40,
                      color: Colors.blue[600],
                    ),
                  ),
                  title: Text(
                    giftName,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: Colors.grey[500],
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.002,
                          horizontal: MediaQuery.of(context).size.width * 0.013,
                        ),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.0025),
                        child: Text(
                          '\$' + giftPrice.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      IconButton(
                          icon: Icon(
                            (Icons.delete),
                            size: 28,
                          ),
                          onPressed: () {
                            print('no option to remove');
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ],
                  ),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
