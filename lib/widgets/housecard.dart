import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/constants/extensions.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/models/house_model.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/screens/house_info_screen.dart';
import 'package:dtt_assessment/widgets/widget_animator.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HouseCard extends StatefulWidget {
  const HouseCard({super.key, required this.house});
  final HouseModel house;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  @override
  Widget build(BuildContext context) {
    var applicationProvider = Provider.of<ApplicationProvider>(context);

    // WidgetAnimator is a cool widget that makes its child fade in and out
    return WidgetAnimator(
      child: GestureDetector(
        onTap: () {
          Constants.push(context, HouseInfoScreen(house: widget.house));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            // IntrinsicHeight, so I can add a spacer in the column
            // This will make sure the row won't grow with the infinite height of the column
            // I know it's expensive but I had to use it in this case
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // I'm a hero ;)
                  Hero(
                    tag: "housetag:${widget.house.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        "${Constants.BASEURL}${widget.house.image}",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.house.price ?? 0).toDollarString(),
                          style: TextStyles.header_01,
                        ),
                        Text(
                          '${widget.house.zip} ${widget.house.city}',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const Spacer(),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      "${const Distance().as(LengthUnit.Kilometer, LatLng(applicationProvider.location!.latitude!, applicationProvider.location!.longitude!), LatLng(widget.house.latitude!.toDouble(), widget.house.longitude!.toDouble()))} Km"),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
          color: (isDarkMode) ? Colors.white60 : CustomColors.medium,
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyles.detail.copyWith(
              color: (isDarkMode) ? Colors.white60 : CustomColors.medium,
              overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}
