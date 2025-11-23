// 

// providers/BrandProvider.dart
import 'package:flutter/material.dart';
import '../../../api/apiController.dart';
import '../datamodels/BrandsDataModel.dart';

class BrandProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();

  final Map<String, List<Brands>> _brandsByCategory = {};
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  late final Future<void> _initialFetch;

  Map<String, List<Brands>> get brandsByCategory => _brandsByCategory;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  Future<void> get initialFetch => _initialFetch;

  BrandProvider() {
    _initialFetch = refresh();
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _brandsByCategory.clear();
    _hasMore = true;
    _error = null;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newBrands = await _apiController.fetchBrands(page: _currentPage);

      if (newBrands.isEmpty) {
        _hasMore = false;
      } else {
        for (var brand in newBrands) {
          final cat = brand.categoryName ?? 'Others';
          _brandsByCategory.putIfAbsent(cat, () => []).add(brand);
        }
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}