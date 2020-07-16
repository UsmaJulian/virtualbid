import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ManageStream extends StatefulWidget {
  @override
  _ManageStreamState createState() => _ManageStreamState();
}

class _ManageStreamState extends State<ManageStream> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          backgroundColor: Color(0xff88ba25),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.angleLeft,
                color: Color(0xff005549),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Administrar evento',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                color: Color(0xff005549)),
          ),
        ),
      ),
      body: Center(
          child: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('offers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data?.documents == null) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var hora = DateFormat.jms('es').format(
                      (snapshot.data.documents[index]['offerTime'].toDate()));

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Paleta',
                              style: TextStyle(color: Color(0xff005549)),
                            ),
                            Text(snapshot.data.documents[index]['paddle']
                                .toString())
                          ],
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                          height: 30,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Nombre',
                              style: TextStyle(color: Color(0xff005549)),
                            ),
                            Text(snapshot.data.documents[index]['displayName']
                                .toString())
                          ],
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                          height: 30,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Oferta',
                              style: TextStyle(color: Color(0xff005549)),
                            ),
                            Text(snapshot.data.documents[index]['offer']
                                .toString())
                          ],
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                          height: 30,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Hora',
                              style: TextStyle(color: Color(0xff005549)),
                            ),
                            Text(hora.toString())
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff005549),
          child: Icon(FontAwesomeIcons.coins),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                title: Text('Actualizar precio'),
                content: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ej: 1.000.000',
                  ),
                  controller: _controller,
                  keyboardType: TextInputType.number,
                ),
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
                          .collection('valuesbid')
                          .document('doc')
                          .setData({"value": _controller.text.toString()});
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Actualizar',
                      style: TextStyle(
                        color: Color(0xff005549),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
