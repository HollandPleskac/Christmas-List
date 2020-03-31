import 'package:flutter/material.dart';
import 'package:pleskac_christmas_list/screens/view_family_screen.dart';
import 'package:pleskac_christmas_list/screens/gifts_screen.dart';
import 'package:pleskac_christmas_list/screens/sign_in_screen.dart';
import 'package:pleskac_christmas_list/screens/sign_up_screen.dart';
import 'screens/my_family_members_screen.dart';
import './screens/family_members_screen.dart';
import './screens/splash_screen.dart';
import './screens/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (ctx) => SplashScreen(),
        ViewFamilyScreen.routeName: (ctx) => ViewFamilyScreen(),
        FamilyMembersScreen.routeName: (ctx) => FamilyMembersScreen(),
        GiftsScreen.routeName: (ctx) => GiftsScreen(),
        SignInScreen.routeName: (ctx) => SignInScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        MyFamilyMembersScreen.routeName: (ctx) => MyFamilyMembersScreen(),
      },
    );
  }
}
