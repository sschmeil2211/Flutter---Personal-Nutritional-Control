import 'package:flutter/material.dart';

import 'package:personal_nutrition_control/widgets/widgets.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15, left: 30, right: 15),//Todo: Esto no es correto
      child: Row(
        children: [
          const Searcher(),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            buttonMinWidth: 0,
            children: [
              iconButton(context, 'calendarScreen', Icons.calendar_month),
              iconButton(context, 'profileScreen', Icons.person),
            ],
          )
        ],
      ),
    );
  }

  Widget iconButton(BuildContext context, String route, IconData icon) => MaterialButton(
    shape: const CircleBorder(),
    color: Colors.white24,
    onPressed: () => Navigator.pushNamed(context, route),
    child: Icon(icon, color: Colors.white, size: 22)
  );
}
