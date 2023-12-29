import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/models/MenuModel.dart';
import 'package:rive/rive.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {

  bool isSideBarOpen = false;
  Menu selectedBottomNav = bottomNavItems.first;

  late SMIBool isMenuOpenInput;
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> animation;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottomNav != menu)
      setState(() => selectedBottomNav = menu);
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() => setState(() {}));
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17203A).withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17203A).withOpacity(0.3),
            offset: const Offset(0, 20),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(bottomNavItems.length, (index) {
              Menu navBar = bottomNavItems[index];
              return BottomNavItem(
                navBar: navBar,
                onTap: () {
                  RiveUtils.changeSMIBoolState(navBar.rive.status!);
                  updateSelectedBtmNav(navBar);
                  Navigator.pushReplacementNamed(context, '${navBar.title}Screen');
                },
                riveOnInit: (artBoard) => navBar.rive.status = RiveUtils.getRiveInput(artBoard, stateMachineName: navBar.rive.stateMachineName),
                selectedNav: selectedBottomNav,
              );
            },
          ),
        ],
      ),
    );
  }
}


class RiveUtils {
  static SMIBool getRiveInput(Artboard artBoard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController
        .fromArtboard(artBoard, stateMachineName);
    artBoard.addController(controller!);
    return controller.findInput<bool>("active") as SMIBool;
  }

  static void changeSMIBoolState(SMIBool input) {
    input.change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () => input.change(false),
    );
  }
}

class BottomNavItem extends StatelessWidget {

  final Menu navBar;
  final VoidCallback onTap;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;

  const BottomNavItem({
    super.key,
    required this.navBar,
    required this.onTap,
    required this.riveOnInit,
    required this.selectedNav
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: selectedNav == navBar),
          SizedBox(
            height: 36,
            width: 36,
            child: Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,
              child: RiveAnimation.asset(
                navBar.rive.src,
                artboard: navBar.rive.artBoard,
                onInit: riveOnInit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {

  final bool isActive;

  const AnimatedBar({
    required this.isActive,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 2),
      duration: const Duration(milliseconds: 200),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: Color(0xFF81B4FF),
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}