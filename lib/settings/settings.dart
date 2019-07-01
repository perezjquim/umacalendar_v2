import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umacalendar_v2/settings/sharedprefs.dart';
import 'package:umacalendar_v2/data/data.dart';
import 'package:flutter/services.dart';

class Settings {
  static final TextEditingController fldUser = new TextEditingController();
  static const Map<String, String> _TEXT = {
    'NR_MEC': 'Número mecanográfico',
    'HINT': 'Ex.: 2088819',
    'CONFIRM': 'Confirmar',
    'CANCEL': 'Cancelar'
  };

  static Future open(BuildContext context) async
  {
      await _onOpen(context);
  }

  static void _onUserChanged(BuildContext context) {
    _setBusy(true,context);
    SharedPrefs.setUser(fldUser.text);
    Data.onRefresh(context).then((_) {
        _setBusy(false,context);
        _onClose(context);
    });
  }

  static void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  static Future _onOpen(BuildContext context) async {
    SharedPrefs.getUser().then((user) {
      fldUser.text = user;
    });
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(_TEXT['NR_MEC']),
            content: TextField(
              controller: fldUser,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(labelText: _TEXT['HINT']),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]"))
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Text(_TEXT['CONFIRM']),
                  onPressed: () {
                    if(fldUser.text != "") _onUserChanged(context);
                  }),
              MaterialButton(
                  child: Text(_TEXT['CANCEL']),
                  onPressed: () {
                      SharedPrefs.getUser().then((user) {
                          if(fldUser.text != "" || user != "") _onClose(context);
                      });
                  })
            ],
          );
        });
  }

  static void _setBusy(bool state, BuildContext context)
  {
      if (state)
      {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_)
              {
                  return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ CircularProgressIndicator() ],
                      ),
                  );
              }
          );
      }
      else
      {
          Navigator.pop(context);
      }
  }
}
