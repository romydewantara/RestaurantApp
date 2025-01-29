import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ActionRobot {
  final WidgetTester tester;

  const ActionRobot(this.tester);

  final sliverAppBarKey = const ValueKey("sliverAppBar");
  final restaurantCardKey = const ValueKey("restaurantCard");
  final detailScreenKey = const ValueKey("detailScreen");
  final favoriteButtonKey = const ValueKey("favoriteButton");
  final backButtonKey = const ValueKey("backButton");
  final favoriteNavBarItemKey = const ValueKey("favoriteNavBarItem");
  final favoriteScreenKey = const ValueKey("favoriteScreen");
  final textRestaurantNameKey = const ValueKey("textRestaurantName");
  final tapKey = const ValueKey("tap");

  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(widget);
  }

  Future<void> observeWidgetSliverAppBar(Matcher sliverAppBar) async {
    final resultWidget = find.byKey(sliverAppBarKey);
    expect(resultWidget, sliverAppBar);
  }

  Future<void> tapFirstRestaurantCard() async {
    final firstRestaurantCardFinder = find.byKey(restaurantCardKey).first;
    await tester.tap(firstRestaurantCardFinder);
    await tester.pumpAndSettle();
  }

  Future<void> checkResultScreen(Matcher screen) async {
    final resultFinder = find.byKey(detailScreenKey);
    expect(resultFinder, screen);
  }

  Future<void> tapFavoriteButton() async {
    final favoriteButtonFinder = find.byKey(favoriteButtonKey);
    await tester.tap(favoriteButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapBackButton() async {
    final backButtonFinder = find.byKey(backButtonKey);
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapFavoriteNavBar() async {
    final favoriteNavBarItemFinder = find.byKey(favoriteNavBarItemKey);
    await tester.tap(favoriteNavBarItemFinder);
    await tester.pumpAndSettle();
  }

  Future<void> checkFavoriteScreen(Matcher screen) async {
    final resultFinder = find.byKey(favoriteScreenKey);
    expect(resultFinder, screen);
  }

  Future<void> checkTextRestaurantName(String text) async {
    final restaurantNameFinder = find.byKey(textRestaurantNameKey);

    expect(restaurantNameFinder, findsOneWidget);

    final Text restaurantNameWidget = tester.widget<Text>(restaurantNameFinder);
    expect(restaurantNameWidget.data, text); // final result is 'Melting Pot'
  }

}