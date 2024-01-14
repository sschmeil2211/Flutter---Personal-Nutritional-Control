// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_nutrition_control/providers/controllers_provider.dart';
import 'package:personal_nutrition_control/providers/day_provider.dart';
import 'package:personal_nutrition_control/providers/food_provider.dart';
import 'package:personal_nutrition_control/providers/splash_screen_provider.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/screens/calendar_screen.dart';
import 'package:personal_nutrition_control/screens/food_list_screen.dart';
import 'package:personal_nutrition_control/screens/home_screen.dart';
import 'package:personal_nutrition_control/screens/onboarding/body_onboarding_screen.dart';
import 'package:personal_nutrition_control/screens/onboarding/personal_onboarding_screen.dart';
import 'package:personal_nutrition_control/screens/profile_screens/information_screen.dart';
import 'package:personal_nutrition_control/screens/profile_screens/profile_screen.dart';
import 'package:personal_nutrition_control/screens/sign_screen.dart';
import 'package:personal_nutrition_control/screens/splash_screen.dart';

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
        ChangeNotifierProvider(create: (_) => ControllersProvider()),
        ChangeNotifierProxyProvider<UserProvider, ControllersProvider>(
            create: ( context ) => ControllersProvider(),
            update: ( context, userProvider, controller ) {
              if(controller != null)
                return controller..setUserProvider(userProvider);
              else
                return ControllersProvider()..setUserProvider(userProvider);
            }
        ),
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
              'signScreen': (_) => const SignScreen(),
              'personalOnboardingScreen': (_) => const PersonalOnBoardingScreen(),
              'bodyOnboardingScreen': (_) => const BodyOnBoardingScreen(),
              'homeScreen': (_) => const HomeScreen(),
              'profileScreen': (_) => const ProfileScreen(),
              'informationScreen': (_) => const InformationScreen(),
              'calendarScreen': (_) => const CalendarScreen(),
              'foodListScreen': (_) => const FoodListScreen(),
            },
          );
        },
      ),
    );
  }
}