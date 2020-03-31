import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pleskac_christmas_list/screens/view_family_screen.dart';
import '../app_config.dart';
import '../widgets/family_member.dart';

class FamilyMembersScreen extends StatefulWidget {
  static const routeName = 'family-members-screen';

  @override
  _FamilyMembersScreenState createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  static var _appConfigInstance = AppConfig();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final _uid = routeArguments['uid'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () =>
              Navigator.of(context).pop(),
              // gets rid of the current sreen - acts like a back arrow
        ),
        title: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                  child: StreamBuilder(
              stream: Firestore.instance
                  .collection("PleskacFam")
                  .document(_uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('loading');
                } else {
                  return Center(
                    child: Text(
                      snapshot.data.data['familyName'] + '\'s Members',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
              }),
        ),
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
                  return FamilyMember(true, _uid, document.documentID,
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

//StreamBuilder(
//         stream: Firestore.instance
//           .collection("PleskacFam")
//         .document(_uidForCurrentUser)
//          .snapshots(),
//         builder: (context, snapshot) {
//  //      if (!snapshot.hasData) {
//          return Text('not working');
//        } else {
//          Map<String, dynamic> documentFields = snapshot.data.data;
// //           documentFields.remove('Information');
//             //print(documentFields);
//          List members = [];
//            documentFields.forEach((key, value) {
//         members.add(key);
//           });
//          return ListView.builder(
//         physics: BouncingScrollPhysics(),
//               itemCount: documentFields.length,
//            itemBuilder: (context, index) {
//                 //members[index] is the name of the member - check cloud firestore - ex. members[index] = Holland Pleskac
//         return Column(
//               children: <Widget>[
//                 FamilyMember(
//                   false,
//                  _uidForCurrentUser,
//  //                 documentFields[members[index]]['name'],
//                 documentFields[members[index]]['age'],
//                  documentFields[members[index]]['rank'],
////                )
//                 ],
//             );
//             });
//        }
//  }),
