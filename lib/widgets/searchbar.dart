import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/providers/house_provider.dart';
import 'package:dtt_assessment/screens/map_screen.dart';
import 'package:dtt_assessment/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  SearchBarDelegate({required this.searchController, this.onMapView});
  final TextEditingController searchController;
  final bool? onMapView;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var houseProvider = context.read<HouseProvider>();
    var isDarkMode = context.watch<ApplicationProvider>().isDarkMode;

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
                  Constants.push(
                      context, MapScreen(searchController: searchController));
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
              controller: searchController,
              onChanged: (value) {
                houseProvider.setSearchQuery(value);
              },
              style: TextStyles.input,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      searchController.clear();
                      houseProvider.setSearchQuery('');
                    }
                  },
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
                    border: (context.watch<HouseProvider>().filterIsActive)
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
                  onPressed: () => houseProvider.sortByPriceASC(),
                  child: Text("Price Ascending", style: TextStyles.body),
                ),
                MenuItemButton(
                  onPressed: () => houseProvider.sortByPriceDSC(),
                  child: Text("Price Descending", style: TextStyles.body),
                ),
                MenuItemButton(
                  onPressed: () {},
                  child: Text("Nearest First", style: TextStyles.body),
                ),
                MenuItemButton(
                  onPressed: () => houseProvider.sortByCity(),
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
