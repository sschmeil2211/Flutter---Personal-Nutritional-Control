// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/utils/utils.dart';
import 'package:personal_nutrition_control/models/widgets_models.dart';

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

  Future<void> requestPermissions(UserProvider userProvider) async {
    bool signedWithGoogle = await userProvider.checkGoogleSignIn();
    if(!signedWithGoogle){
      if(!context.mounted) return;
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CustomModal(
          onPressed: () async {
            await userProvider.googleSign();
            await userProvider.grantPermissions();
            if(!context.mounted) return;
            Navigator.pop(context);
          },
        )
      );
    }
    else{
      await userProvider.checkPermissions();
      if(userProvider.permissionsGranted)
        await userProvider.revokePermissions();
      else
        await userProvider.grantPermissions();
      if(!context.mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProfileCardData> profileCards = ProfileCardData.bodyData(context);
    String label = userProvider.permissionsGranted ? 'Revoke' : 'Get';

    profileCards.add(ProfileCardData(iconData: FontAwesomeIcons.heart, label: '$label Health Permissions', function: () => requestPermissions(userProvider)));

    return Column(
      children: [
        Column(
          children: profileCards.map((card) => ProfileCard(
            icon: card.iconData,
            label: card.label,
            onTap: card.function
          )).toList(),
        ),
        loading ? const CircularProgressIndicator() : ProfileCard(
          icon: Icons.logout,
          label: 'Sign Out',
          onTap: () async => await signOut(userProvider),
        ),
      ],
    );
  }
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
                padding: const EdgeInsets.only(left: 20, right: 20),
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