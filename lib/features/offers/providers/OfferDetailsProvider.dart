import 'package:flutter/material.dart';
import '../../../api/apiController.dart';
import '../datamodels/OfferDetailsDataModel.dart';

class OfferDetailsProvider with ChangeNotifier {
  OfferDetails? _offerDetails;
  bool _isLoading = false;
  final ApiController _apiController = ApiController();

  OfferDetails? get offerDetails => _offerDetails;
  bool get isLoading => _isLoading;

  OfferDetailsProvider() {
    // No initial fetch, wait for slug to be provided
  }

  Future<void> fetchData(String slug) async {
    if (slug == null) return;
    _isLoading = true;
    // notifyListeners();
    try {
      final data = await _apiController.fetchOfferDetails(slug);
      if (data != null) {
        _offerDetails = data;
        print("PROVIDER PRINT- $data");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSlug(String slug) {
    _offerDetails = null;
    fetchData(slug);
  }
}