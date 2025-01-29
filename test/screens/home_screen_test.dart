import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/home/body_of_home_screen.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class MockRestaurantListProvider extends Mock implements RestaurantListProvider {}

void main() {
  late MockRestaurantListProvider mockProvider;
  late Widget widget;

  setUp(() {
    mockProvider = MockRestaurantListProvider();

    widget = MaterialApp(
      home: ChangeNotifierProvider<RestaurantListProvider>(
        create: (context) => mockProvider,
        child: BodyOfHomeScreen(
          restaurantList: [
            Restaurant(
              id: "rqdv5juczeskfw1e867",
              name: "Melting Pot",
              description: "Lorem ipsum dolor sit amet...",
              pictureId: "14", // mock image id
              city: "Medan",
              rating: 4.2,
            )
          ],
        ),
      ),
    );
  });

  group('BodyOfHomeScreen widget tests', () {
    testWidgets(
      "displays SliverAppBar",
          (tester) async {

        // Act: Pump the widget into the widget tree
        await tester.pumpWidget(widget);

        final sliverAppBar = find.byType(SliverAppBar);

        // Assert: Verify key elements in BodyOfHomeScreen
        expect(sliverAppBar, findsOneWidget); // Check SliverAppBar
      },
    );

    // Happy Path
    testWidgets("displays restaurant card information correctly",
            (tester) async {
      // Act: Pump the widget into the widget tree
      await tester.pumpWidget(widget);

      // Assert: Verify that RestaurantCardWidget displays the correct information
      expect(find.text('Melting Pot'), findsOneWidget);
      expect(find.text('Medan'), findsOneWidget);
      expect(find.text('4.2'), findsOneWidget);
    });

    // Unhappy Path
    testWidgets("display error message when failed to fetch restaurants",
        (tester) async {
      when(() => mockProvider.fetchRestaurantList()).thenAnswer((_) async {});
      when(() => mockProvider.resultState).thenReturn(
        RestaurantListErrorState("Please check your internet connection."),
      );

      // Act: Pump the widget into the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantListProvider>(
            create: (context) => mockProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert: Verify the error message is displayed
      expect(
          find.text("Please check your internet connection."), findsOneWidget);
    });
  });
}
