import 'dart:convert';

import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/events/bookmark_event.dart';
import 'package:dtt_assessment/services/shared_pref_service.dart';
import 'package:dtt_assessment/states/bookmark_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final _sharedPrefService = SharedPrefService();
  List<int> bookmarkedHouses = [];

  BookmarkBloc() : super(BookmarkInitial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onLoadBookmarks(
      LoadBookmarks event, Emitter<BookmarkState> emit) async {
    bookmarkedHouses = await _sharedPrefService
        .getString(Constants.BOOKMARK_KEY)
        .then((value) {
      if (value != null) {
        return (jsonDecode(value) as List<dynamic>)
            .map((e) => e as int)
            .toList();
      }
      return [];
    });

    emit(BookmarkLoaded([...bookmarkedHouses]));
  }

  Future<void> _onToggleBookmark(
      ToggleBookmark event, Emitter<BookmarkState> emit) async {
    if (bookmarkedHouses.contains(event.houseId)) {
      bookmarkedHouses.remove(event.houseId);
    } else {
      bookmarkedHouses.add(event.houseId);
    }

    await _sharedPrefService.setString(
        Constants.BOOKMARK_KEY, jsonEncode(bookmarkedHouses));

    emit(BookmarkLoaded([...bookmarkedHouses]));
  }
}
