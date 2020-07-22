import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualbidapp/src/pages/add_event_page.dart';
import 'package:virtualbidapp/src/pages/archive_page.dart';
import 'package:virtualbidapp/src/pages/calendar_page.dart';
import 'package:virtualbidapp/src/pages/favorites_page.dart';
import 'package:virtualbidapp/src/pages/live_page.dart';
import 'package:virtualbidapp/src/pages/manage_streaming_page.dart';
import 'package:virtualbidapp/src/pages/messages_page.dart';
import 'package:virtualbidapp/src/pages/profile_page.dart';
import 'package:virtualbidapp/src/pages/settings_page.dart';
import 'package:virtualbidapp/src/pages/videosList_page.dart';
import 'package:http/http.dart' as http;
import 'package:virtualbidapp/src/providers/push_notifications_provider.dart';
import 'package:virtualbidapp/src/utilities/channelid_dart.dart';
import 'package:virtualbidapp/src/utilities/key.dart';
import 'package:virtualbidapp/src/widgets/show_dialog.dart';

class HomePage extends StatefulWidget {
  final userID;
  final userInfo;

  const HomePage({
    @required this.userID,
    this.userInfo,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String videoID;
  String videoTitle;
  String videoDescr;
  Stream<QuerySnapshot> stream;
  String args;
  File _avatarImage;
  final picker = ImagePicker();
  @override
  void initState() {
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.messages.listen((data) {
      print('Argumento del Push');
      print(data);
    });
    _tabController = new TabController(
      length: 4,
      vsync: this,
    );
    setState(() {
      stream = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.userID)
          .snapshots();
      fun();
    });

    super.initState();
  }

  Future<int> fun() async {
    final apiKey2 = API_KEY;
    final channelId = Channel_Id;
    final response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=live&type=video&key=$apiKey2");
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body.toString());
      final jsonData = jsonDecode(response.body);
      Map<dynamic, dynamic> mapDatos = jsonData;
      // print('videoId: ${mapDatos['items'][0]['id']['videoId']}');
      if (mapDatos['items'] != null && mapDatos['items'].isNotEmpty) {
        setState(() {
          videoID = '${mapDatos['items'][0]['id']['videoId']}';
          videoTitle='${mapDatos['items'][0]['id']['title']}';
          videoDescr='${mapDatos['items'][0]['id']['description']}';
        });
      }

      return response.statusCode;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'VIRTUAL',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xff048374)),
                ),
                SizedBox(width: 2.0),
                Text(
                  'BID',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xff88ba25)),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          // backgroundColor: Color(0xff88ba25),
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(
                  text: 'VIDEOS',
                  icon: Icon(
                    FontAwesomeIcons.youtube,
                    color: Color(0xff005549),
                    size: 24.0,
                  )),
              Tab(
                  text: 'EN VIVO',
                  icon: Icon(
                    FontAwesomeIcons.video,
                    color: Color(0xff005549),
                    size: 24.0,
                  )),
              Tab(
                  text: 'CALENDARIO',
                  icon: Icon(
                    FontAwesomeIcons.solidCalendarAlt,
                    color: Color(0xff005549),
                    size: 24.0,
                  )),
              Tab(
                  text: 'MIS FECHAS',
                  icon: Icon(
                    FontAwesomeIcons.solidBookmark,
                    color: Color(0xff005549),
                    size: 24.0,
                  )),
            ],
            controller: _tabController,
            indicatorWeight: 3.0,
            indicatorPadding: EdgeInsets.only(left: 18, right: 18),
            indicatorColor: Color(0xff568a00),
          ),
        ),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data?.documents == null) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                return Drawer(
                  child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.28,
                            child: DrawerHeader(
                              decoration:
                                  BoxDecoration(color: Color(0xff88ba25)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 25),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffd8d8d8)),
                                          borderRadius:
                                              BorderRadius.circular(300)),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(300),
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    'assets/img/no_profile_img.png'),
                                                image: NetworkImage(
                                                  snapshot
                                                      .data
                                                      .documents[index]
                                                          ['photoURL']
                                                      .toString(),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 48.0, top: 60),
                                              child: IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.camera,
                                                    color: Color(0xff005549),
                                                  ),
                                                  onPressed: () async {
                                                    final pickedFileAvatar =
                                                        await picker.getImage(
                                                            source: ImageSource
                                                                .gallery);
                                                    setState(() {
                                                      _avatarImage = File(
                                                          pickedFileAvatar
                                                              .path);
                                                    });
                                                    if (_avatarImage != null) {
                                                      var imageAvatar =
                                                          Uuid().v1();
                                                      var imageAvatarPath =
                                                          '/user/avatar/${widget.userID}/$imageAvatar.jpg';
                                                      final StorageReference
                                                          storageReference =
                                                          FirebaseStorage()
                                                              .ref()
                                                              .child(
                                                                  imageAvatarPath);
                                                      final StorageUploadTask
                                                          uploadTask =
                                                          storageReference
                                                              .putFile(
                                                                  _avatarImage);
                                                      final StreamSubscription<
                                                              StorageTaskEvent>
                                                          streamSubscription =
                                                          uploadTask.events
                                                              .listen((event) {
                                                        print(
                                                            'EVENT ${event.type}');
                                                      });
                                                      await uploadTask
                                                          .onComplete;
                                                      streamSubscription
                                                          .cancel();
                                                      Firestore.instance
                                                          .collection('users')
                                                          .document(
                                                              widget.userID)
                                                          .updateData({
                                                        "photoURL":
                                                            (await storageReference
                                                                    .getDownloadURL())
                                                                .toString()
                                                      });
                                                    } else {
                                                      showdialogVisitados(
                                                          context);
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 8.0),
                                    child: Text(
                                      snapshot
                                          .data.documents[index]['displayName']
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff005549),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                color: Colors.black,
                                height: 4,
                                width: MediaQuery.of(context).size.width * 0.15,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(18.0),
                            leading: Icon(
                              FontAwesomeIcons.solidUserCircle,
                              color: Color(0xff048374),
                            ),
                            title: Text(
                              'Perfil',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            userID: widget.userID,
                                          )));
                            },
                          ),
                          Center(
                            child: Container(
                              color: Colors.black38,
                              height: 1,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(18.0),
                            leading: Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Color(0xff048374),
                            ),
                            title: Text(
                              'Favoritos',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavoritesPage(
                                            userID: widget.userID,
                                          )));
                            },
                          ),
                          Center(
                            child: Container(
                              color: Colors.black38,
                              height: 1,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(18.0),
                            leading: Icon(
                              FontAwesomeIcons.solidEnvelope,
                              color: Color(0xff048374),
                            ),
                            title: Text(
                              'Mensajes',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagesPage()));
                            },
                          ),
                          Center(
                            child: Container(
                              color: Colors.black38,
                              height: 1,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          if (snapshot.data.documents[index]['role'] == 'Admin')
                            Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.all(18.0),
                                  leading: Icon(
                                    FontAwesomeIcons.plus,
                                    color: Color(0xff048374),
                                  ),
                                  title: Text(
                                    'Agregar evento',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddEventPage()));
                                  },
                                ),
                                Center(
                                  child: Container(
                                    color: Colors.black38,
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(18.0),
                                  leading: Icon(
                                    FontAwesomeIcons.stream,
                                    color: Color(0xff048374),
                                  ),
                                  title: Text(
                                    'Administrar evento',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManageStream()));
                                  },
                                ),
                                Center(
                                  child: Container(
                                    color: Colors.black38,
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ListTile(
                            contentPadding: EdgeInsets.all(18.0),
                            leading: Icon(
                              FontAwesomeIcons.cogs,
                              color: Color(0xff048374),
                            ),
                            title: Text(
                              'Ajustes',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()));
                            },
                          ),
                          Center(
                            child: Container(
                              color: Colors.black38,
                              height: 1,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
        body: TabBarView(
          children: [
            VideosListPage(
              userID: widget.userID,
            ),
            LivePage(
              userInfo: widget.userInfo,
              id: videoID,
              title:videoTitle,
              descr:videoDescr
            ),
            CalendarPage(
              userID: widget.userID,
              userInfo: widget.userInfo,
            ),
            ArchivePage(userID: widget.userID)
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
