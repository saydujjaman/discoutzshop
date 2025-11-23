import 'package:flutter/material.dart';

import '../../../api/apiController.dart';
import '../datamodels/HomepageDataModel.dart';

class HomepageProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  HomepageResponse? _homepageResponse;
  bool _isLoading = false;
  String? _errorMessage;

  HomepageResponse? get homepageResponse => _homepageResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomepageData() async {
    print('Fetching homepage data...');
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();

    try {
      final response = await _apiController.getHomepage();
      _homepageResponse = response;
      print('Homepage data received: ${response.homepageData.dealTitle}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching homepage data: $e');
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}