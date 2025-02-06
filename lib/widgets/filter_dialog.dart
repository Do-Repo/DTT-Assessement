import 'package:dtt_assessment/blocs/house_bloc.dart';
import 'package:dtt_assessment/blocs/theme_bloc.dart';
import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/constants/extensions.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/events/house_event.dart';
import 'package:dtt_assessment/models/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late TextEditingController minBed;
  late TextEditingController maxBed;

  late TextEditingController minBath;
  late TextEditingController maxBath;

  late TextEditingController minPrice;
  late TextEditingController maxPrice;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var filter = context.read<HouseBloc>().currentFilters;
    minBed = TextEditingController(text: filter.minBedrooms.toNullableString());
    maxBed = TextEditingController(text: filter.maxBedrooms.toNullableString());
    minBath =
        TextEditingController(text: filter.minBathrooms.toNullableString());
    maxBath =
        TextEditingController(text: filter.maxBathrooms.toNullableString());
    minPrice = TextEditingController(text: filter.minPrice.toNullableString());
    maxPrice = TextEditingController(text: filter.maxPrice.toNullableString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var houseBloc = context.read<HouseBloc>();
    var isDarkMode = context.watch<ThemeBloc>().isDarkMode;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("FILTERS", style: TextStyles.header_01),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          // Empty filtermodel to clear filters
                          houseBloc.add(FilterHouses(filters: FilterModel()));
                          Navigator.pop(context);
                        },
                        child: Text("Clear", style: TextStyles.input))
                  ],
                ),
                const SizedBox(height: 10),
                filterSection("Bedrooms", CustomIcons.ic_bed),
                intTextfield("min", minBed),
                intTextfield(
                  "max",
                  maxBed,
                  validator: (value) {
                    if ((value ?? '').isNotEmpty && minBed.text.isNotEmpty) {
                      if ((int.tryParse(value!) ?? 0) <
                          (int.tryParse(minBed.text) ?? 0)) {
                        return "Minimum larger than maximum";
                      }
                    }

                    return null;
                  },
                ),
                filterSection("Bathrooms", CustomIcons.ic_bath),
                intTextfield("min", minBath),
                intTextfield(
                  "max",
                  maxBath,
                  validator: (value) {
                    if ((value ?? '').isNotEmpty && minBath.text.isNotEmpty) {
                      if ((int.tryParse(value!) ?? 0) <
                          (int.tryParse(minBath.text) ?? 0)) {
                        return "Minimum larger than maximum";
                      }
                    }

                    return null;
                  },
                ),
                filterSection("Price", Icons.attach_money),
                intTextfield("min", minPrice),
                intTextfield(
                  "max",
                  maxPrice,
                  validator: (value) {
                    if ((value ?? '').isNotEmpty && minPrice.text.isNotEmpty) {
                      if ((int.tryParse(value!) ?? 0) <
                          (int.tryParse(minPrice.text) ?? 0)) {
                        return "Minimum larger than maximum";
                      }
                    }

                    return null;
                  },
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyles.input.copyWith(
                              color: (isDarkMode)
                                  ? Colors.white54
                                  : CustomColors.medium,
                            ))),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            houseBloc.add(FilterHouses(
                                filters: FilterModel(
                                    minBedrooms: int.tryParse(minBed.text),
                                    maxBedrooms: int.tryParse(maxBed.text),
                                    minBathrooms: int.tryParse(minBath.text),
                                    maxBathrooms: int.tryParse(maxBath.text),
                                    minPrice: int.tryParse(minPrice.text),
                                    maxPrice: int.tryParse(maxPrice.text))));
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Apply", style: TextStyles.input))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget intTextfield(String suffix, TextEditingController controller,
      {FormFieldValidator<String>? validator}) {
    var isDarkMode = context.watch<ThemeBloc>().isDarkMode;
    return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: TextFormField(
          controller: controller,
          validator: validator,
          style: TextStyles.input,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            hintStyle: TextStyles.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: (isDarkMode) ? Colors.white24 : CustomColors.darkGray,
            hintText: '0',
            suffixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(suffix, style: TextStyles.hint),
            ),
          ),
        ));
  }

  Padding filterSection(String section, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(section, style: TextStyles.subtitle),
        ],
      ),
    );
  }
}
