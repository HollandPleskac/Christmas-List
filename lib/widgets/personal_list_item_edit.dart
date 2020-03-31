import 'package:flutter/material.dart';
import 'package:pleskac_christmas_list/app_config.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalListItemEdit extends StatelessWidget {
  final String personName;
  final bool isView;
  final String giftName;
  final String giftPrice;
  final String giftUrl;
  final String giftDescription;
  final String uid;

  PersonalListItemEdit(
    this.personName,
    this.isView,
    this.giftName,
    this.giftPrice,
    this.giftUrl,
    this.giftDescription,
    this.uid,
  );

  final TextEditingController _giftNameController = TextEditingController();
  final TextEditingController _giftPriceController = TextEditingController();
  final TextEditingController _giftUrlController = TextEditingController();
  final TextEditingController _giftDescriptionController =
      TextEditingController();

  static var _appConfigInstance = AppConfig();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(width: 1.5,color: Colors.grey[300]),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      margin: EdgeInsets.only(top: 3),
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
                                    return giftDescription == ''
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
                                                    BorderRadius.circular(10)),
                                            title: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                giftName + ' Information',
                                              ),
                                            ),
                                            content: Text(giftDescription),
                                            actions: <Widget>[
                                              FlatButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 2, right: 6.0),
                            child: IconButton(
                              icon: Icon(
                                (Icons.link),
                                size: 28,
                              ),
                              onPressed: () async {
                                if (await canLaunch(giftUrl)) {
                                  await launch(giftUrl);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          title: Text(
                                            'Error: Could not launch url',
                                            style: TextStyle(
                                                color: Colors.red[800],
                                                fontWeight: FontWeight.w800),
                                          ),
                                          //actions: <Widget>[
                                          //  FlatButton(
                                          //  color: Colors.blue[500],
                                          //shape: RoundedRectangleBorder(
                                          //  borderRadius:
                                          //    BorderRadius.circular(0)),
                                          //child: Text(
                                          //'Close',
                                          //style: TextStyle(
                                          //  color: Colors.white,
                                          //fontWeight: FontWeight.w700,
                                          //fontSize: 15),
                                          //),
                                          //onPressed: () {
                                          //Navigator.of(context).pop();
                                          //},
                                          //),
                                          //],
                                        );
                                      });
                                }
                              },
                            ),
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
                            onPressed: () => _appConfigInstance.editGift(
                              personName,
                              _giftNameController.text,
                              _giftPriceController.text,
                              _giftUrlController.text,
                              _giftDescriptionController.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2, right: 6.0),
                            child: IconButton(
                                icon: Icon(
                                  (Icons.delete),
                                  size: 28,
                                ),
                                onPressed: () {
                                  _appConfigInstance.removeGift(
                                    personName,
                                    giftName,
                                  );
                                }),
                          ),
                        ],
                      ),
              ),
              elevation: 3,
            ),
          ),
        ),
        //Positioned(
        //  top: 10,
        //   right: 14,
        //  child: CircleAvatar(
        //     backgroundColor: Colors.red,
        //   radius: 13,
        //    child: Text('1'),
        //  ),
        //  ),
      ],
    );
  }
}

//change book for giftPrice
