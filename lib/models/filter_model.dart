// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  int? minBedrooms;
  int? maxBedrooms;
  int? minBathrooms;
  int? maxBathrooms;
  int? minPrice;
  int? maxPrice;

  FilterModel({
    this.minBedrooms,
    this.maxBedrooms,
    this.minBathrooms,
    this.maxBathrooms,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [
        minBedrooms,
        maxBedrooms,
        minBathrooms,
        maxBathrooms,
        minPrice,
        maxPrice
      ];
}
