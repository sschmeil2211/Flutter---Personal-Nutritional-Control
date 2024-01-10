import 'package:rive/rive.dart';

class RiveModel {
  final String src, artBoard, stateMachineName;
  late SMIBool? status;

  RiveModel({
    required this.src,
    required this.artBoard,
    required this.stateMachineName,
    this.status,
  });

  set setStatus(SMIBool state) => status = state;
}

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> bottomNavItems = [
  Menu(
    title: "home",
    rive: RiveModel(
      src: "assets/rive_assets/icons.riv",
      artBoard: "HOME",
      stateMachineName: "HOME_interactivity"
    ),
  ),
  Menu(
    title: "home",
    rive: RiveModel(
      src: "assets/rive_assets/icons.riv",
      artBoard: "TIMER",
      stateMachineName: "TIMER_Interactivity"
    ),
  ),
  Menu(
    title: "foodList",
    rive: RiveModel(
      src: "assets/rive_assets/icons.riv",
      artBoard: "USER",
      stateMachineName: "USER_Interactivity"
    ),
  ),
];