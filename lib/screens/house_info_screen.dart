// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/widgets/house_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/constants/extensions.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/models/house_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HouseInfoScreen extends StatefulWidget {
  const HouseInfoScreen({super.key, required this.house});
  final HouseModel house;

  @override
  State<HouseInfoScreen> createState() => _HouseInfoScreenState();
}

class _HouseInfoScreenState extends State<HouseInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var applicationProvider = Provider.of<ApplicationProvider>(context);
    var location = LatLng(
        widget.house.latitude!.toDouble(), widget.house.longitude!.toDouble());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver appbar for that satisfying scroll effect!
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: const Size(0, 30),
              child: Container(),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await shareInformation(context, widget.house);
                  },
                  icon: const Icon(Icons.share)),
              IconButton(
                  onPressed: () {
                    context
                        .read<ApplicationProvider>()
                        .togglebookMark(widget.house);
                  },
                  icon: Icon(
                      context.watch<ApplicationProvider>().inList(widget.house)
                          ? Icons.bookmark_remove
                          : Icons.bookmark_add_outlined))
            ],
            expandedHeight: 300,
            pinned: true,
            foregroundColor: CustomColors.white,
            flexibleSpace: Hero(
              tag: "housetag:${widget.house.id}",
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Positioned fill is just short for bottom: 0, left: 0, right: 0, top: 0
                  Positioned.fill(
                    child: Image.network(
                      "${Constants.BASEURL}${widget.house.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned the small container with rounded corners on top,
                  // Did bottom: -1 because for some reason bottom: 0 leaves a tiny gap.
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  // Black gradient so the Appbar white buttons remain visible,
                  // even on a white background.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top,
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent])),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.house.price!.toDollarString(),
                              style: TextStyles.header_01,
                            ),
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  information(CustomIcons.ic_bed,
                                      widget.house.bedrooms.toString()),
                                  information(CustomIcons.ic_bath,
                                      widget.house.bathrooms.toString()),
                                  information(CustomIcons.ic_layers,
                                      widget.house.size.toString()),
                                  if (applicationProvider.location != null)
                                    information(CustomIcons.ic_location,
                                        "${const Distance().as(LengthUnit.Kilometer, LatLng(applicationProvider.location!.latitude!, applicationProvider.location!.longitude!), location)} Km"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("Description", style: TextStyles.header_01),
                      const SizedBox(height: 20),
                      Text(widget.house.description.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w300)),
                      const SizedBox(height: 20),
                      Text("Location", style: TextStyles.header_01),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 1,
                        child: FlutterMap(
                            options: MapOptions(
                                // Centers the map, on the house
                                initialCenter: location,
                                initialZoom: 15.2,
                                onTap: (p0, p1) async {
                                  // Initially i was going to use url launcher
                                  // And based on the platform use the appropriate url
                                  // But after doing some research, I found this package that has already done the work
                                  await MapsLauncher.launchCoordinates(
                                      location.latitude, location.longitude);
                                }),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(markers: [
                                Marker(
                                    rotate: true,
                                    point: location,
                                    height: 40,
                                    width: 40,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: CustomColors.red,
                                      size: 40,
                                    ),
                                    alignment: Alignment.center)
                              ])
                            ]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget information(IconData icon, String value) {
    var isDarkMode = context.watch<ApplicationProvider>().isDarkMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: (isDarkMode) ? Colors.white60 : CustomColors.medium,
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyles.detail.copyWith(
              color: (isDarkMode) ? Colors.white60 : CustomColors.medium),
        )
      ],
    );
  }

  Future<void> shareInformation(BuildContext context, HouseModel house) async {
    ScreenshotController controller = ScreenshotController();
    var messenger = ScaffoldMessenger.maybeOf(context);

    await controller
        .captureFromWidget(HouseScreenshot(house: house))
        .then((image) async {
      await Share.shareXFiles([
        XFile.fromData(image, mimeType: "image/png", name: "DTTHouse.png")
      ],
              text: "Checkout this house I found on DTT Realestate!",
              subject:
                  "A beautiful house I found on DTT Realestate in ${house.city}")
          .then((result) {
        if (result.status == ShareResultStatus.success) {
          messenger?.showSnackBar(
              const SnackBar(content: Text("Shared successfully!")));
        }
      });
    });
  }
}
