import 'package:flutter/material.dart';
import 'package:umacalendar_v2/settings/settings.dart';
import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/data/data.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.theme}) : super(key: key);
  final String title;
  final ThemeData theme;
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static const Map<String, String> _TEXT = {
    'AULAS': 'Aulas',
    'AVALS': 'Avaliações',
    'EVENTS_NOT_FOUND': 'Sem eventos'
  };
  static const double _MARGIN = 5;

  int _currentIndex = 0;
  List _events = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    prepare();
  }

  void prepare() {
    switch (_currentIndex) {
      case 0:
        SharedPrefs.getAulas().then((aulas) {
          setState(() {
            if (aulas != null) _events = Data.prepareEvents(aulas);
            else Settings.open(context).then((_) { prepare(); });
          });
        });
        break;
      case 1:
        SharedPrefs.getAvals().then((avals) {
          setState(() {
            if (avals != null) _events = Data.prepareEvents(avals);
            else Settings.open(context).then((_) { prepare(); });
          });
        });
        break;
    }
  }

  Widget _buildItem(BuildContext ctxt, int index) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(_MARGIN),
        child: Column(
          children: <Widget>[
            ListTile(title: Text(_events[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),)),
            ListTile(title: Text(_events[index]['prof']), leading: Icon(Icons.info)),
            ListTile(title: Text(_events[index]['location']), leading: Icon(Icons.map)),
            ListTile(title: Text(_events[index]['date']), leading: Icon(Icons.today)),
            ListTile(title: Text(_events[index]['time']), leading: Icon(Icons.access_time)),
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
            Builder(builder: (BuildContext bContext) {
              return IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {
                    Settings.open(bContext).then((_) { prepare(); });
                  });
            })
          ],
        ),
        body: Builder(builder: (BuildContext bContext) {
          if (_events.length > 0) {
            return RefreshIndicator(
                onRefresh: () {
                    return Data.onRefresh(bContext).then((_) => prepare() );
                },
                child: ListView.builder(itemBuilder: _buildItem, itemCount: _events.length));
          } else {
            return RefreshIndicator(
                onRefresh: () {
                    return Data.onRefresh(bContext).then((_) => prepare() );
                },
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(_MARGIN),
                    children: [Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Icon(Icons.error),
                                Text(_TEXT['EVENTS_NOT_FOUND'])
                    ])]));
          }
        }),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.school), title: Text(_TEXT['AULAS'])),
              BottomNavigationBarItem(icon: Icon(Icons.date_range), title: Text(_TEXT['AVALS'])),
            ],
            onTap: (index) {
                _currentIndex = index;
                prepare();
            }));
  }
}
