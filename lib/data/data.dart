import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'dart:convert' as JSON;
import 'package:umacalendar_v2/data/event.dart';
import 'dart:convert' show utf8;

class Data
{
    static const String _BASE_URL = 'http://calendar.uma.pt/';
    static const String _REGEX = r"BEGIN:VEVENT(.*?)END:VEVENT";
    static const Map<String,String> _TEXT =
    {
        'SUCCESS': 'Informação obtida com sucesso',
        'USER_NOT_FOUND': 'Por favor introduza o número mecanográfico',
        'INVALID_USER': 'Número mecanográfico inválido',
        'ERROR': 'Falha na conectividade'
    };
    static const int _SUCCESS = 200;
    static const int _INVALID_USER = 500;

    static Future<void> fetchUserInfo(BuildContext context)
    {
        Completer c = new Completer();

        SharedPrefs.getUser().then((user) async
        {
            if(user != null)
            {
                final response = await http.get(_BASE_URL + user);

                switch (response.statusCode)
                {
                    case _SUCCESS:
                        final String body = utf8.decode(response.bodyBytes).replaceAll(
                            "\r\n", "#");
                        parseEvents(body);
                        showMessage(context,_TEXT['SUCCESS']);
                        break;

                    case _INVALID_USER:
                        showMessage(context,_TEXT['INVALID_USER']);
                        break;

                    default:
                        showMessage(context,_TEXT['ERROR']);
                        break;
                }
            }
            else
            {
                showMessage(context,_TEXT['USER_NOT_FOUND']);
                Settings.open(context);
            }
            c.complete();
        });

        return c.future;
    }

    static parseEvents(String body) async
    {
        final RegExp regex = new RegExp(_REGEX);
        final Iterable<Match> events = regex.allMatches(body);

        final List<Event> aulas = [];
        final List<Event> avals = [];

        final now = DateTime.now();

        events.forEach((e)
        async
        {
            final data = e.group(0).split("#");
            final parsedEvent = new Event(data, now);

            if (parsedEvent.isValid())
            {
                if (parsedEvent.isAula()) aulas.add(
                    parsedEvent);
                else
                    avals.add(parsedEvent);
            }
        });

        await SharedPrefs.setAulas(aulas.toString());
        await SharedPrefs.setAvals(avals.toString());
    }

    static void showMessage(BuildContext context, String msg)
    {
        final SnackBar s = SnackBar(
            content: Text(msg));
        Scaffold.of(context).showSnackBar(s);
    }

    static List prepareEvents(String data)
    {
        return JSON.jsonDecode(data);
    }

    static Future<void> onRefresh(BuildContext context) async
    {
        return await fetchUserInfo(context);
    }
}