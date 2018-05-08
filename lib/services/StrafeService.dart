import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:hildegundis_app/models/strafe.dart';

class StrafeService {
  static const _serviceUrl = 'https://www.hildegundisapp.de/';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Strafe> createStrafe(Strafe strafe) async {
    try {
      String json = _toJson(strafe);
      final response = await http.post(_serviceUrl + "storeaccounting",
          headers: _headers, body: json);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server exception');
      print(e);
      return null;
    }
  }

  Future<Strafe> deleteStrafeList(List<Strafe> allStrafen) async {
    try {
      for (Strafe strafe in allStrafen) {
        String json = _toJson(strafe);
        final response = await http.delete(
            _serviceUrl + "deleteAccounting/" + strafe.id.toString(),
            headers: _headers);
      }
      return null;
    } catch (e) {
      print('Server exception');
      print(e);
      return null;
    }
  }

  Future<Strafe> deleteStrafe(Strafe strafe) async {
    try {
      String json = _toJson(strafe);
      final response = await http.delete(
          _serviceUrl + "deleteAccounting/" + strafe.id.toString(),
          headers: _headers);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server exception');
      print(e);
      return null;
    }
  }

  Strafe _fromJson(String json) {
    Map<String, dynamic> map = JSON.decode(json);
    var strafe = new Strafe();
    strafe.name = map["name"];
    strafe.betrag = map["betrag"];
    strafe.grund = map["grund"];
    strafe.date = map["date"];
    strafe.id = map["id"];
    return strafe;
  }

  String _toJson(Strafe strafe) {
    var mapData = new Map();
    mapData["name"] = strafe.name;
    mapData["grund"] = strafe.grund;
    mapData["betrag"] = strafe.betrag;
    mapData["date"] = strafe.date.toString();
    mapData["id"] = strafe.id;
    String json = JSON.encode(mapData);
    return json;
  }
}
