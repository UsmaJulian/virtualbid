import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';
import 'package:virtualbidapp/src/providers/paddle_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LivePage extends StatefulWidget {
  final String id;
  final String title;
  final String descr;

  const LivePage({this.title, this.descr, this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<LivePage> with AfterLayoutMixin {
  final UserPaddle _paddle = new UserPaddle();
  YoutubePlayerController _controller;
  String _initialVideoId;
  String _paddleNumber;

  @override
  void initState() {
    super.initState();
    setState(() {
      _initialVideoId = widget.id;
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
    if (_initialVideoId != null)
      showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (BuildContext context) => AlertDialog(
          title: Text('Bienvenido, '),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Text('Por favor ingresa tu número de paleta.'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de paleta',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _paddleNumber = value;
                    });
                  },
                  validator: (value) =>
                      value.isEmpty ? 'ingresa tu número de paleta' : null,
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                )),
            FlatButton(
                onPressed: () {
                  int numb = int.parse(_paddleNumber);
                  _paddle.setpaleta = numb;

                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Color(0xff005549),
                  ),
                )),
          ],
        ),
      );
    setState(() {});
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
              stream: FirebaseFirestore.instance
                  .collection('valuesbid')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data?.docs == null) {
                  return Center(child: CupertinoActivityIndicator());
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //     width: double.infinity,
                            //     height: 250,
                            //     color: Colors.black),
                            YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(widget.title ?? '',
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
                                child: Text(widget.descr ?? '',
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
                                          ofertaActual:
                                              '${snapshot.data.docs[index].data()['value']}');
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
                                    '\$ ${snapshot.data.docs[index].data()['value']}',
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
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'En este momento nos encontramos sin conexión, revisa nuestro calendario y registrate en los eventos para recibir notificaciones.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15),
              ),
            )),
    );
  }

  _widgetOfertas({BuildContext context, String ofertaActual}) async {
    print(_paddle.getpaleta);
    int paleta = _paddle.getpaleta;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('paddle', isEqualTo: paleta)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.docs.length);
            print(snapshot.data.docs[0].data()['displayName']);

            return Container(
              child: AlertDialog(
                title: Center(
                    child: Text(snapshot.data.docs[0].data()['displayName'])),
                content: Container(
                  height: 50,
                  child: Column(
                    children: [
                      Text('Tu numero de paleta es: $paleta '),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Tu oferta es de: $ofertaActual'),
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.red),
                      )),
                  FlatButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('offers')
                            .doc(snapshot.data.docs[0].data()['displayName'])
                            .set({
                          "displayName":
                              snapshot.data.docs[0].data()['displayName'],
                          "offer": ofertaActual,
                          "offerTime": DateTime.now(),
                          "paddle": paleta,
                        }, SetOptions(merge: false));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ofertar',
                        style: TextStyle(
                          color: Color(0xff005549),
                        ),
                      )),
                ],
              ),
            );
          } else {
            Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
