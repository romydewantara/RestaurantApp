import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerReview = TextEditingController();
  String? _errorTextName;
  String? _errorTextReview;
  String? _name;
  String? _review;

  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerReview => _controllerReview;

  String? get errorTextName => _errorTextName;
  String? get errorTextReview => _errorTextReview;
  String? get fieldName => _name;
  String? get fieldReview => _review;

  void updateFieldName(String value) {
    _name = value;
    notifyListeners();
  }

  void updateFieldReview(String value) {
    _review = value;
    notifyListeners();
  }

  void updateErrorTextName() {
    _errorTextName = 'This field cannot be empty';
    notifyListeners();
  }

  void updateErrorTextReview() {
    _errorTextReview = 'This field cannot be empty';
    notifyListeners();
  }

  void reset() {
    _errorTextName = null;
    _errorTextReview = null;
    _controllerName.clear();
    _controllerReview.clear();
    notifyListeners();
  }
}