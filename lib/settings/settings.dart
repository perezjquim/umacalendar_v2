import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/data/data.dart';

class Settings
{
    static final TextEditingController fldUser = new TextEditingController();
    static const Map<String,String> _TEXT =
    {
        'NR_MEC': 'Número mecanográfico',
        'HINT': 'Ex.: 2088819',
        'CONFIRM': 'Confirmar',
        'CANCEL': 'Cancelar'
    };

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
                title: new Text(_TEXT['NR_MEC']),
                content: new TextField
                (
                    controller: fldUser,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(labelText: _TEXT['HINT']),
                    textInputAction: TextInputAction.done
                ),
                actions: <Widget>[
                    MaterialButton(child: Text(_TEXT['CONFIRM']), onPressed: () { _onUserChanged(context); }),
                    MaterialButton(child: Text(_TEXT['CANCEL']), onPressed: () { _onClose(context); })
                ],
            ));
    }
}