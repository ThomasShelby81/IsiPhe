import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:isiphe/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:isiphe/blocs/currentdate_bloc/currentdate_bloc_bloc.dart';
import 'package:isiphe/widgets/meal.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  _Dashboard createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> with TickerProviderStateMixin {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var closeManually = false;
  var useAnimation = true;
  var isDialogOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56, 56);
  var childrenButtonSize = const Size(56, 56);
  var selectedFloatingActionButtonLocation =
      FloatingActionButtonLocation.centerDocked;
  var customDialRoot = false;
  final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();

    context.read<CurrentDateBloc>().add(DateInitial());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            }),
        title: const Text('Dashboard',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/disney/images/7/78/180px-A4cf53e959.png/revision/latest/scale-to-width-down/360?cb=20140828162139&path-prefix=de'),
            ),
            onPressed: () => debugPrint('pressed'),
          ),
          /**
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLoggedOut());
              })
               */
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
                builder: (context, state) {
                  return Text('Hello, ${widget.user.email}');
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(5),
              /**
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              */
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.only(left: 50),
                          child: const Icon(
                              Icons.keyboard_double_arrow_left_outlined)),
                      onTap: () {
                        context
                            .read<CurrentDateBloc>()
                            .add(DateDecrementedByOneDay());
                      },
                    ),
                    BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
                      builder: (context, state) {
                        var dateString = _dateFormat.format(state.date);
                        if (isCurrentDate(state.date)) {
                          dateString = 'Heute';
                        }

                        return Text(
                          dateString,
                          style: Theme.of(context).textTheme.headline1,
                        );
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.only(right: 50),
                          child: const Icon(
                              Icons.keyboard_double_arrow_right_outlined)),
                      onTap: () {
                        context
                            .read<CurrentDateBloc>()
                            .add(DateIncrementedByOneDay());
                      },
                    ),
                  ]),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: [
                    _buildLeftRow(),
                    _buildCentralWidget(),
                    _buildRightWidget()
                  ],
                )),
            Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(30),
              /**
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
               */
              child: BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
                builder: (context, state) {
                  return CalendarTimeline(
                    initialDate: state.date,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
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
                    selectableDayPredicate: (date) => date.day != 23,
                    locale: 'en_ISO',
                  );
                },
              ),
            )
          ],
        ),
      ),
      /**
      floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("pressed"),
          child: AnimatedIcon(
            icon: AnimatedIcons.add_event,
            progress: _animation,
          )),
      */
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialogOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        dialRoot: customDialRoot
            ? (ctx, open, toggleChildren) {
                return ElevatedButton(
                  onPressed: toggleChildren,
                  child: const Text(
                    "Custom Dial Root",
                    style: TextStyle(fontSize: 17),
                  ),
                );
              }
            : null,
        buttonSize: buttonSize,
        // it's the SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        label: extend ? const Text('Open') : null,
        // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        activeLabel: extend ? const Text('Close') : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: childrenButtonSize,
        visible: visible,
        direction: speedDialDirection,
        switchLabelPosition: switchLabelPosition,

        /// If true user is forced to close dial manually
        closeManually: closeManually,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: renderOverlay,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => debugPrint('Opening Dial'),
        onClose: () => debugPrint('Closing Dial'),
        useRotationAnimation: useAnimation,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        elevation: 8.0,
        isOpenOnStart: false,
        animationSpeed: 200,
        shape: customDialRoot
            ? const RoundedRectangleBorder()
            : const StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.breakfast_dining) : null,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Frühstück',
            onTap: () => setState(() => rmicons = !rmicons),
            onLongPress: () => debugPrint('Breakfast Child LONG PRESS'),
          ),
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.lunch_dining) : null,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Mittag',
            onTap: () => setState(() => rmicons = !rmicons),
            onLongPress: () => debugPrint('Lunch CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.dining) : null,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Abendessen',
            onTap: () => setState(() => rmicons = !rmicons),
            onLongPress: () => debugPrint('Dinner CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.add) : null,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Snack',
            onTap: () => setState(() => rmicons = !rmicons),
            onLongPress: () => debugPrint('Snack CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.qr_code) : null,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Scanner',
            onTap: () => setState(() => rmicons = !rmicons),
            onLongPress: () => debugPrint('Scanner CHILD LONG PRESS'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
      ]),
    );
  }

  bool isCurrentDate(DateTime date) {
    return date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;
  }

  _buildLeftRow() {
    return Positioned(
        left: 5,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          constraints: const BoxConstraints(
            maxWidth: 100,
          ),
          child: Text(
            'letzter\nWert',
            style: Theme.of(context).textTheme.headline1,
          ),
        ));
  }

  _buildCentralWidget() {
    return Positioned(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Phe Budget',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              '2.125',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SleekCircularSlider(
                min: 0,
                max: 100,
                initialValue: 50,
                appearance: CircularSliderAppearance(
                    spinnerMode: false,
                    size: 200,
                    angleRange: 360.0,
                    startAngle: 135,
                    animationEnabled: true,
                    customWidths: CustomSliderWidths(progressBarWidth: 10)),
                innerWidget: (double value) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 70),
                      Container(
                          child: Column(
                        children: [
                          Text(
                            NumberFormat.decimalPattern('de').format(value),
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 40),
                          ),
                          const Text(
                            'Phe übrig',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )),
                    ],
                  );
                },
              ),
            ),
          ]),
    );
  }

  _buildRightWidget() {
    return Positioned(
      right: 5,
      child: Container(
        /**decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: const BorderRadius.all(Radius.circular(10))),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Meal(name: 'Frühstück', phe: 0),
            Meal(name: 'Mittag', phe: 0),
            Meal(name: 'Abend', phe: 0),
            Meal(name: 'Snacks', phe: 0),
          ],
        ),
      ),
    );
  }
}
