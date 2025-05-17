import 'package:excerbuys/store/controllers/dashboard/history_controller/history_controller.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final TextTheme texts = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;
    return StreamBuilder<int>(
        stream: historyController.daysAgoCalendarStream,
        builder: (context, snapshot) {
          final data = snapshot.hasData ? snapshot.data! : 0;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: HORIZOTAL_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      getDayMonth(data),
                      style: texts.headlineLarge
                          ?.copyWith(color: colors.secondary),
                    ),
                    SizedBox(width: 8),
                    Text(
                      getDayYear(data),
                      style: texts.headlineLarge
                          ?.copyWith(color: colors.tertiaryContainer),
                    )
                  ],
                ),
                Text(
                  '${getDayName(data)}, ${getDayNumber(data)} ${getDayMonth(data)} ${getDayYear(data)}',
                  textAlign: TextAlign.left,
                  style: texts.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: colors.tertiaryContainer),
                ),
                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      return calendarDayCard(() {
                        historyController.setDaysAgoCalendar(6 - index);
                      },
                          getDayNumber(6 - index),
                          getDayName(6 - index).substring(0, 3).toUpperCase(),
                          colors,
                          texts,
                          6 - index == 0,
                          data == 6 - index);
                    }))
              ],
            ),
          );
        });
  }
}

Widget calendarDayCard(void Function() onPressed, String day, String dayAbbr,
    ColorScheme colors, TextTheme texts, bool? isToday, bool? isActive) {
  final Color textColor = isActive == true
      ? colors.primary
      : isToday == true
          ? colors.secondary
          : colors.tertiaryContainer;
  return Expanded(
    child: RippleWrapper(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 2),
        height: 55,
        decoration: BoxDecoration(
            color:
                isActive == true ? colors.secondary : colors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isToday == true ? colors.secondary : Colors.transparent,
                width: 2)),
        child: Column(
          children: [
            Text(
              dayAbbr,
              style: TextStyle(
                  fontSize: 10, color: textColor, fontWeight: FontWeight.w500),
            ),
            Text(
              day,
              style: texts.headlineLarge?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    ),
  );
}

// final Widget calendarDayCard = Builder(builder: (BuildContext context) {
//   final colors = Theme.of(context).colorScheme;
//   final texts = Theme.of(context).textTheme;

//   return Container(
//     height: 60,
//     width: 60,
//     decoration: BoxDecoration(
//         color: colors.primaryContainer,
//         borderRadius: BorderRadius.circular(10)),
//   );
// });
