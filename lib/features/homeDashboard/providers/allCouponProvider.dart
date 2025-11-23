import 'package:flutter/material.dart';

import '../../../api/apiController.dart';
import '../datamodels/CouponResponseDataModel.dart';


class CouponProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  List<Coupon> _coupons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Coupon> get coupons => _coupons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCoupons() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();

    try {
      final response = await _apiController.getCoupons();
      _coupons = response.data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}