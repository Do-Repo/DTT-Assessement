import 'dart:async';

import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/constants/custom_icons.dart';
import 'package:dtt_assessment/providers/application_provider.dart';
import 'package:dtt_assessment/providers/house_provider.dart';
import 'package:dtt_assessment/screens/home_screen.dart';
import 'package:dtt_assessment/screens/info_screen.dart';
import 'package:dtt_assessment/screens/settings_screen.dart';
import 'package:dtt_assessment/services/house_service.dart';
import 'package:dtt_assessment/services/shared_pref_service.dart';
import 'package:dtt_assessment/user_repository/house_repository.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService().init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ApplicationProvider>(
          create: (_) => ApplicationProvider()),
      ChangeNotifierProvider<HouseProvider>(
          create: (_) => HouseProvider(
              houseRepository:
                  HouseRepositoryImpl(houseService: HouseService())))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var applicationProvider = Provider.of<ApplicationProvider>(context);
    return MaterialApp(
        title: 'DTT Assessement',
        debugShowCheckedModeBanner: false,
        themeMode:
            applicationProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        home: const AppStructure());
  }
}

class AppStructure extends StatefulWidget {
  const AppStructure({super.key});

  @override
  State<AppStructure> createState() => _AppStructureState();
}

class _AppStructureState extends State<AppStructure>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final connectionChecker = InternetConnectionChecker();
  StreamSubscription<InternetConnectionStatus>? subscription;
  int currentIndex = 0;
  bool _firstTime = true;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentIndex = tabController.index;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

      subscription = connectionChecker.onStatusChange.listen(
        (InternetConnectionStatus status) {
          if (status == InternetConnectionStatus.connected) {
            // Firstime here checks if its the first time, usually upon startup
            // there is a successful internet connection and the user doesn't have to see this.
            // It is only relevant when the connection is retrieved after being lost.
            // Notice how I don't check for first time when connection is lost
            // Because then it is important for the user to know that there is no connection
            if (_firstTime) {
              _firstTime = false;
            } else {
              scaffoldMessenger?.showSnackBar(
                  const SnackBar(content: Text("Connected to the internet")));
            }
          } else {
            _firstTime = false;
            scaffoldMessenger?.showSnackBar(
                const SnackBar(content: Text("Not connected to the internet")));
          }
        },
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: tabController,
          children: const [Homescreen(), InfoScreen(), SettingsScreen()]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          tabController.animateTo(value);
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.ic_home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.ic_info), label: "info"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings")
        ],
      ),
    );
  }
}
