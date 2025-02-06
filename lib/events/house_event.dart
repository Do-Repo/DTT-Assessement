import 'package:dtt_assessment/constants/enums.dart';
import 'package:dtt_assessment/models/filter_model.dart';
import 'package:equatable/equatable.dart';

abstract class HouseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHouses extends HouseEvent {}

class SearchHouses extends HouseEvent {
  final String query;

  SearchHouses({required this.query});

  @override
  List<Object> get props => [query];
}

class SortHouses extends HouseEvent {
  final SortOrder sortOrder;

  SortHouses({required this.sortOrder});

  @override
  List<Object> get props => [sortOrder];
}

class FilterHouses extends HouseEvent {
  final FilterModel filters;

  FilterHouses({required this.filters});

  @override
  List<Object> get props => [filters];
}
