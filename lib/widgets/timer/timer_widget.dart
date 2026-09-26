import 'package:bookish_module/widgets/timer/time_widget_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<TimeWidgetProvider>(context);
    return Container(
      child: Consumer<TimeWidgetProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Text("Count: ${provider.currentTime}"),
              Row(
                children: [
                  Text("${DateTime.now().hour} : "),
                  Text("${DateTime.now().minute} : "),
                  Text("${DateTime.now().second} : ")
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    provider.setCurrentTime(DateTime.now().toString());
                  },
                  child: Text("Add"))
            ],
          );
        },
      ),
    );
  }
}
