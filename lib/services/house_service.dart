import 'dart:convert';
import 'dart:io';

import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/models/house_model.dart';
import 'package:http/http.dart' as http;

class HouseService {
  Future<List<HouseModel>> fetchHouses() async {
    final response =
        await http.get(Uri.parse("${Constants.BASEURL}/api/house"), headers: {
      "content-type": "application/json",
      'Access-Key': '98bww4ezuzfePCYFxJEWyszbUXc7dxRx'
    });

    if (response.statusCode == HttpStatus.ok) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((house) => HouseModel.fromMap(house)).toList();
    } else {
      throw Exception("Failed to load houses");
    }
  }
}
