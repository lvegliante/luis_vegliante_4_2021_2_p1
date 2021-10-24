import 'dart:convert';
import 'package:flutter_nautas_app/Models/psychonauts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_nautas_app/models/response.dart';
import 'constans.dart';


class ApiHelper {
  static Future<Response>  getPsychonaute()async {
     var url = Uri.parse(Constans.apiUrl);
    var response = await http.get(
      url,
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Psychonaut> list = [];    
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Psychonaut.fromJson(item));
      }
    }
  return Response(isSuccess: true, result: list);
  }



}