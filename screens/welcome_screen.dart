import 'package:flutter/material.dart';
import 'package:name_gifts/screens/sign_up_screen.dart';
import '../Business_Logic/auth.dart';

import './sign_in_with_email_screen.dart';

final _auth = Auth();

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 322,
                child: Container(
                  color: Color.fromRGBO(37, 151, 234, 1),
                ),
              ),
              Expanded(
                flex: 345,
                child: Container(
                  color: Color.fromRGBO(243, 243, 243, 1),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.height * 0.39,
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.height * 0.04,
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Card(
                color: Colors.white,
                elevation: 6,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    signInButton(
                      context,
                      'Sign in with Google',
                      () async => _auth.loginWithGoogle(context),
                      Color.fromRGBO(37, 151, 234, 1),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    signInButton(
                      context,
                      'Sign in with Facebook',
                      () async => _auth.signOutGoogle(),
                      Color.fromRGBO(234, 37, 49, 1),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    signInButton(
                      context,
                      'Sign in with Twitter',
                      () async => _auth.signOutWithEmailandPassword(),
                      Color.fromRGBO(206, 37, 234, 1),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    signInWithEmailButton(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                                color: Color.fromRGBO(126, 126, 126, 1),
                                fontSize: 14),
                          ),
                          Text(
                            ' Sign Up!',
                            style: TextStyle(
                                color: Color.fromRGBO(37, 151, 234, 1),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.017,
                    ),
                    Text(
                      'Resend Email Verification',
                      style: TextStyle(
                          color: Color.fromRGBO(126, 126, 126, 1),
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.017,
                    ),
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color.fromRGBO(126, 126, 126, 1),
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Stack(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(
          //         MediaQuery.of(context).size.width * 0.325,
          //         MediaQuery.of(context).size.height * 0.09,
          //         MediaQuery.of(context).size.width * 0.325,
          //         MediaQuery.of(context).size.height * 0.73,
          //       ),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(
          //         MediaQuery.of(context).size.width * 0.392,
          //         MediaQuery.of(context).size.height * 0.12,
          //         0,
          //         0,
          //       ),
          //       child: Icon(
          //         Icons.card_giftcard,
          //         color: Color.fromRGBO(37, 151, 234, 1),
          //         size: 92,
          //       ),
          //     )
          //   ],
          // ),
          // Padding(
          //     padding: EdgeInsets.fromLTRB(
          //       MediaQuery.of(context).size.width * 0.32,
          //       MediaQuery.of(context).size.height * 0.29,
          //       0,
          //       0,
          //     ),
          //     child: Text(
          //       'Welcome',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 38,
          //       ),
          //     )),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.08, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Color.fromRGBO(37, 151, 234, 1),
                    size: 85,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0.0, MediaQuery.of(context).size.height * 0.28, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget signInButton(
    BuildContext context, String name, Function function, Color color) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.65,
    height: MediaQuery.of(context).size.height * 0.075,
    child: RaisedButton(
      elevation: 0,
      color: color,
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            blurRadius: 4,
            offset: Offset(8, 8),
            color: Color(000000).withOpacity(.25),
            spreadRadius: -5)
      ],
    ),
  );
}

Widget signInWithEmailButton(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.65,
    height: MediaQuery.of(context).size.height * 0.075,
    child: RaisedButton(
      elevation: 0,
      color: Colors.white,
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInWithEmailScreen(),
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Color.fromRGBO(37, 151, 234, 1),
          width: 1,
        ),
      ),
      child: Text(
        'Sign in with Email',
        style: TextStyle(
          color: Color.fromRGBO(37, 151, 234, 1),
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            blurRadius: 4,
            offset: Offset(8, 8),
            color: Color(000000).withOpacity(.25),
            spreadRadius: -5)
      ],
    ),
  );
}
