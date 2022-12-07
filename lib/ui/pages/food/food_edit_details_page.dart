import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:isiphe/data/repository/food_repository.dart';
import 'package:isiphe/ui/pages/food/widget/food_edit_details_page_three.dart';
import 'package:isiphe/ui/pages/food/widget/food_edit_details_page_two.dart';
import 'package:isiphe/ui/pages/food/widget/food_edit_details_page_one_nutritional_values.dart';

import '../../../business/bloc/food_details_bloc/bloc/food_details_bloc.dart';
import '../../routes/widgets/dots_indicator.dart';
import '../../routes/widgets/gradient_button.dart';

class FoodEditDetailsPage extends StatefulWidget {
  final FoodRepository foodRepository;

  const FoodEditDetailsPage({Key? key, required this.foodRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsPageState();
  }
}

class _FoodEditDetailsPageState extends State<FoodEditDetailsPage> {
  static const _kDuration = Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  late FoodDetailsBloc _foodDetailsBloc;

  final List<Widget> _pages = <Widget>[
    const FoodEditDetailsPageOneNutritionalValues(),
    const FoodEditPageTwo(),
    const FoodEditDetailsPageThree()
  ];

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    _foodDetailsBloc = FoodDetailsBloc(widget.foodRepository);

    _pageController.addListener(() {
      if (_pageController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _foodDetailsBloc.add(FoodDetailsPreviousPage(_pageController.page));
      } else {
        _foodDetailsBloc.add(FoodDetailsNextPage(_pageController.page));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _foodDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: const Text('Neues Lebensmittel'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text('Speichern',
                    style: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(children: [
              BlocListener<FoodDetailsBloc, FoodDetailsState>(
                listener: (context, state) {
                  if (state.forceJumpToPage) {
                    _pageController.nextPage(
                        duration: _kDuration, curve: _kCurve);
                  }
                },
                child: PageView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  children: _pages,
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: Colors.grey[800]?.withOpacity(0.5),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: DotsIndicator(
                    _pageController,
                    _pages.length,
                    (value) {
                      _pageController.animateToPage(value,
                          duration: _kDuration, curve: _kCurve);
                    },
                  )),
                ),
              ),
              Positioned(
                bottom: 100.0,
                left: 120,
                height: 50,
                width: 170,
                child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
                  builder: (context, state) {
                    return GradientButton(
                        width: 160,
                        height: 45,
                        onPressed: () {
                          if (isLastPage()) {
                            _foodDetailsBloc.add(FoodDetailsSaved());
                            Navigator.of(context).pop();
                          } else {
                            _foodDetailsBloc
                                .add(const FoodDetailsButtonNextPressed());
                          }
                        },
                        text: isLastPage()
                            ? const Text('Speichern')
                            : const Text('Weiter'),
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ));
                  },
                ),
              )
            ])),
      ),
    );
  }

  bool isLastPage() => _pageController.page?.round() == (_pages.length - 1);
}
