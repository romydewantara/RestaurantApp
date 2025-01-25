import 'dart:convert';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_review_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {

    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        switch (response.statusCode) {
          case 400:
            throw Exception('Bad Request: The request was invalid.');
            break;
          case 401:
            throw Exception('Unauthorized: Check your credentials.');
            break;
          case 403:
            throw Exception('Forbidden: You don\'t have access.');
            break;
          case 404:
            throw Exception('Not Found: The resource does not exist.');
            break;
          case 500:
            throw Exception('Server Error: Please try again later.');
            break;
          default:
            throw Exception('Failed to load restaurant list');
        }
      }
    } catch (e) {
      throw Exception('Please check your network connection');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {

    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        switch (response.statusCode) {
          case 400:
            throw Exception('Bad Request: The request was invalid.');
            break;
          case 401:
            throw Exception('Unauthorized: Check your credentials.');
            break;
          case 403:
            throw Exception('Forbidden: You don\'t have access.');
            break;
          case 404:
            throw Exception('Not Found: The resource does not exist.');
            break;
          case 500:
            throw Exception('Server Error: Please try again later.');
            break;
          default:
            throw Exception('Failed to load restaurant detail');
        }
      }
    } catch (e) {
      throw Exception('Please check your network connection');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {

    try {
      final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

      if (response.statusCode == 200) {
        return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        switch (response.statusCode) {
          case 400:
            throw Exception('Bad Request: The request was invalid.');
            break;
          case 401:
            throw Exception('Unauthorized: Check your credentials.');
            break;
          case 403:
            throw Exception('Forbidden: You don\'t have access.');
            break;
          case 404:
            throw Exception('Not Found: The resource does not exist.');
            break;
          case 500:
            throw Exception('Server Error: Please try again later.');
            break;
          default:
            throw Exception('Restaurant not found.');
        }
      }
    } catch (e) {
      throw Exception('Please check your network connection');
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

    try {
      final response = await http.post(Uri.parse("$_baseUrl/review"),
          headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RestaurantReviewResponse.fromJson(jsonDecode(response.body));
      } else {
        switch (response.statusCode) {
          case 400:
            throw Exception('Bad Request: The request was invalid.');
            break;
          case 401:
            throw Exception('Unauthorized: Check your credentials.');
            break;
          case 403:
            throw Exception('Forbidden: You don\'t have access.');
            break;
          case 404:
            throw Exception('Not Found: The resource does not exist.');
            break;
          case 500:
            throw Exception('Server Error: Please try again later.');
            break;
          default:
            throw Exception('Failed to load reviews.');
        }
      }
    } catch (e) {
      throw Exception('Please check your network connection');
    }
  }
}
