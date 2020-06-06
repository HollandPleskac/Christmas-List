import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';

final Firestore _firestore = Firestore.instance;

class Fire {
  //////////////////
  ///
  ///
  ///               Creating an Account Logic
  ///
  ///
  ///
  //////////////////

  void createAccount(
    String email,
    String displayName,
    String uid,
  ) {
    _firestore.collection("UserData").document(uid).setData({
      "email": email,
      "display name": displayName,
      'selected event': '',
    });
  }

  //////////////////
  ///
  ///
  ///               Creating an Event Logic
  ///
  ///
  ///
  //////////////////

  void createEvent(String eventName, String uid, String host, String eventId,
      String familyName) {
    var _randomString = randomAlphaNumeric(20);

    _firestore
        .collection("UserData")
        .document(uid)
        .collection('my events')
        .document(_randomString)
        .setData(
      {
        'event name': eventName,
        'host': host,
      },
    );

    _firestore.collection('Events').document(_randomString).setData(
      {
        'event name': eventName,
        'host': host,
      },
    );

    createFamilyInEvent(uid, _randomString, familyName, host);
    // _randomString here is the event id

    setSelectedEvent(uid, _randomString);
  }

  void createFamilyInEvent(
      String uid, String eventId, String familyName, String host) {
    _firestore
        .collection("Events")
        .document(eventId)
        .collection('members')
        .document(uid)
        .setData(
      {
        'family name': familyName,
        'host': host,
        'type': '',
        'members': 0,
        'gifts': 0,
      },
    );
  }

  void setSelectedEvent(String uid, String eventId) {
    _firestore.collection("UserData").document(uid).updateData(
      {
        'selected event': eventId,
      },
    );
  }

  //////////////////
  ///
  ///
  ///               Adding/Deleting Members Logic
  ///
  ///
  ///
  //////////////////

  void addFamilyMember(String memberName, String uid, String eventId) {
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .collection('members')
        .document(memberName)
        .setData(
      {'linked?': ''},
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

  //////////////////
  ///
  ///
  ///               Adding/Deleting Gifts Logic
  ///
  ///
  ///
  //////////////////

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

  //////////////////
  ///
  ///
  ///               Invite to Event logic
  ///
  ///
  ///
  //////////////////

  void sendInvite(String uid, String eventId, String email, String eventName,
      String host) async {
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
        'host': host,
        'invite type': 'event',
        'host uid': uid,
      },
    );
  }

  void acceptInviteToEvent(String eventName, String uid, String host,
      String eventId, String displayNameForEvent) {
    // adds the user to the event
    _firestore
        .collection("UserData")
        .document(uid)
        .collection('my events')
        .document(eventId)
        .setData(
      {
        'event name': eventName,
        'display name': displayNameForEvent,
        'hosting': false,
        'event type': 'event',
      },
    );

    //initializes members value and gifts value as well as display name
    _firestore
        .collection('Events')
        .document(eventId)
        .collection('members')
        .document(uid)
        .setData(
      {
        'family name': displayNameForEvent,
        'host': host,
        'type': '',
        'members': 0,
        'gifts': 0,
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

  //////////////////
  ///
  ///
  ///               Invite to Family Logic
  ///
  ///
  ///
  //////////////////

  void inviteToFamily(
      String uid, String eventId, String email, String familyName) async {
    String uidOfPersonRecievingInvite = await _firestore
        .collection('UserData')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then(
          (value) => value.documents[0].documentID.toString(),
        );

    _firestore
        .collection("UserData")
        .document(uidOfPersonRecievingInvite)
        .collection('invites')
        .document(eventId)
        .setData(
      {
        'invite type': 'family',
        'family name': familyName,
        'host': email,
        'invite to family event id': eventId,
        'invite to family uid': uid,
      },
    );
  }

  void acceptInviteToFamily(String uidOfFamily, String eventIdOfFamily,
      String acceptedMembersName, String userUid, String eventName) {
    _firestore
        .collection('Events')
        .document(eventIdOfFamily)
        .collection('members')
        .document(uidOfFamily)
        .collection('members')
        .document(acceptedMembersName)
        .setData(
      {'linked?': uidOfFamily},
    );

    // deletes the family invite out of invites list
    _firestore
        .collection("UserData")
        .document(userUid)
        .collection('invites')
        .document(eventIdOfFamily)
        .delete();

    //add this event of users list of events
    // adds the user to the event
    _firestore
        .collection("UserData")
        .document(userUid)
        .collection('my events')
        .document(eventIdOfFamily)
        .setData(
      {
        'event name': eventName,
        'display name': acceptedMembersName,
        'hosting': false,
        'event type': 'family',
        'host uid': uidOfFamily,
      },
    );

    //update the count of users
    final DocumentReference postRef = Firestore.instance
        .collection('Events')
        .document(eventIdOfFamily)
        .collection('members')
        .document(uidOfFamily);
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'members': postSnapshot.data['members'] + 1});
      }
    });
  }
}

void removeIndependantUserGift() {
  // coming soon
}