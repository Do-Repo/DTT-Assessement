import 'package:dtt_assessment/blocs/bookmark_bloc.dart';
import 'package:dtt_assessment/blocs/house_bloc.dart';
import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/events/house_event.dart';
import 'package:dtt_assessment/screens/bookmarks_screen.dart';
import 'package:dtt_assessment/states/house_state.dart';
import 'package:dtt_assessment/widgets/housecard.dart';
import 'package:dtt_assessment/widgets/housecard_loading.dart';
import 'package:dtt_assessment/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with AutomaticKeepAliveClientMixin {
  final searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HouseBloc>().add(FetchHouses());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var bookmarkBloc = context.watch<BookmarkBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("DTT REAL ESTATE", style: TextStyles.header_01),
        actions: [
          if (bookmarkBloc.bookmarkedHouses.isNotEmpty)
            Badge.count(
                count: bookmarkBloc.bookmarkedHouses.length,
                offset: const Offset(-5, 5),
                child: IconButton(
                    onPressed: () {
                      Constants.push(context, const BookmarkScreen());
                    },
                    icon: const Icon(Icons.bookmark)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: BlocBuilder<HouseBloc, HouseState>(builder: (context, state) {
          if (state is HouseLoading) {
            // Loading screen:
            // Just some cards with the same layout as the real cards and a smooth shimmer
            return SingleChildScrollView(
              child: Column(
                children:
                    List.generate(10, (context) => const HousecardLoading()),
              ),
            );
          } else if (state is HouseLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                var houseBloc = context.read<HouseBloc>();
                // A slight delay looks a lot better :)
                return Future.delayed(Durations.medium4).whenComplete(() {
                  houseBloc.add(FetchHouses());
                });
              },
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                      floating: true, delegate: SearchBarDelegate()),
                  if (state.houses.isNotEmpty)
                    SliverList.separated(
                      itemCount: state.houses.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return HouseCard(house: state.houses[index]);
                      },
                    ),
                  // No results found screen:
                  if (state.houses.isEmpty)
                    SliverFillRemaining(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                              'assets/images/search_state_empty.png'),
                        ),
                        Text("No results found!", style: TextStyles.hint),
                        Text("Perhaps try another search?",
                            style: TextStyles.hint)
                      ],
                    ))
                ],
              ),
            );
          } else if (state is HouseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  TextButton(
                      onPressed: () {
                        context.read<HouseBloc>().add(FetchHouses());
                      },
                      child: const Text("Try again!"))
                ],
              ),
            );
          }

          // Should never happen really
          return Container();
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
