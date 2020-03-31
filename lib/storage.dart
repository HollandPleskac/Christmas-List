import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pleskac_christmas_list/screens/profile_screen.dart';
import 'dart:io';
import './app_config.dart';

var _appConfigInstance = AppConfig();

class Storage {
  void uploadImage(BuildContext context, File chosenImage) async {
    final user = await FirebaseAuth.instance.currentUser();
    final String userUID = user.uid;

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child("Pleskac Fam");

    final StorageUploadTask uploadTask =
        storageRef.child(userUID + '.jpg').putFile(chosenImage);

    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    var url = imageUrl.toString();
    _appConfigInstance.uploadImageToDatabase(imageUrl);
    Navigator.pushNamed(context, ProfileScreen.routeName,
        arguments: {'currentUserUID': userUID});
    print("Image Url = " + url);
  }
}
