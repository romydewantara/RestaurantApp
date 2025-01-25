import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/body_of_search_screen.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/search/search_provider.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantSearchProvider>().searchRestaurant("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Consumer<SearchProvider>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    value.isSearching
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: value.searchController,
                              decoration: InputDecoration(
                                hintText: 'Write restaurant\'s name…',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                Future.microtask(() {
                                  context
                                      .read<RestaurantSearchProvider>()
                                      .searchRestaurant(value);
                                });
                              },
                            ),
                          )
                        : Text(
                            'Search',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                    IconButton(
                        icon: Icon(
                            value.isSearching ? Icons.close : Icons.search),
                        onPressed: () =>
                            Provider.of<SearchProvider>(context, listen: false)
                                .switchIcon()),
                  ],
                );
              },
            ),
          ),
          Expanded(child: Consumer<RestaurantSearchProvider>(
            builder: (context, value, child) {
              return switch (value.searchResultState) {
                RestaurantSearchLoadingState() => Center(
                    child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Lottie.asset("assets/loading.json")),
                  ),
                RestaurantSearchLoadedState(data: var restaurantList) =>
                  BodyOfSearchScreen(restaurantList: restaurantList),
                RestaurantSearchErrorState(error: var message) => Center(
                    child: Text(message),
                  ),
                _ => const SizedBox(),
              };
            },
          ))
        ],
      ),
    );
  }
}
