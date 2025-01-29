import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadFavoriteRestaurants();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey("favoriteScreen"),
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {

          return switch (value.restaurantList!.isNotEmpty) {
            true => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        Provider.of<LocalDatabaseProvider>(context, listen: false)
                            .searchRestaurants(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search a favorite restaurant…',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: value.restaurantList!.isEmpty
                        ? Center(
                            child: Text(
                              'Oops… no restaurants found.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: value.restaurantList!.length,
                            itemBuilder: (context, index) {
                              final restaurant = value.restaurantList![index];
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
                          ),
                  ),
                ],
              ),
            _ => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("There is no favorite restaurant yet."),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
