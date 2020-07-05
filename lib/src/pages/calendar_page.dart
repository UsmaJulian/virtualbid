import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtualbidapp/src/models/event_model.dart';
import 'package:virtualbidapp/src/models/user_model.dart';

import 'package:virtualbidapp/src/pages/add_event_page.dart';

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
                    ..._selectedEvents.map((event) => ListTile(
                          title: Text(
                            event.title,
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            var fecha =
                                DateFormat.yMMMMd('es').format(event.eventDate);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
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
                                      style:
                                          TextStyle(color: Color(0xff568a00)),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _registerEvent(
                                          usuario: widget.userInfo,
                                          event_date: event.eventDate,
                                          title: event.title);
                                    },
                                    child: Text(
                                      'Registrarme',
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
                        )),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEventPage()))),
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

  _registerEvent({User usuario, DateTime event_date, String title}) {
    return Firestore.instance
        .collection('paddles')
        .document('registered')
        .updateData({
      'users': FieldValue.arrayUnion([usuario.displayName])
    }).then((value) {
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
