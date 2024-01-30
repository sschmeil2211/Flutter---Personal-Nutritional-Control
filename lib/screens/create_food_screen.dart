// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_this, sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/widgets/widgets.dart';

class CreateFoodScreen extends StatelessWidget {

  const CreateFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: const [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Create your food",
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18)
                ),
              ),
            ),
            CreationFoodForm()
          ]
        ),
      ),
    );
  }
}