class Live_val {
  final String videoId;
  final String publishId;
  final String channelId;
  final String title;
  final String description;
  final String url_image;
  final String channelTitle;
  final String LiveBroadCastcontent;

  Live_val(
      {this.videoId,
      this.publishId,
      this.channelId,
      this.title,
      this.description,
      this.url_image,
      this.channelTitle,
      this.LiveBroadCastcontent});

  factory Live_val.fromJson(Map<String, dynamic> json) {
    return Live_val(
      videoId: json['items'][0]['id']['videoId'],
      publishId: json['items'][0]['snippet']['publishedAt'],
      channelId: json['items'][0]['snippet']['channelId'],
      title: json['items'][0]['snippet']['title'],
      description: json['items'][0]['snippet']['description'],
      url_image: json['items'][0]['snippet']['thumbnails']['high']['url'],
      channelTitle: json['items'][0]['snippet']['channelTitle'],
      LiveBroadCastcontent: json['items'][0]['snippet']['liveBroadcastContent'],
    );
  }
}
