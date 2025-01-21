import 'package:restaurant_app/data/model/restaurant_detail.dart';

sealed class RestaurantReviewResultState {}

class RestaurantReviewNoneState extends RestaurantReviewResultState {}

class RestaurantReviewLoadingState extends RestaurantReviewResultState {}

class RestaurantReviewErrorState extends RestaurantReviewResultState {
  final String error;

  RestaurantReviewErrorState(this.error);
}

class RestaurantReviewLoadedState extends RestaurantReviewResultState {
  final List<Review> data;

  RestaurantReviewLoadedState(this.data);
}