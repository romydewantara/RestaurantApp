import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurantDetail;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurantDetail,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json["error"],
      message: json["message"],
      restaurantDetail: RestaurantDetail.fromJson(json["restaurant"]),
    );
  }
}
