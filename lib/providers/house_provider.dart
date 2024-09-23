import 'package:dtt_assessment/models/house_model.dart';
import 'package:dtt_assessment/user_repository/house_repository.dart';
import 'package:flutter/material.dart';

class HouseProvider with ChangeNotifier {
  final HouseRepository houseRepository;

  HouseProvider({required this.houseRepository});

  List<HouseModel> _houses = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = "";

  int? _minBedrooms;
  int? _maxBedrooms;

  int? _minBathRooms;
  int? _maxBathRooms;

  int? _minPrice;
  int? _maxPrice;

  List<HouseModel> get houses {
    List<HouseModel> reasonList = [];

    if (_searchQuery.isEmpty) {
      reasonList = List.from(_houses);
    } else {
      reasonList = List.from(_houses
          .where((house) =>
              (house.zip!.toLowerCase()).contains(_searchQuery.toLowerCase()) ||
              (house.city!.toLowerCase()).contains(_searchQuery.toLowerCase()))
          .toSet()
          .toList());
    }

    if (_minBathRooms != null) {
      reasonList.removeWhere((house) => (house.bathrooms! < _minBathRooms!));
    }

    if (_maxBathRooms != null) {
      reasonList.removeWhere((house) => house.bathrooms! > _maxBathRooms!);
    }

    if (_minBedrooms != null) {
      reasonList.removeWhere((house) => (house.bedrooms! < _minBedrooms!));
    }

    if (_maxBedrooms != null) {
      reasonList.removeWhere((house) => house.bedrooms! > _maxBedrooms!);
    }

    if (_minPrice != null) {
      reasonList.removeWhere((house) => (house.price! < _minPrice!));
    }

    if (_maxPrice != null) {
      reasonList.removeWhere((house) => house.price! > _maxPrice!);
    }

    return reasonList;
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  int? get minBathrooms => _minBathRooms;
  int? get maxBathrooms => _maxBathRooms;
  int? get minBedRooms => _minBedrooms;
  int? get maxBedrooms => _maxBedrooms;
  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;

  bool get filterIsActive =>
      _minBathRooms != null ||
      _maxBathRooms != null ||
      _minBedrooms != null ||
      _maxBedrooms != null ||
      _minPrice != null ||
      _maxPrice != null;

  Future<void> fetchHouses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _houses = await houseRepository.fetchHouses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters(
      {int? minBath,
      int? maxBath,
      int? minBed,
      int? maxBed,
      int? minPrice,
      int? maxPrice}) {
    _minBathRooms = minBath;
    _maxBathRooms = maxBath;
    _minBedrooms = minBed;
    _maxBedrooms = maxBed;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void sortByPriceASC() {
    _houses.sort((a, b) => a.price!.compareTo(b.price!));
    notifyListeners();
  }

  void sortByPriceDSC() {
    _houses.sort((b, a) => a.price!.compareTo(b.price!));
    notifyListeners();
  }

  void sortByCity() {
    _houses.sort((a, b) => a.city!.compareTo(b.city!));
  }
}
