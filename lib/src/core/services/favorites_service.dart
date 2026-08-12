import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  FavoritesService._internal();

  static final FavoritesService instance = FavoritesService._internal();

  static const _kProductsKey = 'favorites_products';
  static const _kRestaurantsKey = 'favorites_restaurants';

  final ValueNotifier<List<Map<String, dynamic>>> products =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<List<Map<String, dynamic>>> restaurants =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final prodList = _prefs!.getStringList(_kProductsKey) ?? <String>[];
    products.value = prodList.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();

    final restList = _prefs!.getStringList(_kRestaurantsKey) ?? <String>[];
    restaurants.value = restList.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  Future<void> _saveProducts() async {
    final list = products.value.map((m) => jsonEncode(m)).toList();
    await _prefs?.setStringList(_kProductsKey, list);
  }

  Future<void> _saveRestaurants() async {
    final list = restaurants.value.map((m) => jsonEncode(m)).toList();
    await _prefs?.setStringList(_kRestaurantsKey, list);
  }

  bool isProductFavorite(String id) {
    return products.value.any((e) => (e['id'] ?? '') == id);
  }

  bool isRestaurantFavorite(String id) {
    return restaurants.value.any((e) => (e['id'] ?? '') == id);
  }

  Future<void> toggleProduct(Map<String, dynamic> item) async {
    final id = item['id']?.toString() ?? '';
    final exists = isProductFavorite(id);
    if (exists) {
      products.value = products.value.where((e) => (e['id']?.toString() ?? '') != id).toList();
    } else {
      products.value = [...products.value, item];
    }
    await _saveProducts();
  }

  Future<void> toggleRestaurant(Map<String, dynamic> item) async {
    final id = item['id']?.toString() ?? '';
    final exists = isRestaurantFavorite(id);
    if (exists) {
      restaurants.value = restaurants.value.where((e) => (e['id']?.toString() ?? '') != id).toList();
    } else {
      restaurants.value = [...restaurants.value, item];
    }
    await _saveRestaurants();
  }
}
