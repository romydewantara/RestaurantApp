import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/review/restaurant_review_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/review/review_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => IndexNavProvider(),
              child: const MyApp()
          ),
          Provider(
            create: (context) => ApiService(),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchProvider(),
            child: SearchScreen(),
          ),
          ChangeNotifierProvider(
            create: (context) => RestaurantSearchProvider(
                context.read<ApiService>()
            ),
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
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RestaurantApp',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: ThemeMode.system,
        initialRoute: NavigationRoute.mainRoute.name,
        routes: {
          NavigationRoute.mainRoute.name: (context) => const MainScreen(),
          NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId: ModalRoute.of(context)?.settings.arguments as String
          ),
          NavigationRoute.reviewRoute.name: (context) => ReviewScreen(
            restaurantId: ModalRoute.of(context)?.settings.arguments as String
          )
        }
    );
  }
}
