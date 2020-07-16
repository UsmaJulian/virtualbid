import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String imageEvent;
  final String pdfUrl;

  EventModel(
      {this.imageEvent,
      this.pdfUrl,
      this.id,
      this.title,
      this.description,
      this.eventDate})
      : super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
        title: data['title'],
        description: data['description'],
        eventDate: data['event_date'],
        imageEvent: data['imageEvent'],
        pdfUrl: data['pdfUrl']);
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
        id: id,
        title: data['title'],
        description: data['description'],
        eventDate: data['event_date'].toDate(),
        imageEvent: data['imageEvent'],
        pdfUrl: data['pdfUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      "imageEvent": imageEvent,
      "title": title,
      "description": description,
      "event_date": eventDate,
      "id": id,
      "pdfUrlL": pdfUrl
    };
  }
}
