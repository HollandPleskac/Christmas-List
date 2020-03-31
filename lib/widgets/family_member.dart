import 'package:flutter/material.dart';
import 'package:pleskac_christmas_list/screens/gifts_screen.dart';
import 'package:pleskac_christmas_list/screens/gifts_screen.dart';
import 'package:line_icons/line_icons.dart';

class FamilyMember extends StatefulWidget {
  final bool isView;
  final String uid;
  final String name;
  final String age;
  final String rank;
  final int totalGifts;
  FamilyMember(
      this.isView, this.uid, this.name, this.age, this.rank, this.totalGifts);
  @override
  _FamilyMemberState createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.grey[300], width: 1.5),
                 ),
              elevation: 2,
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[400],
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
                      child: Icon(
                        LineIcons.user,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                title: Text(widget.name),
                subtitle: widget.totalGifts == 1
                    ? Container(
                      margin: EdgeInsets.all(2),
                      child: Row(
                          children: <Widget>[
                            Icon(LineIcons.gift,color: Colors.lightBlue[600],),
                            Padding(
                              padding: const EdgeInsets.only(left:6.0,top: 2.0),
                              child: Container(
                                child: Text(
                                  widget.totalGifts.toString() + ' Gift',
                                ),
                              ),
                            ),
                          ],
                        ),
                    )
                    : Container(
                      margin: EdgeInsets.all(2),
                      child: Row(
                          children: <Widget>[
                            Icon(LineIcons.gift,color: Colors.lightBlue[600],),
                            Padding(
                              padding: const EdgeInsets.only(left:6.0,top: 2.0),
                              child: Container(
                                child: Text(
                                  widget.totalGifts.toString() + ' Gifts',
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
              ),
            ),
            onTap: () =>
                Navigator.pushNamed(context, GiftsScreen.routeName, arguments: {
              'isView': widget.isView,
              'uid': widget.uid,
              'name': widget.name,
              'age': widget.age,
              'rank': widget.rank
            }),
          ),
        ),
       // Positioned(
    //      top: 9,
     //     right: 10,
     //     child: CircleAvatar(
     //       backgroundColor: Colors.blue[600],
     //       radius: 16,
     //       child: Text(
     //         '1',
      //        style: TextStyle(color: Colors.white),
     //       ),
       //   ),
      //  ),
      ],
    );
  }
}
