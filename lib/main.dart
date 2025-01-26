import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';
import 'package:restaurant_app/provider/notification/notification_state_provider.dart';
import 'package:restaurant_app/provider/notification/payload_provider.dart';
import 'package:restaurant_app/provider/review/restaurant_review_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/search/search_provider.dart';
import 'package:restaurant_app/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/theme/theme_state_provider.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/review/review_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/service/http_service.dart';
import 'package:restaurant_app/service/local_notification_service.dart';
import 'package:restaurant_app/service/restaurant_sqlite_service.dart';
import 'package:restaurant_app/service/shared_preferences_service.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String route = NavigationRoute.mainRoute.name;
  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    route = NavigationRoute.mainRoute.name;
    payload = notificationResponse?.payload;
  }

  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => SharedPreferencesService(sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => SharedPreferencesProvider(
          context.read<SharedPreferencesService>(),
        ),
      ),
      Provider(
        create: (context) => HttpService(),
      ),
      Provider(
        create: (context) => LocalNotificationService(
          context.read<HttpService>(),
        )
          ..init()
          ..configureLocalTimeZone(),
      ),
      ChangeNotifierProvider(
        create: (context) => LocalNotificationProvider(
          context.read<LocalNotificationService>(),
        )..requestPermissions(),
      ),
      ChangeNotifierProvider(
        create: (context) => PayloadProvider(
          payload: payload,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => IndexNavProvider(),
        //child: const MyApp(),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationStateProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeStateProvider(),
      ),
      Provider(
        create: (context) => ApiService(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
        child: SearchScreen(),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            RestaurantSearchProvider(context.read<ApiService>()),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantListProvider(
          context.read<ApiService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantDetailProvider(
          context.read<ApiService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantReviewProvider(
          context.read<ApiService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ReviewProvider(),
      ),
      Provider(
        create: (context) => RestaurantSqliteService(),
      ),
      ChangeNotifierProvider(
        create: (context) => LocalDatabaseProvider(
          context.read<RestaurantSqliteService>(),
        ),
      ),
    ],
    child: MyApp(
      initialRoute: route,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final sharedPreferenceProvider =
    context.watch<SharedPreferencesProvider>();
    sharedPreferenceProvider.getSettingValue();

    return MaterialApp(
      title: 'RestaurantApp',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: sharedPreferenceProvider.getThemeMode(),
      initialRoute: initialRoute,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
            restaurantId: ModalRoute.of(context)?.settings.arguments as String
        ),
        NavigationRoute.reviewRoute.name: (context) => ReviewScreen(
            restaurantId: ModalRoute.of(context)?.settings.arguments as String
        ),
      },
    );
  }
}
