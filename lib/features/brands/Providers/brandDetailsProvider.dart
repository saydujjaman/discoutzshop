
import 'package:flutter/material.dart';
import '../../../api/apiController.dart';
import '../datamodels/brandDataModel.dart'; // Ensure this is BrandDetailsDataModel
import '../datamodels/storeDataModel.dart';
import '../datamodels/offerDataModel.dart';

class BrandDetailsProvider with ChangeNotifier {
  final ApiController _apiController = ApiController();
  final Map<String, BrandDetailsDataModel> _brands = {};
  final Map<String, List<Store>> _stores = {};
  final Map<String, List<BrandOffersDataModel>> _offers = {};
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  BrandDetailsDataModel? getBrand(String slug) => _brands[slug];
  List<Store> getStores(String slug) => _stores[slug] ?? [];
  List<BrandOffersDataModel> getOffers(String slug) => _offers[slug] ?? [];

  /*Future<void> loadBrandData(String slug) async {
    print("Starting to load brand data for slug: $slug");
    if (_isLoading || (_brands.containsKey(slug) && _stores.containsKey(slug) && _offers.containsKey(slug))) {
      print("Data already loading or exists, skipping fetch");
      return;
    }

    _isLoading = true;
    _error = null;
    // notifyListeners(); // Notify UI of loading start

    try {
      // Fetch all data in sequence
      final brand = await _apiController.fetchBrandDetails(slug);
      print("Brand fetched: $brand");
      _brands[slug] = brand;

      final storeResponse = await _apiController.fetchBrandStores(slug);
      _stores[slug] = storeResponse.stores ?? [];
      print("Stores fetched: ${storeResponse.stores}");

      final offerResponse = await _apiController.fetchBrandOffers(slug);
      print("Offers fetchedssss: ${getOffers(slug)}");
      _offers[slug] = offerResponse.offers ?? [];
      print("Offers fetched: ${offerResponse.offers}");

      print("All data loaded for slug: $slug");
    } catch (e) {
      _error = "Failed to load data: $e";
      print("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI of load completion or error
    }
  }*/
  Future<void> loadBrandData(String slug) async {
    print("Starting to load brand data for slug: $slug");
    if (_isLoading || (_brands.containsKey(slug) && _stores.containsKey(slug) && _offers.containsKey(slug))) {
      print("Data already loading or exists, skipping fetch");
      return;
    }

    _isLoading = true;
    _error = null;
    // notifyListeners();

    try {
      final brand = await _apiController.fetchBrandDetails(slug);
      print("Brand fetched: $brand");
      _brands[slug] = brand;

      final storeResponse = await _apiController.fetchBrandStores(slug);
      _stores[slug] = storeResponse.stores ?? [];
      print("Stores fetched: ${storeResponse.stores}");

      final offerResponse = await _apiController.fetchBrandOffers(slug);
      _offers[slug] = offerResponse.offers ?? [];
      print("Offers fetched: ${offerResponse.offers}");
      print("Offers stored: ${getOffers(slug)}");
    } catch (e) {
      _error = "Failed to load data: $e";
      print("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}