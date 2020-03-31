import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pleskac_christmas_list/screens/sign_up_screen.dart';
import 'my_family_members_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
  static const routeName = 'sign-in-screen';
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _userUid;
  String _error = 'Failed to Sign In';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.topRight,
                              colors: [
                                Color.fromRGBO(59, 108, 255, 5),
                                Color.fromRGBO(98, 137, 255, 5),
                                //Color.fromRGBO(48, 170, 255, 3),
                                //Color.fromRGBO(42, 207, 255, 3),
                              ]),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.166,
                left: MediaQuery.of(context).size.width * 0.33,
                right: MediaQuery.of(context).size.width * 0.33,
                bottom: MediaQuery.of(context).size.height * 0.7,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.317,
                left: MediaQuery.of(context).size.width * 0.39,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.42,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Card(
                    elevation: 3,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  23.0, 28.0, 0.0, 0.0),
                              child: TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: Colors.grey[700]),
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    hintText: 'Email',
                                    icon: new Icon(
                                      Icons.mail_outline,
                                      color: Colors.grey[500],
                                      size: 26,
                                    )),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Email can\'t be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  23.0, 12.0, 0.0, 0.0),
                              child: TextFormField(
                                controller: _passwordController,
                                style: TextStyle(color: Colors.grey[700]),
                                maxLines: 1,
                                obscureText: true,
                                autofocus: false,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    labelStyle:
                                        TextStyle(color: Colors.grey[700]),
                                    hintText: 'Password',
                                    icon: new Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey[500],
                                      size: 26,
                                    )),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Password can\'t be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  68.0, 27.0, 68.0, 0.0),
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromRGBO(59, 108, 255, 5),
                                            Color.fromRGBO(98, 137, 255, 5)
                                          ]),
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minHeight: 45,
                                          minWidth: double.infinity),
                                      child: Center(
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _signInWithEmailAndPassword();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  65.0, 20.0, 65.0, 0.0),
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.red[600],
                                              Colors.red[500],
                                            ]),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            minHeight: 45,
                                            minWidth: double.infinity),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Signin with ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              'Google',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await signInWithGoogle();
                                    }),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                _success == null
                                    ? ''
                                    : (_success ? null : _error),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Don\'t have an account? ',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Sign Up!',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueAccent[400],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, SignUpScreen.routeName),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      FirebaseUser user = result.user;
      if (user.isEmailVerified) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          _userUid = user.uid;
          Navigator.pushNamed(context, MyFamilyMembersScreen.routeName,
              arguments: {'currentUserUID': _userUid, 'isView': false});
        });
      } else {
        setState(() {
          _error = 'Please Verify Your Email to Continue';
          _success = false;
        });
      }
    } catch (e) {
      print('EEEERRRRROOOOORRR :::: ' + e.toString());
      setState(() {
        if (e.toString() ==
            'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)') {
          _error = 'Incorrect Password';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
          _error = 'User Not Found';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
          _error = 'Incorrect Email Format';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_TOO_MANY_REQUESTS, We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts. Please try again later. ], null)') {
          _error = 'Too Many Attempts - Please Try Again Later';
          _success = false;
        } else {
          _error = 'Failed to Sign In';
          _success = false;
        }
      });
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print('signed in');
  }
}
