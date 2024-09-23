import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var applicationProvider = Provider.of<ApplicationProvider>(context);
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
              value: applicationProvider.isDarkMode,
              onChanged: (v) {
                context.read<ApplicationProvider>().toggleTheme();
              }),
        ],
      ),
    );
  }
}
