import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService _apiServices;

  RestaurantReviewProvider(this._apiServices);

  RestaurantReviewResultState _resultState = RestaurantReviewNoneState();

  RestaurantReviewResultState get resultState => _resultState;

  Future<void> writeRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    String errorMessage = "Please check your internet connection.";
    try {
      _resultState = RestaurantReviewLoadingState();
      notifyListeners();

      final result = await _apiServices.writeReview(id, name, review);

      if (result.error) {
        _resultState = RestaurantReviewErrorState(errorMessage);
      } else {
        _resultState = RestaurantReviewLoadedState(result.customerReviews);
      }
    } on Exception {
      _resultState = RestaurantReviewErrorState(errorMessage);
    } finally {
      notifyListeners();
    }
  }
}
