import 'dart:math';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class DotsIndicator extends AnimatedWidget {
  /// The PageController that this DotsIndicator is representing
  final PageController pageController;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  //  the increase in size of the selected dot
  static const double _kMaxZoom = 2.0;

  // the distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  const DotsIndicator(this.pageController, this.itemCount, this.onPageSelected,
      {Key? key, this.color = Colors.white})
      : super(key: key, listenable: pageController);

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(max(
        0.0,
        1.0 -
            ((pageController.page ?? pageController.initialPage) - index)
                .abs()));

    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: SizedBox(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (index) => _buildDot(index)),
    );
  }
}
