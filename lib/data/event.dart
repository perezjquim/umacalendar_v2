import "dart:core";

class Event
{
    String _title;
    String _prof;
    String _location;
    String _date;
    String _time;
    bool _isAula;

    static const int _DTSTART = 2;
    static const int _DTEND = 3;
    static const int _SUMMARY = 4;
    static const int _LOCATION = 5;

    Event(List<String> data, DateTime now)
    {
        _parseDateTime(data, now);
        if(_date != null) _parseInfo(data);
    }
    
    void _parseDateTime(List<String> data, DateTime now)
    {
        final DateTime dateStart = DateTime.parse(_getValue(data,_DTSTART));
        final DateTime dateEnd = DateTime.parse(_getValue(data,_DTEND));

        if(now.isBefore(dateEnd))
        {
            String day = dateStart.day.toString().padLeft(2, '0');
            String month = dateStart.month.toString().padLeft(2, '0');
            String year = dateStart.year.toString();

            _date = "$day/$month/$year";

            String hourStart = dateStart.hour.toString().padLeft(2, '0');
            String minStart = dateStart.minute.toString().padLeft(2, '0');
            String hourEnd = dateEnd.hour.toString().padLeft(2, '0');
            String minEnd = dateEnd.minute.toString().padLeft(2, '0');

            _time = "$hourStart:$minStart - $hourEnd:$minEnd";
        }
    }

    void _parseInfo(List<String> data)
    {
        String location = _getValue(data, _LOCATION);
        String summary = _getValue(data, _SUMMARY);

        List<String> info = location.split(" -> ");
        _location = info[0];

        List<String> extra = info[1].replaceAll(")","").split(" (");

        String tipo = extra[0];
        _prof = extra[1];

        _title = summary += " - " + tipo;

        _isAula = !summary.contains("Avaliação");
    }

    bool isValid()
    {
        return _date != null;
    }

    bool isAula()
    {
        return _isAula;
    }

    String _getValue(List<String> data, int position)
    {
        return data[position].split(":")[1];
    }

    String toString()
    {
        String s = '{"title":"$_title","prof":"$_prof","location":"$_location","date":"$_date","time":"$_time","isAula":"$_isAula"}';
        return s;
    }
}