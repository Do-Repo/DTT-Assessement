import 'package:dtt_assessment/blocs/bookmark_bloc.dart';
import 'package:dtt_assessment/blocs/house_bloc.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/widgets/housecard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var houseBloc = context.read<HouseBloc>();
    var bookmarkBloc = context.watch<BookmarkBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("BOOKMARKS", style: TextStyles.header_01),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return HouseCard(
                house: houseBloc.allHouses.firstWhere((house) =>
                    house.id == bookmarkBloc.bookmarkedHouses[index]));
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: bookmarkBloc.bookmarkedHouses.length),
    );
  }
}
