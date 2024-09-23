import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/providers/house_provider.dart';
import 'package:dtt_assessment/screens/house_info_screen.dart';
import 'package:dtt_assessment/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.searchController});
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    var houseProvider = Provider.of<HouseProvider>(context).houses;

    return Scaffold(
      appBar: AppBar(title: Text("MAP VIEW", style: TextStyles.header_01)),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                  searchController: searchController, onMapView: true)),
          SliverFillRemaining(
            child: FlutterMap(
                options: MapOptions(
                    initialZoom: 8,
                    initialCenter: (houseProvider.isEmpty)
                        // No houses? Just go to Amsterdam :)
                        ? const LatLng(52.3676, 4.9041)
                        // Start at the first house in the list
                        : LatLng(houseProvider.first.latitude!.toDouble(),
                            houseProvider.first.longitude!.toDouble())),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(markers: [
                    // Every building gets its Marker on the map, have you tried clicking on it? :)
                    ...houseProvider.map((house) => Marker(
                        width: 50,
                        height: 50,
                        rotate: true,
                        point: LatLng(house.latitude!.toDouble(),
                            house.longitude!.toDouble()),
                        child: GestureDetector(
                          onTap: () {
                            Constants.push(
                                context, HouseInfoScreen(house: house));
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: CustomColors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              // See what I did here? ;)
                              child: Hero(
                                tag: "housetag:${house.id}",
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      "${Constants.BASEURL}${house.image}"),
                                ),
                              ),
                            ),
                          ),
                        )))
                  ])
                ]),
          )
        ],
      ),
    );
  }
}
