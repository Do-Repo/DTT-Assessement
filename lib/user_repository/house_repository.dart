import 'package:dtt_assessment/models/house_model.dart';
import 'package:dtt_assessment/services/house_service.dart';

abstract class HouseRepository {
  Future<List<HouseModel>> fetchHouses();
}

class HouseRepositoryImpl implements HouseRepository {
  final HouseService houseService;

  HouseRepositoryImpl({required this.houseService});

  @override
  Future<List<HouseModel>> fetchHouses() async {
    return await houseService.fetchHouses();
  }
}
