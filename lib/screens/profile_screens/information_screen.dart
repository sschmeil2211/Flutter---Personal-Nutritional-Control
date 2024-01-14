// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/user_profile.dart';
import 'package:personal_nutrition_control/widgets/profile_widgets/information_view.dart';
import 'package:personal_nutrition_control/widgets/profile_widgets/profile_body.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final int args = ModalRoute.of( context )!.settings.arguments as int;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: Column(
            children: [
              const UserProfile(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) => args == 0
                        ? UserInformation(userProvider: userProvider)
                        : UserBody(userProvider: userProvider)
                ),
              )
            ],
          ),
        )
    );
  }
}