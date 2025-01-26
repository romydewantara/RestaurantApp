import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/service/restaurant_sqlite_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final RestaurantSqliteService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  Future<void> addFavoriteRestaurant(Restaurant value) async {
    try {
      final result = await _service.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> loadFavoriteRestaurants() async {
    try {
      _restaurantList = await _service.getAllItems();
      _restaurant = null;
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e, stackTrace) {
      _message = "Failed to load your all data";
      notifyListeners();
    }
  }

  Future<void> loadRestaurantById(String id) async {
    try {
      _restaurant = await _service.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  Future<void> updateRestaurantById(int id, Restaurant value) async {
    try {
      final result = await _service.updateItem(id, value);

      final isEmptyRowUpdated = result == 0;
      if (isEmptyRowUpdated) {
        _message = "Failed to update your data";
        notifyListeners();
      } else {
        _message = "Your data is updated";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to update your data";
      notifyListeners();
    }
  }

  Future<void> removeRestaurantById(String id) async {
    try {
      await _service.removeItem(id);

      _message = "Your data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }

  bool checkItemFavorite(String id) {
    if (_restaurant == null) {
      return false;
    }
    final isSameRestaurant = _restaurant!.id == id;
    return isSameRestaurant;
  }
}
