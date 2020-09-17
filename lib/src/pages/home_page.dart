import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:virtualbidapp/src/pages/calendar_page.dart';
import 'package:virtualbidapp/src/pages/live_page.dart';
import 'package:virtualbidapp/src/pages/messages_page.dart';
import 'package:virtualbidapp/src/pages/settings_page.dart';
import 'package:virtualbidapp/src/pages/videosList_page.dart';

import 'package:virtualbidapp/src/utilities/channelid_dart.dart';
import 'package:virtualbidapp/src/utilities/key.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String videoID;
  String videoTitle;
  String videoDescr;

  String args;

  final picker = ImagePicker();
  @override
  void initState() {
    _tabController = new TabController(
      length: 3,
      vsync: this,
    );
    setState(() {
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
          videoTitle = '${mapDatos['items'][0]['id']['title']}';
          videoDescr = '${mapDatos['items'][0]['id']['description']}';
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
//                  Tab(
//                      text: 'MIS FECHAS',
//                      icon: Icon(
//                        FontAwesomeIcons.solidBookmark,
//                        color: Color(0xff005549),
//                        size: 24.0,
//                      )),
            ],
            controller: _tabController,
            indicatorWeight: 3.0,
            indicatorPadding: EdgeInsets.only(left: 18, right: 18),
            indicatorColor: Color(0xff568a00),
          ),
        ),
        body: TabBarView(
          children: [
            VideosListPage(),
            LivePage(id: videoID, title: videoTitle, descr: videoDescr),
            CalendarPage(),
//                ArchivePage()
          ],
          controller: _tabController,
        ),
        drawer: Drawer(
          child: ListView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DrawerHeader(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(color: Color(0xff88ba25)),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Color(0xff048374),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 90,
                            child: Image.asset('assets/logo/logo.png'),
                          ),
                        )),
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
        ),
      ),
    );
  }
}
