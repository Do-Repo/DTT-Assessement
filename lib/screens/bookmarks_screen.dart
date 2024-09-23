import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/widgets/housecard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var applicationProvider = Provider.of<ApplicationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("BOOKMARKS", style: TextStyles.header_01),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return HouseCard(house: applicationProvider.bookMark[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: applicationProvider.bookMark.length),
    );
  }
}
