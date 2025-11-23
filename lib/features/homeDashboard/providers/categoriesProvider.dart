import 'package:flutter/material.dart';

import '../../../api/apiController.dart';
import '../datamodels/categoriesDataModel.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoriesDataModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoriesDataModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    // notifyListeners();

    try {
      _categories = await ApiController().fetchCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}