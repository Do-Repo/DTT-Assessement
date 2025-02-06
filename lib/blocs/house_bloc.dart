import 'package:dtt_assessment/constants/enums.dart';
import 'package:dtt_assessment/events/house_event.dart';
import 'package:dtt_assessment/models/filter_model.dart';
import 'package:dtt_assessment/models/house_model.dart';
import 'package:dtt_assessment/repositories/house_repository.dart';
import 'package:dtt_assessment/states/house_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final HouseRepository repository;
  List<HouseModel> allHouses = [];
  List<HouseModel> filteredHouses = [];
  SortOrder currentSortOrder = SortOrder.sortByPriceASC;
  FilterModel currentFilters = FilterModel();

  HouseBloc(this.repository) : super(HouseInitial()) {
    on<FetchHouses>(_onFetchHouses);
    on<SearchHouses>(_onSearchHouses);
    on<SortHouses>(_onSortHouses);
    on<FilterHouses>(_onFilterHouses);
  }

  Future<void> _onFetchHouses(
      FetchHouses event, Emitter<HouseState> emit) async {
    emit(HouseLoading());
    try {
      allHouses = filteredHouses = await repository.fetchHouses();
      _applySorting(filteredHouses);
      emit(HouseLoaded(houses: filteredHouses));
    } catch (error) {
      emit(HouseError(message: error.toString()));
    }
  }

  void _onSearchHouses(SearchHouses event, Emitter<HouseState> emit) {
    if (state is HouseLoaded) {
      if (event.query.isEmpty) {
        // If search query is empty, reset to all houses while maintaining sort
        filteredHouses = _applySorting(allHouses);
      } else {
        // Otherwise, filter houses based on search query and sort them
        filteredHouses = _applySorting(List<HouseModel>.from(allHouses
            .where((house) =>
                (house.zip!.toLowerCase())
                    .contains(event.query.toLowerCase()) ||
                (house.city!.toLowerCase()).contains(event.query.toLowerCase()))
            .toSet()
            .toList()));
      }

      emit(HouseLoaded(houses: filteredHouses));
    }
  }

  void _onSortHouses(SortHouses event, Emitter<HouseState> emit) {
    if (state is HouseLoaded) {
      currentSortOrder = event.sortOrder;
      filteredHouses = _applySorting(filteredHouses);
      emit(HouseLoaded(houses: filteredHouses));
    }
  }

  void _onFilterHouses(FilterHouses event, Emitter<HouseState> emit) {
    if (state is HouseLoaded) {
      currentFilters = event.filters;
      var filterResults = _applyFilters(List.from(filteredHouses));
      emit(HouseLoaded(houses: filterResults));
    }
  }

  List<HouseModel> _applySorting(List<HouseModel> houses) {
    List<HouseModel> sortedHouses = List.from(houses);

    switch (currentSortOrder) {
      case SortOrder.sortByCity:
        sortedHouses.sort((a, b) => a.city!.compareTo(b.city!));
        break;
      case SortOrder.sortByPriceDSC:
        sortedHouses.sort((b, a) => a.price!.compareTo(b.price!));
        break;
      default: // sortByPriceASC
        sortedHouses.sort((a, b) => a.price!.compareTo(b.price!));
        break;
    }

    return sortedHouses;
  }

  List<HouseModel> _applyFilters(List<HouseModel> houses) {
    if (currentFilters.minBathrooms != null) {
      houses.removeWhere(
          (house) => ((house.bathrooms ?? 1) < currentFilters.minBathrooms!));
    }

    if (currentFilters.maxBathrooms != null) {
      houses.removeWhere(
          (house) => (house.bathrooms ?? 1) > currentFilters.maxBathrooms!);
    }

    if (currentFilters.minBedrooms != null) {
      houses.removeWhere(
          (house) => (house.bedrooms ?? 1) < currentFilters.minBedrooms!);
    }

    if (currentFilters.maxBedrooms != null) {
      houses.removeWhere(
          (house) => ((house.bedrooms ?? 1) > currentFilters.maxBedrooms!));
    }

    if (currentFilters.minPrice != null) {
      houses.removeWhere(
          (house) => ((house.price ?? 1) < currentFilters.minPrice!));
    }

    if (currentFilters.maxPrice != null) {
      houses.removeWhere(
          (house) => ((house.price ?? 1)) > currentFilters.maxPrice!);
    }

    return houses;
  }
}
