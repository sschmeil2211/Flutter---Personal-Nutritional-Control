// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/screens/screens.dart';
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
        ChangeNotifierProvider(create: (_) => SplashScreenProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => DayProvider()),
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
              'creationUserLoadingScreen': (_) => const CreationUserLoadingScreen(),
              'targetCaloriesScreen': (_) => const TargetCaloriesScreen(),
              'informationScreen': (_) => const InformationScreen(),
              'calendarScreen': (_) => const CalendarScreen(),
              'foodListScreen': (_) => const FoodListScreen(),
              'recoveryPasswordScreen': (_) => const RecoveryPasswordScreen()
            },
          );
        },
      ),
    );
  }
}