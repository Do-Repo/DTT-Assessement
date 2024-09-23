import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HousecardLoading extends StatelessWidget {
  const HousecardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy card for the loading screen with some smooth shimmers.
    return Card(
      child: Shimmer.fromColors(
        baseColor: CustomColors.darkGray,
        highlightColor: CustomColors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15)),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
