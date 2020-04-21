import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

Firestore _firestore = Firestore.instance;

class MyGiftsScreen extends StatefulWidget {
  static const routeName = 'my-gifts-screen';
  @override
  _MyGiftsScreenState createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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

Widget gift(BuildContext context, String giftName, int giftPrice) {
  bool isView = false;
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
                  trailing: isView == true
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                size: 28,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return 'giftDescription' == ''
                                          ? AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              title: Text(
                                                  'No Information Availaible'),
                                            )
                                          : AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              title: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  giftName + ' Information',
                                                ),
                                              ),
                                              content: Text('giftDescription'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  color: Colors.blue[500],
                                                )
                                              ],
                                            );
                                    });
                              },
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.005,
                                ),
                                IconButton(
                                  icon: Icon(
                                    (Icons.link),
                                    size: 28,
                                  ),
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.005,
                            ),
                            IconButton(
                                icon: Icon(
                                  (Icons.delete),
                                  size: 28,
                                ),
                                onPressed: () {}),
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
