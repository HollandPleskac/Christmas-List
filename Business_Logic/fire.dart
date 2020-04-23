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

    final DocumentReference postRef = Firestore.instance
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'members': postSnapshot.data['members'] + 1});
      }
    });
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

    final DocumentReference postRef = Firestore.instance
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'members': postSnapshot.data['members'] - 1});
      }
    });
  }

  void addGift(String memberName, String giftName, String uid, String eventId,
      int giftPrice) async {
    List potentialGiftsWithSameGiftName = await _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .collection('members')
        .document(memberName)
        .collection('gifts')
        .where('giftName', isEqualTo: giftName)
        .getDocuments()
        .then(
          (value) => value.documents,
        );
    if (potentialGiftsWithSameGiftName.isEmpty) {
      _firestore
          .collection('Events')
          .document(eventId)
          .collection('members')
          .document(uid)
          .collection('members')
          .document(memberName)
          .collection('gifts')
          .document(giftName)
          .setData(
        {
          'giftPrice': giftPrice,
          'giftName': giftName,
        },
      );

      final DocumentReference postRef = Firestore.instance
          .collection('Events')
          .document(eventId)
          .collection('members')
          .document(uid);
      _firestore.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef,
              <String, dynamic>{'gifts': postSnapshot.data['gifts'] + 1});
        }
      });
    } else {
      print('that gift name is already taken');
    }
  }

  void removeGift(String memberName, String giftName, String uid,
      String eventId, int giftPrice) {
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .collection('members')
        .document(memberName)
        .collection('gifts')
        .document(giftName)
        .delete();

    final DocumentReference postRef = Firestore.instance
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'gifts': postSnapshot.data['gifts'] - 1});
      }
    });
  }

  void createEvent(String eventName, String uid, String host, bool hosting) {
    var _randomString = randomAlphaNumeric(20);

    _firestore
        .collection("UserData")
        .document(uid)
        .collection('my events')
        .document(_randomString)
        .setData(
      {'event name': eventName, 'hosting': true, 'type': null},
    );

    _firestore.collection("Events").document(_randomString).setData(
      {
        'event name': eventName,
        'host': host,
        'type': null,
      },
    );

    setSelectedEvent(uid, _randomString);
  }

  void setSelectedEvent(String uid, String eventId) {
    _firestore.collection("UserData").document(uid).updateData(
      {
        'selected event': eventId,
      },
    );
  }

  void sendInvite(
    String uid,
    String eventId,
    String email,
    String eventName,
  ) async {
    String uidOfPersonRecievingInvite = await _firestore
        .collection('UserData')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then(
          (value) => value.documents[0].documentID.toString(),
        );
    // value is a query snapshot
    // since there is one user per email there will only ever be one document in value
    // we select the first value which is a document snapshot
    // then we take the documentId from that which is the uidOfPersonRecievingInvite!

    _firestore
        .collection("UserData")
        .document(uidOfPersonRecievingInvite)
        .collection('invites')
        .document(eventId)
        .setData(
      {
        'event name': eventName,
        'hosting': false,
        'host': email,
      },
    );
  }

  void acceptInvite(String eventName, String uid, String host, String eventId) {
    // adds the user to the event
    _firestore
        .collection("UserData")
        .document(uid)
        .collection('my events')
        .document(eventId)
        .setData(
      {
        'event name': eventName,
        'hosting': false,
        'type': null,
      },
    );

    // deletes the events out of invites list
    _firestore
        .collection("UserData")
        .document(uid)
        .collection('invites')
        .document(eventId)
        .delete();
  }

  void joinEventAsGroup(String uid, String eventId) {
    _firestore
        .collection("Events")
        .document(eventId)
        .collection('members')
        .document(uid)
        .updateData(
      {
        'type': 'group',
      },
    );
  }

  void joinEventAsIndividual(String uid, String eventId) {
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .updateData(
      {
        'type': 'individual',
      },
    );
  }
}
