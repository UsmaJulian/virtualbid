import 'package:cloud_firestore/cloud_firestore.dart';
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
                          Text(day.toString()),
                          Text(month.toString())
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          snapshot.data.documents[index]['title'],
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            snapshot.data.documents[index]['description'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
