import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';

class DateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CalendarTimeline(
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateSelected: (date) {
          context.read<CurrentDateBloc>().add(DateSelected(date!));
        },
        leftMargin: 100,
        monthColor: Colors.blueGrey,
        dayColor: Colors.teal[200],
        activeDayColor: Colors.white,
        activeBackgroundDayColor: Colors.redAccent[100],
        dotsColor: const Color(0xFF333A47),
        locale: 'en_ISO',
      ),
    );
  }
}
