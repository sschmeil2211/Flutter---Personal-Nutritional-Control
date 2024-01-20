// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';


class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {

  bool loading = false;

  Future<void> signOut(UserProvider userProvider) async {
    setState(() => loading = true);
    String? message = await userProvider.signOut();
    if(!context.mounted) return;
    if(message == null)
      Navigator.pushNamedAndRemoveUntil(context, 'signScreen', (route) => false);
    else{
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(message, Colors.deepOrange));
    }
  }

  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      children: [
        ProfileCard(
          icon: Icons.person,
          label: 'User Information',
          onTap: () => Navigator.pushNamed(context, 'informationScreen', arguments: 0),
        ),
        ProfileCard(
          icon: Icons.scale,
          label: 'Body Information',
          onTap: () => Navigator.pushNamed(context, 'informationScreen', arguments: 1)
        ),
        ProfileCard(
          icon: Icons.calculate_outlined,
          label: 'Target Calories',
          onTap: () => Navigator.pushNamed(context, 'targetCaloriesScreen'),
        ),
        signOutWidget(userProvider)
      ],
    );
  }

  Widget signOutWidget(UserProvider userProvider) => loading
      ? const CircularProgressIndicator()
      : ProfileCard(
          icon: Icons.logout,
          label: 'Sign Out',
          onTap: () async => await signOut(userProvider),
        );
}

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;

  const ProfileCard({
    required this.onTap,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
          onTap: this.onTap,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Icon(this.icon),
                ),
                Text(
                  this.label,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
      ),
    );
  }
}