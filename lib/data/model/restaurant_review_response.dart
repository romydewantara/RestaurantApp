import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantReviewResponse {
  bool error;
  String message;
  List<Review> customerReviews;

  RestaurantReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantReviewResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<Review>.from(
            json["customerReviews"].map((x) => Review.fromJson(x))),
      );
}
