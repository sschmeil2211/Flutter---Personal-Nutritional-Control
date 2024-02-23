// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:personal_nutrition_control/delegates/search_delegate.dart';
import 'package:provider/provider.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/providers/providers.dart';
import 'package:personal_nutrition_control/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context); 

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white24,
        onPressed: () => Navigator.pushNamed(context, 'foodListScreen'),
        child: const Icon(Icons.food_bank),
      ),
      body: SafeArea(
        child:  ListView(
          shrinkWrap: true,
          children: [
            const Header(),
            Column(
              children: [
                Consumer<DayProvider>(
                  builder: (context, dayProvider, child){
                    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
                    DayModel? actualDay = dayProvider.actualDay;
                    if(user == null || actualDay == null)
                      return Container();

                    DayModel? day = dayProvider.getSpecificDay(DateTime.now());
                    if(day == null)
                      return Container();

                    return FoodDashboard(dayToView: day);
                  }
                ),
                HealthIndicators(timeToTrack: DateTime.now())
              ],
            ),
            const AddTodayFood(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                height: 50,
                color: Colors.white24,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text("Record today's exercise"),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => ActivityName(activityProvider: activityProvider)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ActivityName extends StatefulWidget {
  const ActivityName({
    super.key,
    required this.activityProvider,
  });

  final ActivityProvider activityProvider;

  @override
  State<ActivityName> createState() => _ActivityNameState();
}

class _ActivityNameState extends State<ActivityName> {

  TextEditingController time = TextEditingController();
  ActivityModel? selectedActivity;

  @override
  Widget build(BuildContext context) {
    String buttonLabel = selectedActivity == null ? 'Select your activity' : selectedActivity!.activity.toUpperCase();
    int weight = Provider.of<UserProvider>(context, listen: false).user?.weight ?? 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: Colors.white10,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100, maxHeight: 100,
                minWidth: double.infinity, maxWidth: double.infinity
              ),
              child: InkWell(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          buttonLabel,
                          style: const TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                  ),
                  onTap: () async {
                    var activity = await showSearch(
                        context: context,
                        delegate: ActivitySearchDelegate(widget.activityProvider)
                    );
                    setState(() => selectedActivity = activity);
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      children: [
                        const Text(
                          'MET:\t\t',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          selectedActivity?.met.toString() ?? '0',
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      children: [
                        const Text(
                          'MIN:\t\t',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: 30, maxWidth: 30,
                              minHeight: 30, maxHeight: 30
                          ),
                          child: TextFormField(
                            controller: time,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            child: const Text('Save Activity'),
            onPressed: () async {
              HealthProvider healthProvider = Provider.of<HealthProvider>(context, listen: false);
              if(selectedActivity == null) return;
              double burnedCalories = selectedActivity!.met * 0.0175 * weight * int.parse(time.text);
              await healthProvider.getToday();
              if(healthProvider.today == null){
                await healthProvider.createHealth(DateTime.now(), burnedCalories.toInt());
                healthProvider.caloriesBurned = burnedCalories.toInt();
              }
              else{
                await healthProvider.updateHealth(DateTime.now(), healthProvider.today!.burnedCalories + burnedCalories.toInt());
                healthProvider.caloriesBurned = burnedCalories.toInt();
              }
              if(!context.mounted) return;
              Navigator.pop(context);
            }
          )
        ],
      ),
    );
  }
}

/// MET * 0.0175 * WEIGHT * T