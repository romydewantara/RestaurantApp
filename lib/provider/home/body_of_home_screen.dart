import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class BodyOfHomeScreen extends StatelessWidget {
  final List<Restaurant> restaurantList;

  const BodyOfHomeScreen({super.key, required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          key: const ValueKey("sliverAppBar"),
          expandedHeight: 115,
          pinned: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Restaurant',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Recommendation restaurant for you!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
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
          }, childCount: restaurantList.length),
        ),
      ],
    );
  }
}
