import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/providers/house_provider.dart';
import 'package:dtt_assessment/screens/bookmarks_screen.dart';
import 'package:dtt_assessment/widgets/housecard.dart';
import 'package:dtt_assessment/widgets/housecard_loading.dart';
import 'package:dtt_assessment/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with AutomaticKeepAliveClientMixin {
  late HouseProvider houseProvider;
  final searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      houseProvider = Provider.of<HouseProvider>(context, listen: false);
      houseProvider.fetchHouses();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var applicationProvider = Provider.of<ApplicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("DTT REAL ESTATE", style: TextStyles.header_01),
        actions: [
          if (applicationProvider.bookMark.isNotEmpty)
            Badge.count(
                count: applicationProvider.bookMark.length,
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
        child: Consumer<HouseProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            // Loading screen:
            // Just some cards with the same layout as the real cards and a smooth shimmer
            return SingleChildScrollView(
              child: Column(
                children:
                    List.generate(10, (context) => const HousecardLoading()),
              ),
            );
          } else if (provider.errorMessage != null) {
            // Error screen:
            // For now its just showing the error, with a try again button to... try again :)
            // TODO: Make it look better?
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage.toString()),
                  TextButton(
                      onPressed: () {
                        houseProvider.fetchHouses();
                      },
                      child: const Text("Try again!"))
                ],
              ),
            );
          } else {
            // The homescreen:
            return RefreshIndicator(
              onRefresh: () async {
                // A slight delay looks a lot better :)
                return Future.delayed(Durations.medium4).whenComplete(() {
                  houseProvider.fetchHouses();
                });
              },
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                      floating: true,
                      delegate: SearchBarDelegate(
                          searchController: searchController)),
                  if (provider.houses.isNotEmpty)
                    SliverList.separated(
                      itemCount: provider.houses.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return HouseCard(house: provider.houses[index]);
                      },
                    ),
                  // No results found screen:
                  if (provider.houses.isEmpty)
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
          }
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
