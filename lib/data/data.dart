import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:core';
import 'dart:convert' as JSON;
import 'package:umacalendar_v2/data/event.dart';
import 'package:flutter/foundation.dart';

class Data
{
    static const String _BASE_URL = 'http://calendar.uma.pt/';

    static Future<void> fetchUserInfo()
    {
        Completer c = new Completer();

        SharedPrefs.getUser().then((user) async
        {
            if(user != null)
            {
                final response = await http.get(_BASE_URL + user);

                if(response.statusCode == 200)
                {
                    final String body = response.body.replaceAll("\r\n", "#");

                    final RegExp regex = new RegExp(r"BEGIN:VEVENT(.*?)END:VEVENT");
                    final Iterable<Match> events = regex.allMatches(body);

                    final List<Event> aulas = [];
                    final List<Event> avals = [];

                    final now = DateTime.now();

                    events.forEach((e) async
                    {
                        final data = e.group(0).split("#");
                        final parsedEvent = new Event(data,now);

                        if(parsedEvent.isValid())
                        {
                            if(parsedEvent.isAula()) aulas.add(parsedEvent);
                            else avals.add(parsedEvent);
                        }
                    });

                    await SharedPrefs.setAulas(aulas.toString());
                    await SharedPrefs.setAvals(avals.toString());
                }
                else
                {
                    // Número inválido
                }
            }
            c.complete();
        });

        return c.future;
    }

    static List prepareEvents(String data)
    {
        return JSON.jsonDecode(data);
    }

    static Future<void> onRefresh() async
    {
        return fetchUserInfo();
    }
}