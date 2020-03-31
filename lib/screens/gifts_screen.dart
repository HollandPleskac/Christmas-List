import 'package:flutter/material.dart';
import '../widgets/personal_list_item_edit.dart';
import '../app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiftsScreen extends StatefulWidget {
  static const routeName = 'your-list-screen';
  @override
  _GiftsScreenState createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  static var _appConfigInstance = AppConfig();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _giftNameController = TextEditingController();
  final TextEditingController _giftPriceController = TextEditingController();
  final TextEditingController _giftUrlController = TextEditingController();
  final TextEditingController _giftDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final _uid = routeArguments['uid'];
    final _name = routeArguments['name'];
    final bool _isView = routeArguments['isView'];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
              // if viewing - there is no padding - since we have icon
              // if not viewing - there is padding - since we dont have an icon
              padding: _isView == true
                  ? EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0)
                  : EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Text(
                _name + '\'s List',
                style: TextStyle(color: Colors.blue),
              )),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
          // gets rid of the current sreen - acts like a back arrow
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          _isView == true
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextFormField(
                                    controller: _giftNameController,
                                    maxLength: 18,
                                    decoration:
                                        InputDecoration(hintText: 'Gift Name'),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Gift Name can\'t be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _giftPriceController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    decoration:
                                        InputDecoration(hintText: 'Gift Price'),
                                  ),
                                  TextFormField(
                                    controller: _giftUrlController,
                                    decoration:
                                        InputDecoration(hintText: 'Gift Url'),
                                  ),
                                  TextFormField(
                                    controller: _giftDescriptionController,
                                    decoration: InputDecoration(
                                        hintText: 'Gift Description'),
                                  ),
                                  RaisedButton(
                                    child: Text('Submit'),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _appConfigInstance.addGift(
                                          _name,
                                          _giftNameController.text,
                                          _giftPriceController.text,
                                          _giftUrlController.text,
                                          _giftDescriptionController.text,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                )
        ],
      ),
      body: Container(
        //decoration: BoxDecoration(
        //  gradient: LinearGradient(
        //    begin: Alignment.topLeft,
        //    end: Alignment(
        //        0.8, 0.0), // 10% of the width, so there are ten blinds.
        //    colors: [
        //      const Color(0xFFFFFFEE),
        //      const Color(0xFF999999)
        //    ], // whitish to gray
        //    tileMode: TileMode.repeated, // repeats the gradient over the canvas
        //  ),
        //),
        //
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("PleskacFam")
              .document(_uid)
              .collection('Members')
              .document(_name)
              .collection(_name + ' Gifts')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Column(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return PersonalListItemEdit(
                      document['personName'],
                      _isView,
                      document.documentID,
                      document['giftPrice'],
                      document['giftUrl'],
                      document['giftDescription'],
                      _uid,
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}
