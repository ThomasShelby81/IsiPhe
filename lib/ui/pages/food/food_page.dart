import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:isiphe/ui/pages/food/widget/food_list_tile.dart';

import '../../../business/bloc/food/bloc/food_bloc.dart';
import '../../../data/repository/food_repository.dart';
import '../food_details/food_edit_details_page.dart';

class FoodPage extends StatefulWidget {
  final FoodRepository foodRepository;

  const FoodPage({Key? key, required this.foodRepository}) : super(key: key);

  @override
  _FoodPageState createState() {
    return _FoodPageState();
  }
}

class _FoodPageState extends State<FoodPage> {
  late FoodBloc _foodBloc;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(onSucheChanged);

    _foodBloc = FoodBloc(widget.foodRepository)..add(const FoodInitial());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _foodBloc,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 35),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[300],
              elevation: 0,
              title: const Text('Meine Lebensmittel'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(),
              ),
              bottom: TabBar(
                  indicatorColor: Colors.green,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.greenAccent),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.star),
                    ),
                    Tab(
                      child: Icon(Icons.recent_actors),
                    ),
                    Tab(
                      child: Icon(Icons.dashboard_customize),
                    )
                  ]),
            ),
            body: SizedBox(
              height: 500,
              child: TabBarView(children: [
                Tab(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CupertinoSearchTextField(
                          placeholder: 'Suche',
                          controller: _controller,
                          autocorrect: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: const [
                            Icon(Icons.add_circle_outline),
                            Text('Neuer Favorit')
                          ],
                        ),
                      ),
                      BlocBuilder<FoodBloc, FoodState>(
                        builder: (context, state) {
                          return Padding(
                              padding: const EdgeInsets.all(20),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: state.favoriteFoods.length,
                                itemBuilder: (context, index) {
                                  return FoodListTile(
                                      state.favoriteFoods[index],
                                      (foodType) => _foodBloc.add(
                                          FoodSwitchFavoriteEvent(foodType)),
                                      (foodType) => _foodBloc
                                          .add(FoodDeleteEvent(foodType)));
                                },
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(children: const [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.history_rounded,
                        color: Colors.greenAccent,
                        size: 200,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                            'Diese Liste beinhaltet Lebensmittel, die oft verzehrt werden. Diese wächst automatisch mit der fortlaufenden Verwendung.',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  ]),
                ),
                Tab(
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: CupertinoSearchTextField(
                          placeholder: 'Suche',
                          controller: _controller,
                          autocorrect: true,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.add_circle_outline),
                            ),
                            Text('Neues Lebensmittel')
                          ],
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodEditDetailsPage(
                                      foodRepository: widget.foodRepository,
                                    ))).then((value) {
                          if (value != null && value) {
                            _foodBloc.add(const FoodInitial());
                          }
                        }),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: BlocBuilder<FoodBloc, FoodState>(
                          builder: (context, state) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.foodsFiltered.length,
                              itemBuilder: (context, index) {
                                return FoodListTile(
                                  state.foodsFiltered[index],
                                  (foodType) => _foodBloc
                                      .add(FoodSwitchFavoriteEvent(foodType)),
                                  (foodType) =>
                                      _foodBloc.add(FoodDeleteEvent(foodType)),
                                );
                              },
                            );
                          },
                        )),
                  ]),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void onSucheChanged() {
    _foodBloc.add(FoodFilterByNameEvent(_controller.text));
  }
}
