import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class BodyOfSearchScreen extends StatelessWidget {
  final List<Restaurant> restaurantList;

  const BodyOfSearchScreen({super.key, required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final restaurant = restaurantList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 10.0,
                ),
                child: RestaurantCardWidget(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: restaurant.id,
                    );
                  },
                ),
              );
            },
            childCount: restaurantList.length,
          ),
        ),
      ],
    );
  }
}
