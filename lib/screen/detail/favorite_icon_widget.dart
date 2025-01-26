import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final Restaurant restaurant;
  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  State<StatefulWidget> createState() => _FavoriteIconWidget();
}

class _FavoriteIconWidget extends State<FavoriteIconWidget> {
  @override
  void initState() {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value =
          localDatabaseProvider.checkItemFavorite(widget.restaurant.id);

      favoriteIconProvider.isFavorite = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavorite = favoriteIconProvider.isFavorite;

        if (!isFavorite) {
          localDatabaseProvider.addFavoriteRestaurant(widget.restaurant);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${widget.restaurant.name} is added to favorites',
              ),
            ),
          );
        } else {
          localDatabaseProvider.removeRestaurantById(widget.restaurant.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${widget.restaurant.name} removed from favorites',
              ),
            ),
          );
        }
        favoriteIconProvider.isFavorite = !isFavorite;
        localDatabaseProvider.loadFavoriteRestaurants();
      },
      iconSize: 12.0,
      icon: context.watch<FavoriteIconProvider>().isFavorite
          ? Icon(Icons.favorite, color: Colors.red)
          : Icon(Icons.favorite_border),
    );
  }
}
