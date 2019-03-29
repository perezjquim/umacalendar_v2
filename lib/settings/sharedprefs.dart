import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs
{
    static const String _kUser = 'user';
    static const String _kAulas = 'aulas';
    static const String _kAvals = 'avals';

    static Future<SharedPreferences> _getInstance() async
    {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs;
    }

    static Future<String> _getString(key) async
    {
        final SharedPreferences prefs = await _getInstance();
        return prefs.getString(key);
    }

    static Future<bool> _setString(key,value) async
    {
        final SharedPreferences prefs = await _getInstance();
        return prefs.setString(key,value);
    }

    static Future<String> getUser()
    {
        return _getString(_kUser);
    }

    static Future<String> getAulas()
    {
        return  _getString(_kAulas);
    }

    static Future<String> getAvals()
    {
        return  _getString(_kAvals);
    }

    static setUser(value)
    {
        return _setString(_kUser, value);
    }

    static setAulas(value)
    {
        return _setString(_kAulas, value);
    }

    static setAvals(value)
    {
        return _setString(_kAvals, value);
    }
}