import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArchivePage extends StatefulWidget {
  final userID;

  const ArchivePage({@required this.userID});
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userID)
            .collection('personalevents')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data?.documents == null) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime datetime =
                    snapshot.data.documents[index]['event_date'].toDate();
                var day = datetime.day;
                var month = DateFormat.MMMM('es').format(datetime);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[200]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(day.toString(),style: TextStyle(color: Color(0xff88ba25)),),
                            Text(month.toString())
                          ],
                        ),
                      ),
                      Container(width: MediaQuery.of(context).size.width*0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AutoSizeText(
                             '${ snapshot.data.documents[index]['title']}',
                              minFontSize: 14,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle( color: Color(0xff048374),),
                            ),
                            SizedBox(height: 10,),
                            AutoSizeText(
                              '${snapshot.data.documents[index]['description']}',
                              minFontSize: 12,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,


                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
