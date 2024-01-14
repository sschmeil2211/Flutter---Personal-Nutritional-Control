// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/widgets/common_widgets/user_profile.dart';
import 'package:personal_nutrition_control/widgets/profile_widgets/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: const Column(
          children: [
            UserProfile(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ProfileBody(),
            )
          ],
        ),
      )
    );
  }
}