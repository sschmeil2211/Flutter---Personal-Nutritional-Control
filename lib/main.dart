import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_nutrition_control/providers/DayProvider.dart';
import 'package:personal_nutrition_control/providers/FoodProvider.dart';
import 'package:personal_nutrition_control/providers/SplashScreenProvider.dart';
import 'package:personal_nutrition_control/providers/UserProvider.dart';
import 'package:personal_nutrition_control/screens/CalendarScreen.dart';
import 'package:personal_nutrition_control/screens/FoodListScreen.dart';
import 'package:personal_nutrition_control/screens/HomeScreen.dart';
import 'package:personal_nutrition_control/screens/OnBoardingScreen.dart';
import 'package:personal_nutrition_control/screens/SignScreen.dart';
import 'package:personal_nutrition_control/screens/SplashScreen.dart';

import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => DayProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: ThemeMode.dark,
            initialRoute: 'splashScreen',
            routes: {
              'splashScreen': (_) => const SplashScreen(),
              'calendarScreen': (_) => const CalendarScreen(),
              'signScreen': (_) => const SignScreen(),
              'foodListScreen': (_) => const FoodListScreen(),
              'onBoardingScreen': (_) => const OnBoardingScreen(),
              'homeScreen': (_) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}