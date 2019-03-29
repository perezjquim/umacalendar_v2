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
                    case 200:
                        final String body = utf8.decode(response.bodyBytes).replaceAll(
                            "\r\n", "#");

                        final RegExp regex = new RegExp(
                            r"BEGIN:VEVENT(.*?)END:VEVENT");
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

                        final SnackBar s = SnackBar(
                            content: Text('Informação obtida com sucesso!'));
                        Scaffold.of(context).showSnackBar(s);
                        break;
                    case 500:
                        final SnackBar s = SnackBar(
                            content: Text('Número mecanográfico inválido!'));
                        Scaffold.of(context).showSnackBar(s);
                        break;
                    default:
                        final SnackBar s = SnackBar(
                            content: Text('Falha na conectividade!'));
                        Scaffold.of(context).showSnackBar(s);
                        break;
                }
            }
            else
            {
                final SnackBar s = SnackBar(
                    content: Text('Por favor introduza o número mecanográfico'));
                Scaffold.of(context).showSnackBar(s);
                Settings.onOpen(context);
            }
            c.complete();
        });

        return c.future;
    }

    static List prepareEvents(String data)
    {
        print(data);
        return JSON.jsonDecode(data);
    }

    static Future<void> onRefresh(BuildContext context) async
    {
        return fetchUserInfo(context);
    }
}