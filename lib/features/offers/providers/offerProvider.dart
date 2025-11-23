/*
import 'package:flutter/material.dart';
import '../../../api/apiController.dart';
import '../datamodels/offersDataModel.dart';

class OfferProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  List<Offer> _offers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> fetchOffers({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    _isLoading = true;
    _error = null;
    if (refresh) {
      _currentPage = 1;
      _offers.clear();
      _hasMore = true;
    }
    notifyListeners();

    try {
      final newOffers = await _apiController.fetchOffers(page: _currentPage);
      if (newOffers.isEmpty) {
        _hasMore = false;
      } else {
        _offers.addAll(newOffers);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOffers() => fetchOffers(refresh: true);
}*/
import 'package:flutter/material.dart';
import '../../../api/apiController.dart';
import '../datamodels/offersDataModel.dart';

class OfferProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  List<Offer> _offers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> fetchOffers({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    _isLoading = true;
    _error = null;
    if (refresh) {
      _currentPage = 1;
      _offers.clear();
      _hasMore = true;
    }
    // notifyListeners();

    try {
      final newOffers = await _apiController.fetchOffers(page: _currentPage);
      if (newOffers.isEmpty) {
        _hasMore = false;
      } else {
        _offers.addAll(newOffers);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOffers() => fetchOffers(refresh: true);
}