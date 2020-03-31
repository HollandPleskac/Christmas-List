import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './my_family_members_screen.dart';
import './sign_up_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  static const routeName = 'signin-page';
  final String title = 'Sign In';
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //        end: Alignment(
        //             0.8, 0.0), // 10% of the width, so there are ten blinds.
        //         colors: [
        // //        const Color(0xFFFFFFEE),
        //         const Color(0xFF999999)
        //      ], // whitish to gray
        //      tileMode: TileMode.repeated, // repeats the gradient over the canvas
        // ),
        //     ),
        child: Builder(builder: (BuildContext context) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _EmailPasswordForm(),
            ],
          );
        }),
      ),
    );
  }

  // Example code for sign out.
  //void _signOut() async {
  //  await _auth.signOut();
//  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _userUid;
  String _error = 'Failed to Sign In';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: const Text(
                        'Welcome!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w800),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent.withOpacity(0.90),
                      radius: 90,
                      child: Icon(
                        Icons.ac_unit,
                        color: Colors.blue[300],
                        size: 120,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        hintText: 'Email',
                        icon: new Icon(
                          Icons.mail_outline,
                          color: Colors.grey[700],
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
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
                  child: TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        hintText: 'Password',
                        icon: new Icon(
                          Icons.lock_outline,
                          color: Colors.grey[700],
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
                  padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Colors.blueAccent[200],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _signInWithEmailAndPassword();
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _success == false ? _error : '',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Dont have an account? ',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Sign Up!',
                  style: TextStyle(color: Colors.blueAccent[400]),
                ),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          ),
        ],
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
      setState(() {
        _success = true;
        _userEmail = user.email;
        _userUid = user.uid;
        Navigator.pushNamed(context, MyFamilyMembersScreen.routeName,
            arguments: {'currentUserUID': _userUid, 'isView': false});
      });
    } catch (e) {
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
  
}
