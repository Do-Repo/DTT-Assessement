import 'dart:convert';

import 'package:dtt_assessment/models/house_model.dart';
import 'package:dtt_assessment/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ApplicationProvider with ChangeNotifier {
  final _sharedPrefService = SharedPrefService();

  List<HouseModel> _bookMarks = [];
  bool _isDarkMode = false;
  LocationData? _locationData;

  static const String themeKey = 'isDarkMode';
  static const String bookMarkKey = 'bookMarkKey';

  List<HouseModel> get bookMark => _bookMarks;
  bool get isDarkMode => _isDarkMode;
  LocationData? get location => _locationData;

  ApplicationProvider() {
    _loadTheme();
    _loadbookMark();
    _loadLocation();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _sharedPrefService.getBool(themeKey);
    notifyListeners();
  }

  Future<void> _loadbookMark() async {
    _bookMarks = await _sharedPrefService.getString(bookMarkKey).then((value) {
      if (value != null) {
        var result = jsonDecode(value) as Iterable;
        return result.map((e) => HouseModel.fromJson(e)).toList();
      }

      return [];
    });
  }

  Future<void> _loadLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted ||
          permissionGranted != PermissionStatus.grantedLimited) {
        return;
      }
    }

    _locationData = await location.getLocation();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _sharedPrefService.setBool(themeKey, _isDarkMode);
    notifyListeners();
  }

  bool inList(HouseModel house) {
    return _bookMarks.where((h) => h.id == house.id).isNotEmpty;
  }

  void togglebookMark(HouseModel house) {
    if (inList(house)) {
      _bookMarks.removeWhere((h) => h.id == house.id);
    } else {
      _bookMarks.add(house);
    }

    _sharedPrefService.setString(bookMarkKey, jsonEncode(bookMark));
    notifyListeners();
  }
}
