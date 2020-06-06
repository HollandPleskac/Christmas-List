import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Business_Logic/fire.dart';

Firestore _firestore = Firestore.instance;
final _fire = Fire();

class MyGiftsScreen extends StatefulWidget {
  static const routeName = 'my-gifts-screen';
  @override
  _MyGiftsScreenState createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _giftNameController = TextEditingController();
    TextEditingController _giftPriceController = TextEditingController();


    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final routeArguments = ModalRoute.of(context).settings.arguments as Map;
    final uid = routeArguments['uid'];
    final eventId = routeArguments['eventId'];
    final displayName = routeArguments['displayName'];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Holland Pleskac\'s Gifts'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _giftNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              hintText: 'Gift Name',
                              icon: Icon(
                                Icons.card_giftcard,
                                color: Colors.grey[500],
                                size: 26,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _giftPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              hintText: 'Gift Price',
                              icon: Icon(
                                Icons.attach_money,
                                color: Colors.grey[500],
                                size: 26,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                  color: Color.fromRGBO(37, 151, 234, 1),
                                  onPressed: () {
                                    _fire.addGift(
                                      displayName,
                                      _giftNameController.text,
                                      uid,
                                      eventId,
                                      int.parse(_giftPriceController.text),
                                    );
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: _firestore
              .collection('Events')
              .document(eventId)
              .collection('members')
              .document(uid)
              .collection('members')
              .document(displayName)
              .collection('gifts')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Column(
                  children: snapshot.data.documents.map(
                    (DocumentSnapshot document) {
                      return gift(
                        context,
                        document.documentID,
                        document['giftPrice'],
                        uid,
                        eventId,
                        displayName,
                      );
                    },
                  ).toList(),
                );
            }
          },
        ),
      ),
    );
  }
}

Widget gift(
  BuildContext context,
  String giftName,
  int giftPrice,
  String uid,
  String eventId,
  String memberName,
) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: InkWell(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                  side: BorderSide(width: 1.5, color: Colors.grey[300]),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                  vertical: MediaQuery.of(context).size.height * 0.0085,
                ),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Icon(
                      LineIcons.gift,
                      size: 40,
                      color: Colors.blue[600],
                    ),
                  ),
                  title: Text(
                    giftName,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: Colors.grey[500],
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.002,
                          horizontal: MediaQuery.of(context).size.width * 0.013,
                        ),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.0025),
                        child: Text(
                          '\$' + giftPrice.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      IconButton(
                          icon: Icon(
                            (Icons.delete),
                            size: 28,
                          ),
                          onPressed: () {
                            _fire.removeGift(
                              memberName,
                              giftName,
                              uid,
                              eventId,
                              giftPrice,
                            );
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ],
                  ),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
