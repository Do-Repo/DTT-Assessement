import 'package:dtt_assessment/blocs/theme_bloc.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/events/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeBloc = Provider.of<ThemeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS", style: TextStyles.header_01),
      ),
      body: Column(
        children: [
          SwitchListTile(
              title: Text(
                "Dark mode",
                style: TextStyles.header_02,
              ),
              value: themeBloc.isDarkMode,
              onChanged: (v) {
                context.read<ThemeBloc>().add(ToggleDarkMode());
              }),
        ],
      ),
    );
  }
}
