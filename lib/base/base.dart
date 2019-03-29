import 'package:flutter/material.dart';
import 'package:umacalendar_v2/settings/settings.dart';
import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/data/event.dart';
import 'package:umacalendar_v2/data/data.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List _events = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  void _prepare()
  {
      switch (_currentIndex) {
          case 0:
              SharedPrefs.getAulas().then((aulas) {
                  setState(() {
                      if(aulas != null) _events = Data.prepareEvents(aulas);
                  });
              });
              break;
          case 1:
              SharedPrefs.getAvals().then((avals) {
                  setState(() {
                      if(avals != null) _events = Data.prepareEvents(avals);
                  });
              });
              break;
      }
  }

  Widget _buildItem(BuildContext ctxt, int index) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(_events[index]['title']),
            ),
            ListTile(
              title: Text(_events[index]['prof']),
              leading: Icon(Icons.info),
            ),
            ListTile(
                title: Text(_events[index]['location']),
                leading: Icon(Icons.map)),
            ListTile(
                title: Text(_events[index]['date']),
                leading: Icon(Icons.today)),
            ListTile(
                title: Text(_events[index]['time']),
                leading: Icon(Icons.access_time))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Settings.onOpen(context);
                }),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Data.onRefresh();
            },
            child: ListView.builder(
                itemBuilder: _buildItem, itemCount: _events.length)),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.school), title: Text('Aulas')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.date_range), title: Text('Avaliações')),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _prepare();
            }));
  }
}
