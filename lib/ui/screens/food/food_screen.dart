import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

import 'edit_food_details_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  _FoodScreenState createState() {
    return _FoodScreenState();
  }
}

class _FoodScreenState extends State {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        onChanged: (value) => print(value),
                        onSubmitted: (value) => print(value),
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
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return const ListTile(
                              leading: Icon(Icons.list),
                              trailing: Text(
                                'Favorit 1',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                              title: Text('Favorit 1'),
                            );
                          },
                        )),
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
                        onChanged: (value) => print(value),
                        onSubmitted: (value) => print(value),
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
                              builder: (context) =>
                                  const EditFoodDetailsScreen())),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return const ListTile(
                            leading: Icon(Icons.list),
                            trailing: Text(
                              'Lebensmittel 1',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            title: Text('Lebensmittel 1'),
                          );
                        },
                      )),
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
