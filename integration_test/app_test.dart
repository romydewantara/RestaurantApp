import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/setting.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/detail/read_more_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/review/restaurant_review_provider.dart';
import 'package:restaurant_app/provider/review/review_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app/service/restaurant_sqlite_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';

import 'robot/action_robot.dart';

class MockSharedPreferencesProvider extends Mock
    implements SharedPreferencesProvider {}

class MockApiService extends Mock implements ApiService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferencesProvider mockSharedPreferencesProvider;
  late MockApiService mockApiService;

  setUp(() {
    mockSharedPreferencesProvider = MockSharedPreferencesProvider();
    mockApiService = MockApiService();

    when(
      () => mockSharedPreferencesProvider.setting,
    ).thenReturn(Setting(isDarkMode: false, notificationEnable: false));

    when(
      () => mockSharedPreferencesProvider.getThemeMode(),
    ).thenReturn(ThemeMode.light);

    when(
      () => mockSharedPreferencesProvider.getSettingValue(),
    ).thenAnswer((_) async => Future.value());

    when(() => mockApiService.getRestaurantList()).thenAnswer(
      (_) async => RestaurantListResponse(
        error: false,
        message: 'success',
        count: 5,
        restaurants: <Restaurant>[
          Restaurant(
            id: "rqdv5juczeskfw1e867",
            name: "Melting Pot",
            description: "Lorem ipsum dolor sit amet...",
            pictureId: "14", // mock image id
            city: "Medan",
            rating: 4.2,
          ),
          Restaurant(
            id: "s1knt6za9kkfw1e867",
            name: "Kafe Kita",
            description:
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi...",
            pictureId: "25", // mock image id
            city: "Gorontalo",
            rating: 4,
          ),
          Restaurant(
            id: "w9pga3s2tubkfw1e867",
            name: "Bring Your Phone Cafe",
            description: "Quisque rutrum. Aenean imperdiet. Etiam ultricies...",
            pictureId: "03", // mock image id
            city: "Surabaya",
            rating: 4.2,
          ),
          Restaurant(
            id: "uewq1zg2zlskfw1e867",
            name: "Kafein",
            description: "Quisque rutrum. Aenean imperdiet. Etiam ultric...",
            pictureId: "15", // mock image id
            city: "Aceh",
            rating: 4.6,
          ),
          Restaurant(
            id: "ygewwl55ktckfw1e867",
            name: "Istana Emas",
            description: "Quisque rutrum. Aenean imperdiet. Etiam ult...",
            pictureId: "05", // mock image id
            city: "Balikpapan",
            rating: 4.5,
          ),
        ],
      ),
    );

    addTearDown(() {
      mockSharedPreferencesProvider.dispose();
    });
  });

  testWidgets(
    "Expected that the restaurant liked will appear on the Favorite list screen and ensure that the restaurant name is match.",
    (tester) async {
      String route = NavigationRoute.mainRoute.name;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SharedPreferencesProvider>.value(
              value: mockSharedPreferencesProvider,
            ),
            ChangeNotifierProvider(
              create: (context) => IndexNavProvider(),
              //child: const MyApp(),
            ),
            ChangeNotifierProvider<IndexNavProvider>(
              create: (context) => IndexNavProvider(),
            ),
            Provider(create: (context) => RestaurantSqliteService()),
            ChangeNotifierProvider(
              create: (context) => LocalDatabaseProvider(
                context.read<RestaurantSqliteService>(),
              ),
            ),
            Provider(create: (context) => ApiService()),
            ChangeNotifierProvider<RestaurantListProvider>(
              create: (context) => RestaurantListProvider(mockApiService),
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  RestaurantDetailProvider(context.read<ApiService>()),
            ),
            ChangeNotifierProvider(create: (context) => ReadMoreProvider()),
            ChangeNotifierProvider(
              create: (context) =>
                  RestaurantReviewProvider(context.read<ApiService>()),
            ),
            ChangeNotifierProvider(create: (context) => ReviewProvider()),
          ],
          child: MyApp(initialRoute: route),
        ),
      );

      // pump and wait until screen stable
      await tester.pumpAndSettle();

      // init ActionRobot
      final actionRobot = ActionRobot(tester);

      // Home Screen
      await actionRobot.observeWidgetSliverAppBar(findsOneWidget);
      await actionRobot.tapFirstRestaurantCard();

      // Detail Screen
      await actionRobot.checkResultScreen(findsOneWidget);
      await actionRobot.tapFavoriteButton();

      // Tap the back button
      await actionRobot.tapBackButton();

      // Tap favorite in Bottom Navigation Bar
      await actionRobot.tapFavoriteNavBar();

      // Check Favorite Screen
      await actionRobot.checkFavoriteScreen(findsOneWidget);

      // Tap first item of the dummy restaurant list
      await actionRobot.tapFirstRestaurantCard();

      // Check actual final restaurant name in widget is match with first item restaurant name in dummy list
      await actionRobot.checkTextRestaurantName("Melting Pot");
    },
  );
}
