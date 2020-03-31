import 'package:flutter/material.dart';
import 'package:pleskac_christmas_list/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pleskac_christmas_list/screens/sign_in_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
  static const routeName = 'sign-up-screen';
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _profileNameController = TextEditingController();
  bool _success;
  String _userEmail;
  String _error;
  static var _appConfigInstance = AppConfig();

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
                                Color.fromRGBO(98, 137, 255, 5)
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
                top: MediaQuery.of(context).size.height * 0.13,
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
                  'Sign Up',
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
                                controller: _profileNameController,
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
                                    hintText: 'Profile Name',
                                    icon: new Icon(
                                      Icons.person_outline,
                                      color: Colors.grey[500],
                                      size: 26,
                                    )),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Profile Name can\'t be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  23.0, 12.0, 0.0, 0.0),
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
                                          'Sign Up',
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
                                      _register();
                                    }
                                  },
                                ),
                              ),
                            ),
                            //Padding(
                            //padding: const EdgeInsets.fromLTRB(
                            //  65.0, 20.0, 65.0, 0.0),
                            //child: Container(
                            //height: 45,
                            //width: double.infinity,
                            //child: RaisedButton(
                            //shape: RoundedRectangleBorder(
                            //borderRadius: BorderRadius.circular(80),
//                                  ),
                            //                                padding: EdgeInsets.all(0.0),
                            //                              child: Ink(
                            //                              decoration: BoxDecoration(
                            //                              gradient: LinearGradient(
                            //                                begin: Alignment.centerLeft,
                            //                              end: Alignment.centerRight,
                            //                            colors: [
                            //                            Colors.red[600],
                            //                          Colors.red[500],
                            //                      ]),
                            //                borderRadius: BorderRadius.circular(80),
                            //            ),
                            //           child: Container(
                            //            constraints: BoxConstraints(
                            //              minHeight: 45,
                            //            minWidth: double.infinity),
                            //      child: Row(
                            //                                     mainAxisAlignment:
                            //                                       MainAxisAlignment.center,
                            //                                 children: <Widget>[
                            //                                 Text(
                            //                                 'Signin with ',
                            //                               style: TextStyle(
                            //                                 color: Colors.white,
                            //                               fontSize: 16,
                            //                             fontWeight: FontWeight.w300),
                            //                     ),
                            //                   Text(
                            //                   'Google',
                            //                 style: TextStyle(
                            //                 color: Colors.white,
                            //                                           fontSize: 20,
                            //                                         fontWeight: FontWeight.w600,
                            //                                     ),
                            //                                 ),
                            //                             ],
                            //                         ),
                            //                     ),
                            //                 ),
                            //               onPressed: () {},
                            //           ),
                            //       ),
                            //   ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                _success == null
                                    ? ''
                                    : (_success
                                        ? 'Successfully registered ' +
                                            _userEmail
                                        : _error),
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
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Sign In!',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blueAccent[400],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.pushNamed(
                                    context, SignInScreen.routeName),
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
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _profileNameController.dispose();
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
        _appConfigInstance.createFamily(
            _userUID, _userEmail, _profileNameController.text);
        sendEmailVerification(user);
      });
    } catch (e) {
      print('ERROR: ' + e.toString());
      setState(() {
        if (e.toString() ==
            'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
          _error = 'Invalid Email';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)') {
          _error = 'Password Must be at least 6 characters';
          _success = false;
        } else if (e.toString() ==
            'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
          _error = 'Email is Already in Use';
          _success = false;
        } else {
          _error = 'Unable to Create Account';
          _success = false;
        }
      });
    }
  }

  Future<void> sendEmailVerification(FirebaseUser recipient) async {
    recipient.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }
}
