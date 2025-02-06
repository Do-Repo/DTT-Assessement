import 'package:dtt_assessment/blocs/house_bloc.dart';
import 'package:dtt_assessment/blocs/theme_bloc.dart';
import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/constants/enums.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/events/house_event.dart';
import 'package:dtt_assessment/models/filter_model.dart';
import 'package:dtt_assessment/screens/map_screen.dart';
import 'package:dtt_assessment/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  SearchBarDelegate({this.onMapView});

  final bool? onMapView;
  final searchController = TextEditingController();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var isDarkMode = context.watch<ThemeBloc>().isDarkMode;
    var houseBloc = context.read<HouseBloc>();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: (onMapView ?? false) ? 15 : 0),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                if (onMapView ?? false) {
                  Navigator.pop(context);
                } else {
                  Constants.push(context, const MapScreen());
                }
              },
              child: Container(
                // Infinite height, as it's limited to the maxExtent, coupled with
                // AspectRatio widget it'll make a perfect square button.
                height: double.infinity,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color:
                        (isDarkMode) ? Colors.white24 : CustomColors.darkGray,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Icon((onMapView ?? false)
                        ? Icons.list_alt
                        : Icons.map_outlined)),
              ),
            ),
          ),
          Flexible(
            child: TextField(
              onChanged: (value) {
                houseBloc.add(SearchHouses(query: value));
              },
              style: TextStyles.input,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon((searchController.text.isEmpty)
                      ? CustomIcons.ic_search
                      : CustomIcons.ic_close),
                ),
                hintStyle: TextStyles.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    (isDarkMode) ? Colors.white24 : CustomColors.darkGray,
                hintText: 'Search for a home',
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => const FilterDialog());
              },
              child: Container(
                // Infinite height, as it's limited to the maxExtent, coupled with
                // AspectRatio widget it'll make a perfect square button.
                height: double.infinity,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    // Current filter different than empty Filtermodel, means filter is active
                    // thus the button is highlighted
                    border: (context.watch<HouseBloc>().currentFilters !=
                            FilterModel())
                        ? Border.all(width: 2, color: Colors.black)
                        : null,
                    color:
                        (isDarkMode) ? Colors.white24 : CustomColors.darkGray,
                    borderRadius: BorderRadius.circular(5)),
                child: const Center(child: Icon(Icons.filter_alt_outlined)),
              ),
            ),
          ),
          MenuAnchor(
              builder: (context, controller, child) => AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: Container(
                        // Infinite height, as it's limited to the maxExtent, coupled with
                        // AspectRatio widget it'll make a perfect square button.
                        height: double.infinity,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: (isDarkMode)
                                ? Colors.white24
                                : CustomColors.darkGray,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Icon(Icons.sort)),
                      ),
                    ),
                  ),
              menuChildren: [
                MenuItemButton(
                  onPressed: () => houseBloc
                      .add(SortHouses(sortOrder: SortOrder.sortByPriceASC)),
                  child: Text("Price Ascending", style: TextStyles.body),
                ),
                MenuItemButton(
                  onPressed: () => houseBloc
                      .add(SortHouses(sortOrder: SortOrder.sortByPriceDSC)),
                  child: Text("Price Descending", style: TextStyles.body),
                ),
                MenuItemButton(
                  onPressed: () => houseBloc
                      .add(SortHouses(sortOrder: SortOrder.sortByCity)),
                  child: Text("City", style: TextStyles.body),
                ),
              ])
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
