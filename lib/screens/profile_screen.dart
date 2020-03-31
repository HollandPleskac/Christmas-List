import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pleskac_christmas_list/screens/sign_in_screen.dart';
import '../app_config.dart';
import '../storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class ProfileScreen extends StatefulWidget {
  static const routeName = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _appConfigInstance = AppConfig();
  var _storageInstance = Storage();

  File _image;

  Future getImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
      print(image.path);
      // cant print image.path if there is no image - ex. going back out of gallery
      _storageInstance.uploadImage(context, image);
    }
  }

  Future getImageFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      print(image.path);
      // cant print image.path if there is no image - ex. going back out of camera
      _storageInstance.uploadImage(context, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final _uid = routeArguments['currentUserUID'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: Text(
              'My Profile',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: FlatButton(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                // sign out
                onPressed: () async {
                  if (await _googleSignIn.isSignedIn() == true) {
                    print('google sign out');
                    await _googleSignIn.signOut();
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  } else {
                    print('regular sign out');
                    await _auth.signOut();
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  }
                }),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(55),
                    bottomRight: Radius.circular(55),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 35,
                      ),
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection('PleskacFam')
                              .document(_uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading");
                            } else {
                              Map<String, dynamic> documentFields =
                                  snapshot.data.data;
                              return documentFields['imageUrl'] != null
                                  ? Container(
                                      //this container acts like a circle avatar - how you fit a picture inside of a circle
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              documentFields['imageUrl']),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/images/christmas_image_gifts.png')),
                                      ),
                                    );
                            }
                          }),
                    ),
                    //Padding(
                    // padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                    // child: Container(
                    //      width: MediaQuery.of(context).size.width * 0.8,
                    //   height: MediaQuery.of(context).size.height * 0.24,
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(35),
                    //       child: Image.asset(
                    //            'assets/images/christmas_image_gifts.png'),
                    //        ),
                    //    ),
                    //    ),

                    StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection('PleskacFam')
                            .document(_uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading");
                          } else {
                            Map<String, dynamic> documentFields =
                                snapshot.data.data;
                            return Text(
                              documentFields['familyName'],
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            );
                          }
                        }),
                    SizedBox(
                      height: 25,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection('PleskacFam')
                            .document(_uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading");
                          } else {
                            Map<String, dynamic> documentFields =
                                snapshot.data.data;
                            return Text(
                              documentFields['familyEmail'],
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54),
                            );
                          }
                        }),
                    //      SizedBox(
                    //        height: 5,
                    //       ),
                    //       Text(
                    //          'janelpleskac@gmail.com',
                    //           style: TextStyle(
                    //            color: Colors.black54,
                    //             fontSize: 17,
                    //               fontWeight: FontWeight.w300,
                    //           ),
                    //           ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'All Members',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection('PleskacFam')
                                    .document(_uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("Loading");
                                  } else {
                                    Map<String, dynamic> documentFields =
                                        snapshot.data.data;
                                    return Text(
                                      documentFields['totalMembers'].toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Total Gifts',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection('PleskacFam')
                                    .document(_uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("Loading");
                                  } else {
                                    Map<String, dynamic> documentFields =
                                        snapshot.data.data;
                                    return Text(
                                      documentFields['totalGifts'].toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
            ),
          )
          // _image == null
          //       ? Container(
          //           child: Center(
          //           child: Text('no images yet'),
          //          ),
          //       )
          //      : Container(
          //         child: Center(
          //         child: Image.file(_image),
          //      )),
        ],
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        //visible: _isVisible, - will always be visible for us
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.image),
            onTap: () => getImageFromGallery(),
          ),
          SpeedDialChild(
            child: Icon(Icons.add_a_photo),
            // Icon(Icons.add_a_photo); Icon(Icons.camera_alt)
            onTap: () => getImageFromCamera(),
          )
        ],
      ),
      drawer: _appConfigInstance.appDrawer(context),
    );
  }
}
