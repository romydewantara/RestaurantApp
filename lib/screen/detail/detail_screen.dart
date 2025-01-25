import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:lottie/lottie.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<StatefulWidget> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => Center(
                child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Lottie.asset("assets/loading.json")),
              ),
            RestaurantDetailLoadedState(data: var restaurantDetail) =>
              BodyOfDetailScreenWidget(restaurantDetail: restaurantDetail),
            RestaurantDetailErrorState(error: var message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 60,
                        width: 60,
                        child: Column(
                          children: [
                            ClipRRect(
                              child: Image.network(
                                'https://raw.githubusercontent.com/romydewantara/Resources/refs/heads/main/images/Restaurant/error.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )),
                    const SizedBox.square(dimension: 10),
                    Text(message),
                  ],
                ),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
