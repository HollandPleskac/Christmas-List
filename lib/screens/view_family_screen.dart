import 'package:flutter/material.dart';
import 'package:pleskac_christmas_list/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/family_group.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class ViewFamilyScreen extends StatefulWidget {
  static const routeName = 'view-family-screen';
  @override
  _ViewFamilyScreenState createState() => _ViewFamilyScreenState();
}

class _ViewFamilyScreenState extends State<ViewFamilyScreen> {
  static var _appConfigInstance = AppConfig();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        title: Center(
          child: Text(
            'View Families',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        //color: Colors.grey[300],
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: Firestore.instance.collection("PleskacFam").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return Column(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return FamilyGroup(
                          document.documentID,
                          document['familyName'],
                          document['familyEmail'],
                          'assets/images/christmas_image_gifts.png',
                          document['totalGifts'],
                          document['imageUrl'],
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ],
        ),
      ),
      drawer: _appConfigInstance.appDrawer(context),
    );
  }
}
