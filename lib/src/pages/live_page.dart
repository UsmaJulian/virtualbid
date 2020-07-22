import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:virtualbidapp/src/models/user_model.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LivePage extends StatefulWidget {
  final String id;
  final userInfo;
  final String title;
  final String descr;

  const LivePage({this.id, this.userInfo, this.title, this.descr});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<LivePage> with AfterLayoutMixin {
  YoutubePlayerController _controller;
  String _initialVideoId;

  @override
  void initState() {
    super.initState();
    setState(() {
      _initialVideoId = widget.id ;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _controller = YoutubePlayerController(
      initialVideoId: '$_initialVideoId',
      flags: YoutubePlayerFlags(
        forceHD: false,
        hideThumbnail: true,
        isLive: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_initialVideoId);
    return Scaffold(
      body: _initialVideoId != null
          ? StreamBuilder(
              stream: Firestore.instance.collection('valuesbid').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data?.documents == null) {
                  return Center(child: CupertinoActivityIndicator());
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          children: <Widget>[
//                            Container(
//                                width: double.infinity,
//                                height: 250,
//                                color: Colors.black),
                             YoutubePlayer(
                               controller: _controller,
                               showVideoProgressIndicator: true,
                             ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(widget.title??'',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff005549),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.descr??'',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(top: 160.0),
                              child: ButtonTheme(
                                buttonColor: Color(0xff005549),
                                minWidth: 260,
                                height: 40,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      'Ofertar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    onPressed: () {
                                      _widgetOfertas(
                                          context: context,
                                          userInfo: widget.userInfo,
                                          documentFields: snapshot
                                              .data.documents[index]['value']
                                              .toString());
                                    }),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Oferta Actual:'),
                                  Text(
                                    '\$ ${snapshot.data.documents[index]['value']}',
                                    style: TextStyle(color: Color(0xff88ba25)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              })
          : Center(
              child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'En este momento nos encontramos sin conexión, revisa nuestro calendario y registrate en los eventos para recibir notificaciones.',
                textAlign: TextAlign.justify,
              ),
            )),
    );
  }

  _widgetOfertas(
      {BuildContext context, User userInfo, String documentFields}) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StreamBuilder(
        stream: Firestore.instance
            .collection('paddles')
            .where('users', arrayContains: userInfo.displayName.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                print(snapshot.data.documents.length);

                if (snapshot.data.documents.length > 0) {
                  List<dynamic> info =
                      snapshot.data.documents[index]['users'].toList();
                  final idx = info.indexOf(userInfo.displayName.toString());
                  final paddle = idx + 1;
                  print('index :' + paddle.toString());
                  return Padding(
                    padding: const EdgeInsets.only(top: 220.0),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      title: Text('Oferta actual: ' + documentFields),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Firestore.instance
                                .collection('offers')
                                .document('${widget.userInfo.id}')
                                .setData(
                              {
                                "displayName": widget.userInfo.displayName,
                                "offer": documentFields,
                                "offerTime": DateTime.now(),
                                "paddle": paddle.toString(),
                                "uid": widget.userInfo.id
                              },
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Ofertar',
                            style: TextStyle(
                                color: Color(
                                  0xff005549,
                                ),
                                fontSize: 18),
                          ),
                        )
                      ],
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Tú número de paleta es: ' + paddle.toString())
                        ],
                      ),
                    ),
                  );
                }
                return null;
              },
            );
          }
          return AlertDialog( shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(16.0)),
          ),
            title: new Text("No te encuentras Registrado"),
            content: new Text("Por favor registrate para ofertar "),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
