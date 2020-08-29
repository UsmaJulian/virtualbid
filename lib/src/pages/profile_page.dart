import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  final userID;
  ProfilePage({@required this.userID});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            'MI PERFIL',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: Color(0xff005549),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 500,
            height: MediaQuery.of(context).size.height * 0.9,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: widget.userID)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.data?.documents == null) {
                    return Center(child: CupertinoActivityIndicator());
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Container(
                                  margin: EdgeInsets.all(15.0),
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff005549)),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          'assets/img/no_profile_img.png'),
                                      image: NetworkImage(
                                          snapshot
                                              .data.documents[index]['photoURL']
                                              .toString(),
                                          scale: 0.5),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                      'Mis datos personales',
                                      style: TextStyle(
                                          color: Color(0xff005549),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                                'Nombre: ' +
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                            ['displayName']
                                                        .toString(),
                                              ) ??
                                              '',
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidEdit,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Cambiar Nombre"),
                                                      content: TextFormField(
                                                        controller: _controller,
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child:
                                                              Text("Cancelar"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .clear());
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text("Aceptar"),
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(widget
                                                                    .userID)
                                                                .update({
                                                              'displayName':
                                                                  _controller
                                                                      .text
                                                                      .toString()
                                                            });
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .text);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Email: ' +
                                                snapshot.data
                                                    .documents[index]['email']
                                                    .toString(),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidEdit,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Cambiar Email"),
                                                      content: TextFormField(
                                                        controller: _controller,
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child:
                                                              Text("Cancelar"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .clear());
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text("Aceptar"),
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(widget
                                                                    .userID)
                                                                .update({
                                                              'email':
                                                                  _controller
                                                                      .text
                                                                      .toString()
                                                            });
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .text);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Teléfono: ' +
                                                snapshot.data
                                                    .documents[index]['phone']
                                                    .toString(),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidEdit,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Cambiar Teléfono"),
                                                      content: TextFormField(
                                                        controller: _controller,
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child:
                                                              Text("Cancelar"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .clear());
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text("Aceptar"),
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(widget
                                                                    .userID)
                                                                .update({
                                                              'phone':
                                                                  _controller
                                                                      .text
                                                                      .toString()
                                                            });
                                                            Navigator.pop(
                                                                context,
                                                                _controller
                                                                    .text);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
