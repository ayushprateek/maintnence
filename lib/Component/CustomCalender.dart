import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void customCalender(
    {required BuildContext context,
    required Function(DateTime dateTime) onDaySelected}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(26.0))),
          contentPadding: EdgeInsets.only(top: 10.0),

          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  onDaySelected: (DateTime dateTime, DateTime dateTime2) {
                    onDaySelected(dateTime);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ), //
        );
      });
}
