import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  bool get isSearching => _isSearching;
  TextEditingController get searchController => _searchController;

  void switchIcon() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      _searchController.clear();
    }
    notifyListeners();
  }
}