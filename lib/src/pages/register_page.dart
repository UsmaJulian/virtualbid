import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualbidapp/src/models/user_model.dart';
import 'package:virtualbidapp/src/widgets/show_dialog.dart';

class RegisterPage extends StatefulWidget {
  final userID;
  final userInfo;
  final eventDate;
  final eventTitle;

  const RegisterPage(
      {@required this.userID,
      @required this.userInfo,
      @required this.eventDate,
      @required this.eventTitle});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _controller = TextEditingController();
  File _imageDoc;
  File _imageRut;
  File _imagePay;
  final picker = ImagePicker();
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
            'REGISTRO A EVENTOS',
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
                stream: Firestore.instance
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
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                width: MediaQuery.of(context).size.width * 0.9,
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
                                      'Datos personales',
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
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(widget
                                                                    .userID)
                                                                .updateData({
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
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(widget
                                                                    .userID)
                                                                .updateData({
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
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(widget
                                                                    .userID)
                                                                .updateData({
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'NIT./Cédula: ' +
                                                snapshot
                                                    .data
                                                    .documents[index]
                                                        ['identityCard']
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
                                                          "Cambiar mi NIT. o Cédula"),
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
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(widget
                                                                    .userID)
                                                                .updateData({
                                                              'identityCard':
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
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                      'Documentos requeridos',
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
                                          child:
                                              Text('Imagen de NIT. o Cédula'),
                                        ),
                                        if (_imageDoc != null)
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            height: 50,
                                            child: Image.file(_imageDoc),
                                          ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.idCard,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () async {
                                              final pickedFile =
                                                  await picker.getImage(
                                                      source:
                                                          ImageSource.gallery);
                                              setState(() {
                                                _imageDoc =
                                                    File(pickedFile.path);
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
                                          child: Text('Imagen del Rut '),
                                        ),
                                        if (_imageRut != null)
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            height: 50,
                                            child: Image.file(_imageRut),
                                          ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.idCard,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () async {
                                              final pickedFile1 =
                                                  await picker.getImage(
                                                      source:
                                                          ImageSource.gallery);
                                              setState(() {
                                                _imageRut =
                                                    File(pickedFile1.path);
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
                                          child: Text('Imagen del pagaré'),
                                        ),
                                        if (_imagePay != null)
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            height: 50,
                                            child: Image.file(_imagePay),
                                          ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.idCard,
                                              size: 16,
                                              color: Color(0xff005549),
                                            ),
                                            onPressed: () async {
                                              final pickedFile2 =
                                                  await picker.getImage(
                                                      source:
                                                          ImageSource.gallery);
                                              setState(() {
                                                _imagePay =
                                                    File(pickedFile2.path);
                                              });
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15.0),
                                child: ButtonTheme(
                                  buttonColor: Color(0xff005549),
                                  minWidth: 260,
                                  height: 40,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        'Registrarme',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onPressed: () async {
                                        if (_imageDoc != null) {
                                          var imageDocName = Uuid().v1();
                                          var imageDocPath =
                                              '/user/${widget.userID}/$imageDocName.jpg';
                                          final StorageReference
                                              storageReference =
                                              FirebaseStorage()
                                                  .ref()
                                                  .child(imageDocPath);

                                          final StorageUploadTask uploadTask =
                                              storageReference
                                                  .putFile(_imageDoc);

                                          final StreamSubscription<
                                                  StorageTaskEvent>
                                              streamSubscription =
                                              uploadTask.events.listen((event) {
                                            print('EVENT ${event.type}');
                                          });
                                          // Cancel your subscription when done.
                                          await uploadTask.onComplete;
                                          streamSubscription.cancel();
                                          Firestore.instance
                                              .collection('users')
                                              .document(widget.userID)
                                              .updateData({
                                            "imageIdentityCard":
                                                (await storageReference
                                                        .getDownloadURL())
                                                    .toString()
                                          });
                                        } else {
                                          showdialogVisitados(context);
                                        }
                                        if (_imageRut != null) {
                                          var imageRutName = Uuid().v1();
                                          var imageRutPath =
                                              '/user/${widget.userID}/$imageRutName.jpg';
                                          final StorageReference
                                              storageReference =
                                              FirebaseStorage()
                                                  .ref()
                                                  .child(imageRutPath);

                                          final StorageUploadTask uploadTask =
                                              storageReference
                                                  .putFile(_imageRut);

                                          final StreamSubscription<
                                                  StorageTaskEvent>
                                              streamSubscription =
                                              uploadTask.events.listen((event) {
                                            print('EVENT2 ${event.type}');
                                          });
                                          // Cancel your subscription when done.
                                          await uploadTask.onComplete;
                                          streamSubscription.cancel();
                                          Firestore.instance
                                              .collection('users')
                                              .document(widget.userID)
                                              .updateData({
                                            "imageRut": (await storageReference
                                                    .getDownloadURL())
                                                .toString()
                                          });
                                        } else {
                                          showdialogVisitados(context);
                                        }
                                        if (_imagePay != null) {
                                          var imagePayName = Uuid().v1();
                                          var imagePayPath =
                                              '/user/${widget.userID}/$imagePayName.jpg';
                                          final StorageReference
                                              storageReference =
                                              FirebaseStorage()
                                                  .ref()
                                                  .child(imagePayPath);

                                          final StorageUploadTask uploadTask =
                                              storageReference
                                                  .putFile(_imagePay);

                                          final StreamSubscription<
                                                  StorageTaskEvent>
                                              streamSubscription =
                                              uploadTask.events.listen((event) {
                                            print('EVENT3 ${event.type}');
                                          });
                                          // Cancel your subscription when done.
                                          await uploadTask.onComplete;
                                          streamSubscription.cancel();
                                          Firestore.instance
                                              .collection('users')
                                              .document(widget.userID)
                                              .updateData({
                                            "imagePay": (await storageReference
                                                    .getDownloadURL())
                                                .toString()
                                          });
                                        } else {
                                          showdialogVisitados(context);
                                        }
                                        _registerEvent(
                                            usuario: widget.userInfo,
                                            event_date: widget.eventDate,
                                            title: widget.eventTitle);
                                      }),
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

  _registerEvent({User usuario, DateTime event_date, String title}) {
    return Firestore.instance.collection('paddles').document().setData({
      'users': FieldValue.arrayUnion([usuario.displayName])
    }, merge: true).then((value) {
      Navigator.pop(context, true);
      showDialog(
          context: context,
          builder: (context) {
            var month = DateFormat.MMMM('es').format(event_date);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              title: Text('Evento para el día: ${event_date.day} de $month'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: Color(0xff005549),
                    ),
                  ),
                )
              ],
              content: Text(title),
            );
          });
    });
  }
}
