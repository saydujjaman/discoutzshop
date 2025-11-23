/*
import 'package:discountzshop/features/stores/datamodels/storeListDataModel.dart';
import 'package:flutter/material.dart';

import '../../../api/apiController.dart';

class StoreListProvider with ChangeNotifier {
  List<StoreListDataModel> _stores = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<StoreListDataModel> get stores => _stores;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchStores() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    final newStores = await ApiController.fetchStores(_currentPage);
    print('Fetched stores: ${newStores.length}'); // Debug log
    print('Current stores before add: ${_stores.length}'); // Debug log

    if (newStores.isEmpty) {
      _hasMore = false;
    } else {
      _stores.addAll(newStores);
      _currentPage++;
    }

    print('Current stores after add: ${_stores.length}'); // Debug log
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _stores = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    notifyListeners();
  }
}*/
/*
import 'package:discountzshop/features/stores/datamodels/storeListDataModel.dart';
import 'package:flutter/material.dart';

import '../../../api/apiController.dart';

class StoreListProvider with ChangeNotifier {
  List<StoreListDataModel> _stores = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<StoreListDataModel> get stores => _stores;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchStores() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    final newStores = await ApiController.fetchStores(_currentPage);
    print('Fetched stores: ${newStores.length}'); // Debug log
    print('Current stores before add: ${_stores.length}'); // Debug log

    if (newStores.isEmpty) {
      _hasMore = false;
    } else {
      _stores.addAll(newStores);
      _currentPage++;
    }

    print('Current stores after add: ${_stores.length}'); // Debug log
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _stores = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    notifyListeners();
  }
}*/
import 'package:discountzshop/features/stores/datamodels/storeListDataModel.dart';
import 'package:flutter/material.dart';

import '../../../api/apiController.dart';

class StoreListProvider with ChangeNotifier {
  List<StoreListDataModel> _stores = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  List<StoreListDataModel> get stores => _stores;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchStores() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    final newStores = await ApiController.fetchStores(_currentPage);
    print('Fetched stores: ${newStores.length}'); // Debug log
    print('Current stores before add: ${_stores.length}'); // Debug log

    if (newStores.isEmpty) {
      _hasMore = false;
    } else {
      _stores.addAll(newStores);
      _currentPage++;
    }

    print('Current stores after add: ${_stores.length}'); // Debug log
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _stores = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    notifyListeners();
  }
}