import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'event.dart';

class EventService {
  static const _serviceUrl = 'https://www.hildegundisapp.de/';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Event> createEvent(Event event) async {
    try {
      String json = _toJson(event);
      final response = await http.post(_serviceUrl + "storedates",
          headers: _headers, body: json);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server exception');
      print(e);
      return null;
    }
  }


  Future<Event> deleteEvent(Event event) async {
    try {
      String json = _toJson(event);
      final response = await http.delete(
          _serviceUrl + "dateRemove/" + event.id.toString(),
          headers: _headers);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server exception');
      print(e);
      return null;
    }
  }

  Event _fromJson(String json) {
    Map<String, dynamic> map = JSON.decode(json);
    var event = new Event();
    event.title = map["name"];
    event.clothes = map["clothes"];
    event.timepoint = map["startdate"];
    event.location = map["location"];
    event.id = map["id"];
    return event;
  }

  String _toJson(Event event) {
    var mapData = new Map();
    mapData["name"] = event.title;
    mapData["location"] = event.location;
    mapData["clothes"] = event.clothes;
    mapData["startdate"] = event.timepoint.toString();
    mapData["id"] = event.id;
    String json = JSON.encode(mapData);
    return json;
  }
}
