import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/widgets/widgets.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15, left: 30, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Searcher(),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            buttonMinWidth: 0,
            children: [
              MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.white24,
                  onPressed: () => Navigator.pushNamed(context, 'calendarScreen'),
                  child: const Icon(Icons.calendar_month, color: Colors.white, size: 22)
              ),
              MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.white24,
                  onPressed: () => Navigator.pushNamed(context, 'profileScreen'),
                  child: const Icon(Icons.person, color: Colors.white, size: 22)
              ),
            ],
          )
        ],
      ),
    );
  }
}
