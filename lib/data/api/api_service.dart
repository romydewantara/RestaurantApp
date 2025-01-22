import 'dart:convert';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_review_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  Future<RestaurantReviewResponse> writeReview(
      String id, String name, String review) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'id': id,
      'name': name,
      'review': review,
    });
    final response = await http.post(Uri.parse("$_baseUrl/review"),
        headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RestaurantReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
