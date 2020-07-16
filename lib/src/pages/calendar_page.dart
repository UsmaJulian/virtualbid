import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:virtualbidapp/src/models/event_model.dart';
import 'package:virtualbidapp/src/pages/more_info_page.dart';

import 'package:virtualbidapp/src/pages/register_page.dart';

import 'package:virtualbidapp/src/services/event_firestore_service.dart';

class CalendarPage extends StatefulWidget {
  final userID;
  final userInfo;

  const CalendarPage({@required this.userID, this.userInfo});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];

    setState(() {});
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _events,
                      locale: 'es_ES',
                      initialCalendarFormat: CalendarFormat.month,
                      calendarStyle: CalendarStyle(
                          todayColor: Colors.red,
                          selectedColor: Color(0xff568a00),
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Color(0xff005549),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (date, events) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xff005549),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map((event) => Column(
                          children: <Widget>[
                            ListTile(
                              leading: Image.network(event.imageEvent),
                              title: Text(
                                event.title,
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                var fecha = DateFormat.yMMMMd('es')
                                    .format(event.eventDate);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                    ),
                                    title: Text('Evento para el día: $fecha'),
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
                                          _saveDate(
                                              title: event.title,
                                              description: event.description,
                                              event_date: event.eventDate);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Guardar',
                                          style: TextStyle(
                                              color: Color(0xff568a00)),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterPage(
                                                        userID: widget.userID,
                                                        userInfo:
                                                            widget.userInfo,
                                                        eventDate:
                                                            event.eventDate,
                                                        eventTitle: event.title,
                                                      )));
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Registro',
                                          style: TextStyle(
                                            color: Color(0xff005549),
                                          ),
                                        ),
                                      )
                                    ],
                                    content: Text(event.description),
                                  ),
                                );
                              },
                            ),
                            Column(
                              children: <Widget>[
                                ButtonTheme(
                                  buttonColor: Color(0xff005549),
                                  minWidth: 160,
                                  height: 40,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        "Cargar pdf",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MoreInfoPage(
                                                      url: event.pdfUrl,
                                                      userID: widget.userID,
                                                    )));
                                      }),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _saveDate({String title, String description, DateTime event_date}) {
    return Firestore.instance
        .collection('users')
        .document(widget.userID)
        .collection('personalevents')
        .document()
        .setData({
      'title': title,
      'description': description,
      'event_date': event_date,
    });
  }
}
