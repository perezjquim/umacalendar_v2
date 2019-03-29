import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/data/data.dart';

class Settings
{
    static void _onUserChanged(BuildContext context)
    {
        SharedPrefs.setUser(fldUser.text);
        Data.onRefresh(context);
        _onClose(context);
    }

    static void _onClose(BuildContext context)
    {
        Navigator.pop(context);
    }

    static void onOpen(BuildContext context)
    {
        SharedPrefs.getUser().then((user) { fldUser.text = user; });
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: new Text("Número mecanográfico"),
                content: new TextField
                (
                    controller: fldUser,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(labelText: 'Ex.: 2099919')
                ),
                actions: <Widget>[
                    MaterialButton(child: Text('Confirmar'), onPressed: () { _onUserChanged(context); }),
                    MaterialButton(child: Text('Cancelar'), onPressed: () { _onClose(context); })
                ],
            ));
    }

    static final TextEditingController fldUser = new TextEditingController();
}