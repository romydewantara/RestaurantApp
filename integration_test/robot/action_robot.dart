import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ActionRobot {
  final WidgetTester tester;

  const ActionRobot(this.tester);

  final sliverAppBarKey = const ValueKey("sliverAppBar");
  final restaurantCardKey = const ValueKey("restaurantCard");
  final detailScreenKey = const ValueKey("detailScreen");
  final favoriteButtonKey = const ValueKey("favoriteButton");
  final tapKey = const ValueKey("tap");

  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(widget);
  }

  Future<void> observeWidgetSliverAppBar(Matcher sliverAppBar) async {
    final resultWidget = find.byKey(sliverAppBarKey);
    debugPrint('sliverAppBar: $resultWidget');
    expect(resultWidget, sliverAppBar);
  }

  Future<void> tapFirstRestaurantCard() async {
    final firstRestaurantCardFinder = find.byKey(restaurantCardKey).first;
    debugPrint('firstRestaurant: $firstRestaurantCardFinder');
    await tester.tap(firstRestaurantCardFinder);
  }

  Future<void> checkResultScreen(Matcher screen) async {
    final resultFinder = find.byKey(detailScreenKey);
    debugPrint('resultFinder: $resultFinder | res: $screen');
    expect(resultFinder, screen);
  }

  Future<void> tapFavoriteButton() async {
    final favoriteButtonFinder = find.byKey(favoriteButtonKey);
    debugPrint('favButton: $favoriteButtonFinder');
    await tester.tap(favoriteButtonFinder);
  }

}