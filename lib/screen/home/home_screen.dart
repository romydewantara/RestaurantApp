import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/body_of_home_screen.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch(value.resultState) {
            RestaurantListLoadingState() => Center(
              child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Lottie.asset("assets/loading.json")
              ),
            ),
            RestaurantListLoadedState(data: var restaurantList) =>
                BodyOfHomeScreen(restaurantList: restaurantList),
            RestaurantListErrorState(error: var message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}