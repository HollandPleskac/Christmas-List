import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pleskac_christmas_list/screens/my_family_members_screen.dart';
import 'package:pleskac_christmas_list/screens/profile_screen.dart';
import 'package:pleskac_christmas_list/screens/view_family_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

class AppConfig {
  Widget appDrawer(context) {
    return Drawer(
      elevation: 20,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'assets/images/christmas_image_gifts.png'))),
              child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Welcome Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
              ])),
          ListTile(
              title: Row(
                children: <Widget>[
                  Icon(LineIcons.home),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('My Members'),
                  )
                ],
              ),
              onTap: () async {
                FirebaseUser _user = await _auth.currentUser();
                String _currentUserUID = _user.uid.toString();
                Navigator.pushNamed(
                  context,
                  MyFamilyMembersScreen.routeName,
                  arguments: {'currentUserUID': _currentUserUID},
                );
              }),
          ListTile(
              title: Row(
                children: <Widget>[
                  Icon(LineIcons.group),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Family'),
                  ),
                ],
              ),
              onTap: () async {
                FirebaseUser _user = await _auth.currentUser();
                String _currentUserUID = _user.uid.toString();
                Navigator.pushNamed(
                  context,
                  ViewFamilyScreen.routeName,
                  arguments: {'currentUser': _currentUserUID},
                );
              }),
          ListTile(
              title: Row(
                children: <Widget>[
                  Icon(LineIcons.user),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Profile'),
                  ),
                ],
              ),
              onTap: () async {
                FirebaseUser _user = await _auth.currentUser();
                String _currentUserUID = _user.uid.toString();

                Navigator.pushNamed(
                  context,
                  ProfileScreen.routeName,
                  arguments: {
                    'currentUserUID': _currentUserUID,
                  },
                );
              }),
        ],
      ),
    );
  }

  createFamily(String currentUserUID, String familyEmail, String familyName) {
    _firestore.collection("PleskacFam").document(currentUserUID).setData({
      'totalGifts': 0,
      'familyName': familyName,
      'familyEmail': familyEmail,
    });
  }

  createMemberOfFamily(String currentUserUID, String rank, String firstName,
      String lastName, String age) async {
    final user = await _auth.currentUser();
    // set up information document
    _firestore
        .collection("PleskacFam")
        .document(currentUserUID)
        .collection('Members')
        .document(firstName + ' ' + lastName)
        .setData({
      'age': age,
      'rank': rank,
    });

    final DocumentReference postRef =
        Firestore.instance.collection('PleskacFam').document(user.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'totalMembers': postSnapshot.data['totalMembers'] + 1
        });
      }
    });
  }

  addGift(name, giftName, giftPrice, giftUrl, giftDescription) async {
    final user = await _auth.currentUser();

    _firestore
        .collection("PleskacFam")
        .document(user.uid)
        .collection('Members')
        .document(name)
        .collection(name + ' Gifts')
        .document(giftName)
        .setData(
      {
        "personName": name,
        "giftPrice": giftPrice,
        "giftUrl": giftUrl,
        "giftDescription": giftDescription,
      },
    );

    final DocumentReference postRef =
        Firestore.instance.collection('PleskacFam').document(user.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'totalGifts': postSnapshot.data['totalGifts'] + 1
        });
      }
    });

    // this is a transaction - very useful
    final DocumentReference ppostRef = Firestore.instance
        .collection('PleskacFam')
        .document(user.uid)
        .collection('Members')
        .document(name);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(ppostRef);
      if (postSnapshot.exists) {
        await tx.update(ppostRef, <String, dynamic>{
          'totalGifts': postSnapshot.data['totalGifts'] + 1
        });
      }
    });
  }

  removeGift(personName, giftName) async {
    final user = await _auth.currentUser();

    _firestore
        .collection("PleskacFam")
        .document(user.uid)
        .collection('Members')
        .document(personName)
        .collection(personName + ' Gifts')
        .document(giftName)
        .delete();

    final DocumentReference postRef =
        Firestore.instance.collection('PleskacFam').document(user.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'totalGifts': postSnapshot.data['totalGifts'] - 1
        });
      }
    });

    final DocumentReference ppostRef = Firestore.instance
        .collection('PleskacFam')
        .document(user.uid)
        .collection('Members')
        .document(personName);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(ppostRef);
      if (postSnapshot.exists) {
        await tx.update(ppostRef, <String, dynamic>{
          'totalGifts': postSnapshot.data['totalGifts'] - 1
        });
      }
    });
  }

  editGift(name, giftName, giftPrice, giftUrl, giftDescription) async {
    final user = await _auth.currentUser();

    _firestore
        .collection("PleskacFam")
        .document(user.uid)
        .collection('Members')
        .document(name)
        .collection(name + ' Gifts')
        .document(giftName)
        .updateData({
      'giftPrice': giftPrice,
      'giftUrl': giftUrl,
      'giftDescription': giftDescription,
    });
  }

  uploadImageToDatabase(imageUrl) async {
    // only one image because this a profile picture so no need to create a new collection
    final user = await _auth.currentUser();
    _firestore
        .collection("PleskacFam")
        .document(user.uid)
        .updateData({'imageUrl': imageUrl});
  }
}
