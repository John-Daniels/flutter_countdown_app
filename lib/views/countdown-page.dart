import 'package:flutter/material.dart';
import '../widgets/round-button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CountdownPage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const CountdownPage({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inDays}:${controller.duration!.inHours % 24}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inDays}:${count.inHours % 24}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  List monthLengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  int differenciate(int start, int end, int startMonth, int endMonth) {
    if (startMonth == endMonth) {
      return end - start;
    } else {
      int dayOfTheMonth = monthLengths[startMonth - 1];
      int remainingDays = dayOfTheMonth - start;
      return remainingDays + end;
    }
  }

  showMyDateRangePicker() async {
    if (controller.isDismissed) {
      DateTimeRange? datetime = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          currentDate: DateTime.now());

      var start = datetime!.start;
      var end = datetime.end;

      controller.duration = Duration(
        days: differenciate(
          start.day,
          end.day,
          start.month,
          end.month,
        ),
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
      );

      setState(() {});
      // showModalBottomSheet(
      //   context: context,
      //   builder: (context) => Container(
      //     height: 300,
      //     child: CupertinoDatePicker(
      //       initialDateTime: DateTime.now(),
      //       onDateTimeChanged: (datetime) {
      //         controller.duration = Duration(
      //           days: datetime.day,
      //           hours: datetime.hour,
      //           minutes: datetime.minute,
      //           seconds: datetime.second,
      //         );
      //       },
      //       // initialTimerDuration: controller.duration,
      //       // onTimerDurationChanged: (time) {
      //       //   setState(() {
      //       //     controller.duration = time;
      //       //   });
      //       // },
      //     ),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('stop the timer to pick another date'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 10, hours: 10, seconds: 10),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff5fbff),
      appBar: AppBar(
        title: Text('Countdown App 🇳🇬🔥🔥'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.onThemeChanged();
            },
            icon: Icon(Icons.dark_mode),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    value: progress,
                    strokeWidth: 6,
                  ),
                ),
                GestureDetector(
                  onTap: showMyDateRangePicker,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Container(
                    width: 140,
                    child: TextButton(
                      onPressed: showMyDateRangePicker,
                      child: Row(
                        children: [
                          Icon(Icons.date_range),
                          SizedBox(
                            width: 5,
                          ),
                          Text('pick a date'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },
                  child: RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
