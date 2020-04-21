import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';

final Firestore _firestore = Firestore.instance;

class Fire {
  void createAccount(
    String email,
    String displayName,
    String uid,
  ) {
    _firestore.collection("UserData").document(uid).setData({
      "email": email,
      "display name": displayName,
    });
  }

  void addFamilyMember(String memberName, String uid, String eventId) {
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .collection('members')
        .document(memberName)
        .setData(
      {'is linked': null},
    );
  }

  void removeFamilyMember(String memberName, String uid, String eventId) {
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .collection('members')
        .document(memberName)
        .delete();
  }

  void addGift(String memberName, String giftName, String uid) {
    _firestore.collection("UserData").document(uid).get().then(
      (DocumentSnapshot ds) {
        //if the current account signed in is a linked account
        if (ds['linked?'] != null) {
          _firestore
              .collection("UserData")
              .document(ds['linked?'])
              .collection('Members')
              .document(memberName)
              .setData({'member name': memberName});
        } else {
          //if the current account is not a linked account
          _firestore
              .collection("UserData")
              .document('uid')
              .collection('Members')
              .document(memberName)
              .setData({'member name': memberName});
          print('null value of linked this is a parent account');
        }
      },
    );
  }

  void createLinkedAccount(
      String email, String password, String displayName, String uid) {
    _firestore.collection("UserData").document(uid).setData({
      "email": email,
      "password": password,
      "display name": displayName,
      "linked?": uid,
    });
  }

  void createEvent(String eventName, String uid, String host) {
    var _randomString = randomAlphaNumeric(20);
    // bool _isunique = false if (_firebase.collection.where(document == new string) == new string) else {_isunique = true}
    _firestore
        .collection("UserData")
        .document(uid)
        .collection('my events')
        .document(_randomString)
        .setData(
      {
        'event name': eventName,
        'hosting': true,
      },
    );

    _firestore.collection("Events").document(_randomString).setData(
      {
        'event name': eventName,
        'host': host,
      },
    );
  }

  void setSelectedEvent(String uid, String eventUID) {
    _firestore.collection("UserData").document(uid).updateData(
      {
        'selected event': eventUID,
      },
    );
  }

  void sendInvite(String uid, String eventUid, String email) async {
    // value is a query snapshot
    // since there is one user per email there will only ever be one document in value
    // we select the first value which is a document snapshot 
    // then we take the documentId from that which is the uidOfPersonRecievingInvite!
    String uidOfPersonRecievingInvite = await _firestore
        .collection('UserData')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then(
          (value) => value.documents[0].documentID.toString(),
        );

      _firestore
          .collection("UserData")
          .document(uid)
          .collection('invites')
          .document(uidOfPersonRecievingInvite)
          .setData(
        {
          'data': 'data',
          'hosting': false,
          'host': email,
        },
      );
  }
}
