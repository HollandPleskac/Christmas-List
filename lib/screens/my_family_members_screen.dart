import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_config.dart';
import '../widgets/family_member.dart';

class MyFamilyMembersScreen extends StatefulWidget {
  static const routeName = 'my-family-members-screen';

  @override
  _MyFamilyMembersScreenState createState() => _MyFamilyMembersScreenState();
}

class _MyFamilyMembersScreenState extends State<MyFamilyMembersScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  static var _appConfigInstance = AppConfig();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final _uid = routeArguments['currentUserUID'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'My Members',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              //labelStyle: TextStyle(color: Colors.blue),
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.nature,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              //labelStyle: TextStyle(color: Colors.blue),
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.access_alarms,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _ageController,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              //labelStyle: TextStyle(color: Colors.blue),
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.streetview,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: TextField(
                            controller: _rankController,
                            decoration: InputDecoration(
                              labelText: 'Rank',
                              //labelStyle: TextStyle(color: Colors.blue),
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.star_border,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, bottom: 16.0, top: 4.0),
                              child: FlatButton(
                                child: Text(
                                  'Add Member',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  //final user = await _auth.currentUser();
                                  _appConfigInstance.createMemberOfFamily(
                                      _uid,
                                      _rankController.text,
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _ageController.text);
                                  Navigator.pop(context);
                                },
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("PleskacFam")
            .document(_uid)
            .collection('Members')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return Column(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return FamilyMember(false, _uid, document.documentID,
                      document['age'], document['rank'],document['totalGifts']);
                }).toList(),
              );
          }
        },
      ),
      drawer: _appConfigInstance.appDrawer(context),
    );
  }
}
