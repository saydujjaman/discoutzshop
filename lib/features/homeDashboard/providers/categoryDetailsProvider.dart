import 'package:flutter/material.dart';

import '../../../api/apiController.dart';
import '../datamodels/categoryDetailsDataModel.dart';

class CategoryDetailsProvider with ChangeNotifier {
  CategoryDetailsDataModel? _categoryDetails;
  bool _isLoading = false;
  String? _error;

  CategoryDetailsDataModel? get categoryDetails => _categoryDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategoryDetails(String slug) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiController().getCategoryDetails(slug);
      _categoryDetails = response;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
