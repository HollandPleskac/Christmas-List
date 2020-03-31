import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pleskac_christmas_list/screens/family_members_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyGroup extends StatelessWidget {
  final String _uid;
  final String familyName;
  final String familyEmail;
  final String familyProfilePicture;
  final int _totalGifts;
  final String imageUrl;

  FamilyGroup(
    this._uid,
    this.familyName,
    this.familyEmail,
    this.familyProfilePicture,
    this._totalGifts,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, FamilyMembersScreen.routeName,
          arguments: {'uid': _uid, 'isView': true}),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: imageUrl == null
                      ? Image.asset(
                          familyProfilePicture,
                          height: 250, // was 250 originally
                          width: double.infinity,
                          fit: BoxFit.cover,
                          //BoxFit.cover resizes and crops the image so that it fits nicely into the container
                        )
                      : Image.network(
                          imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                //ClipRRect takes a child and forces that child into a certain form - ex. child is an image that is forced to have rounded corner          ],
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    // makes sure that text can be read even with bright colors
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      familyName,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      // softWrap: true - if the text is too long for the container - it is wrapped
                      overflow: TextOverflow.fade,
                      // text fades out if the text overflows out of the box
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // empty space in the row is split up evenly
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          LineIcons.gift,
                          color: Colors.red[600],
                        ),
                        SizedBox(width: 6),
                        Text(_totalGifts.toString() + ' Gifts')
                      ],
                    ),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("PleskacFam")
                            .document(_uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text('loading');
                          } else {
                            Map<String, dynamic> documentFields =
                                snapshot.data.data;
                            return Row(
                              children: <Widget>[
                                Icon(
                                  LineIcons.group,
                                  color: Colors.blue[600],
                                ),
                                SizedBox(width: 6),
                                Text(documentFields['totalMembers'].toString() +
                                    ' Members'),
                              ],
                            );
                          }
                        }),
                    InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              LineIcons.globe,
                              color: Colors.green[800],
                            ),
                            SizedBox(width: 6),
                            Text('Contact'),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return familyName == '' || familyEmail == ''
                                    ? AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        title:
                                            Text('No Information Availaible'),
                                      )
                                    : AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            'Contact ' + familyName,
                                          ),
                                        ),
                                        content: Text(familyEmail),
                                        actions: <Widget>[
                                          FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                            child: Text(
                                              'Close',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
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
                        }),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
