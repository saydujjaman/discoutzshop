import 'package:discountzshop/api/apiController.dart';
import 'package:flutter/material.dart';

import '../datamodels/firstSliderDataModel.dart';

class FirstSliderProvider with ChangeNotifier {
  List<firstSlider> _sliders = [];
  bool _isLoading = false;
  String? _error;


  List<firstSlider> get sliders => _sliders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiController _apiController = ApiController();

  Future<void> fetchSliders() async {
    _isLoading = true;
    _error = null;
    // notifyListeners();

    try {
      final response = await _apiController.fetchFirstSliders();
      _sliders = response.data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}