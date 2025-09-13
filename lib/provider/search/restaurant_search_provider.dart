import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _apiServices;

  RestaurantSearchProvider(this._apiServices);

  RestaurantSearchResultState _searchResultState = RestaurantSearchNoneState();

  RestaurantSearchResultState get searchResultState => _searchResultState;

  Future<void> searchRestaurant(String query) async {
    String errorMessage = "Please check your internet connection.";

    try {
      _searchResultState = RestaurantSearchLoadingState();
      notifyListeners();

      final result = await _apiServices.searchRestaurant(query);

      if (result.error) {
        _searchResultState = RestaurantSearchErrorState(errorMessage);
      } else {
        _searchResultState = RestaurantSearchLoadedState(result.restaurants);
      }
    } on Exception {
      _searchResultState = RestaurantSearchErrorState(errorMessage);
    } finally {
      notifyListeners();
    }
  }
}
