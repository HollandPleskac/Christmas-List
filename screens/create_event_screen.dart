import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore();
final _fire = Fire();

class CreateEventScreen extends StatefulWidget {
  static const routeName = 'create-event-screen';
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final String _uid = routeArguments['uid'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Event'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color.fromRGBO(126, 126, 126, 1),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                ),
                hintText: 'name of event',
                icon: Icon(Icons.adb),
              ),
            ),
            RaisedButton(
                child: Text('create event'),
                onPressed: () async {
                  String host = await _firestore
                      .collection("UserData")
                      .document(_uid)
                      .get()
                      .then(
                        (docSnapshot) => docSnapshot.data['email'],
                      );
                  _fire.createEvent(_eventNameController.text, _uid, host, true);
                })
          ],
        ),
      ),
    );
  }
}
