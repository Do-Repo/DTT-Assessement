import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/extensions.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/models/house_model.dart';
import 'package:flutter/material.dart';

class HouseScreenshot extends StatelessWidget {
  const HouseScreenshot({super.key, required this.house});
  final HouseModel house;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network("${Constants.BASEURL}/${house.image}",
                fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/banner/dtt_banner.png",
              width: 100,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black, Colors.transparent])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      house.price!.toDollarString(),
                      style: TextStyles.header_01.copyWith(color: Colors.white),
                    ),
                    Text(
                      '${house.zip} ${house.city}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
