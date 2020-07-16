import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:virtualbidapp/src/pages/home_page.dart';

class MoreInfoPage extends StatefulWidget {
  final url;
  final userID;

  const MoreInfoPage({this.url, this.userID});

  @override
  _MoreInfoPageState createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf({String url}) async {
    await writeCounter(await fetchPost(url));
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadPdf(url: (widget.url).toString());
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(userID: widget.userID)));
              }),
          title: Text(
            'Más información',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: Color(0xff005549),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (path != null)
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PdfViewer(
                  filePath: path,
                ),
              )
            else
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 290.0),
                child: CupertinoActivityIndicator(),
              ))
          ],
        ),
      ),
    );
  }
}
