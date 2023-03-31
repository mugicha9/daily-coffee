import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../app.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text('Timer')), TimerControlLayout()],
    );
  }
}

class TimerControlLayout extends StatefulWidget {
  const TimerControlLayout({super.key});

  @override
  State<TimerControlLayout> createState() => _TimerControlLayoutState();
}

class _TimerControlLayoutState extends State<TimerControlLayout> {
  late Duration displayTime;
  late Timer timer;
  TimerClock timerClock = const TimerClock(time: Duration.zero);

  void stopClock() {
    timer.cancel();
  }

  void resetClock() {
    setState(() {
      displayTime = Duration(seconds: 5);
      timerClock = TimerClock(time: Duration(seconds: 5));
      timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) => {
                if (displayTime.compareTo(Duration.zero) > 0)
                  {
                    displayTime -= const Duration(seconds: 1),
                    setState(() {
                      timerClock = TimerClock(time: displayTime);
                    })
                  }
                else
                  {timer.cancel()}
              });
    });
  }

  @override
  void initState() {
    displayTime = Duration.zero;
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
              if (displayTime.compareTo(Duration.zero) > 0)
                {
                  displayTime -= const Duration(seconds: 1),
                  setState(() {
                    timerClock = TimerClock(time: displayTime);
                  })
                }
              else
                {timer.cancel()}
            });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timerClock,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: stopClock, child: Text("Stop")),
            TextButton(onPressed: resetClock, child: Text("Reset"))
          ],
        )
      ],
    );
  }
}

class TimerClock extends StatelessWidget {
  final Duration time;
  const TimerClock({
    super.key,
    required this.time,
  });

  String getTimetextFromDuration() {
    return "${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          getTimetextFromDuration(),
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}
