import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/providers/user_provider.dart';
import 'package:personal_nutrition_control/utils/image_paths.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    String name = Provider.of<UserProvider>(context, listen: false).user?.username ?? 'User';

    return Column(
      children: [
        Image(
          image: const AssetImage(appLogo),//Deberia ser icono del user
          height: height * 0.2
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}
