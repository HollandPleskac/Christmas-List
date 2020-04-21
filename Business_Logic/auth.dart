import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './fire.dart';
import '../tab_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final _fire = Fire();

class Auth {
  void registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    AuthResult _result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    FirebaseUser _user = _result.user;

    _sendEmailVerification(_user);

    print('user has been send a verification email');

    //resister w/ email password signs user in
    //here we sign the user out because we want them to verify their email before logging in
    //if a user is signed in - signout the user
    if (await _auth.currentUser() != null) {
      print('there is a user signed in');
      signOutWithEmailandPassword();
    }

    _fire.createAccount(email, displayName, _user.uid);
  }

  void loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    AuthResult _result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser _user = _result.user;

    if (await isEmailVerified(_user)) {
      print('successfully signed in');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabPage(),
        ),
      );
    }
  }

  Future<String> loginWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // this line checks to see if a user registered with email and password before signing up
    List<String> potentialEmail = await _auth.fetchSignInMethodsForEmail(
        email: googleSignInAccount.email);

    print('Potential Email ' + potentialEmail.toString());

    if (potentialEmail == null || potentialEmail.length < 1) {
      print('sign up to continue with google');
      return 'sign up to continue with google';
    }

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    if (user.isAnonymous) {
      return 'user is anonymous';
    }

    if (user.getIdToken() == null) {
      return 'failure to get id token';
    }

    if (await isEmailVerified(user) == false) {
      return 'please verify email to continue with google';
    }

    final FirebaseUser currentUser = await _auth.currentUser();

    if (user.uid == currentUser.uid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabPage(),
        ),
      );
      return 'success';
    }
    return 'error signing up';
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  void _sendEmailVerification(FirebaseUser recipient) {
    recipient.sendEmailVerification();
    print('emal verification sent');
  }

  Future<bool> isEmailVerified(FirebaseUser user) async {
    return user.isEmailVerified;
  }

  void signOutWithEmailandPassword() async {
    await _auth.signOut();
    print('signed out with email and password');
  }

  void signOutWithGoogle() async {
    await _googleSignIn.signOut();

    print('signed out with google');
  }
}
