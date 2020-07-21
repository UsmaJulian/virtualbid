import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtualbidapp/src/models/channel_model.dart';
import 'package:virtualbidapp/src/models/video_model.dart';
import 'package:virtualbidapp/src/pages/video_page.dart';
import 'package:virtualbidapp/src/services/api_service.dart';
import 'package:virtualbidapp/src/utilities/channelid_dart.dart';
import 'package:auto_size_text/auto_size_text.dart';

class VideosListPage extends StatefulWidget {
  final userID;

  const VideosListPage({@required this.userID});
  @override
  _VideosListPageState createState() => _VideosListPageState();
}

class _VideosListPageState extends State<VideosListPage> {
  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance.fetchChannel(channelId: Channel_Id);
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            backgroundImage: NetworkImage(
              _channel.profilePictureUrl,
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   '${_channel.subscriberCount} subscribers',
                //   style: TextStyle(
                //     color: Colors.grey[600],
                //     fontSize: 16.0,
                //     fontWeight: FontWeight.w600,
                //   ),
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoScreen(id: video.id),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            height: 140.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Image(
                  width: 150.0,
                  image: NetworkImage(video.thumbnailUrl),
                ),
                SizedBox(width: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: AutoSizeText(

                        'Titulo: ' + video.title,
                        minFontSize: 18,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      width: 160,
                      child: AutoSizeText(
                        'Descripción: ' + video.description,
                        minFontSize: 14,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff005549),

                        ),

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 5,
            child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Color(0xff005549),
                ),
                onPressed: () {
                  print(video.id);
                  Firestore.instance
                      .collection('users')
                      .document(widget.userID)
                      .collection('favorites')
                      .add({'favorites': video.id});
                }))
      ],
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: 1 + _channel.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel.videos[index - 1];
                  return _buildVideo(video);
                },
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(animating: true),
            ),
    );
  }
}
