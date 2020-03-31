import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './sign_in_screen.dart';
import '../app_config.dart';
import 'package:line_icons/line_icons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPageOld extends StatefulWidget {
  static const routeName = 'register-page';
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => RegisterPageOldState();
}

class RegisterPageOldState extends State<RegisterPageOld> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _error;
  static var _appConfigInstance = AppConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //    decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment(
        //           0.8, 0.0), // 10% of the width, so there are ten blinds.
        //         colors: [
        //         const Color(0xFFFFFFEE),
        //         const Color(0xFF999999)
        //      ], // whitish to gray
        //      tileMode: TileMode.repeated, // repeats the gradient over the canvas
        //     ),
        //     ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
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
                              'Create an Account!',
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
                            backgroundColor:
                                Colors.transparent.withOpacity(0.90),
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
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
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
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
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
                                _register();
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
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully registered ' + _userEmail
                                  : _error),
                          style: TextStyle(color: Colors.red,fontSize: 14),
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
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Sign In!',
                        style: TextStyle(
                          color: Colors.blueAccent[400],
                        ),
                      ),
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, SignInScreen.routeName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      FirebaseUser user = result.user;

      setState(() {
        _success = true;
        _userEmail = user.email;
        String _userUID = user.uid;
        _appConfigInstance.createFamily(_userUID, _userEmail, 'family name');
      });
    } catch (e) {
      print('EEEEEEEEEEE ' + e.toString());
      setState(() {
        if (e.toString() ==
            'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
          _error = 'Invalid Email';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)') {
          _error = 'Password Must be at least 6 characters';
          _success = false;
        } else if (e.toString() == 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
          _error = 'Email is Already in Use';
          _success = false;
        } else {
          _error = 'Unable to Create Account';
          _success = false;
        }
      });
    }
  }
}
