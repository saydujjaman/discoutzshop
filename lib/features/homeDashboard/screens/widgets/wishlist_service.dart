import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static const String _wishlistKey = 'wishlist_items';

  // Add item to wishlist
  static Future<void> addToWishlist(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();
    
    // Check if item already exists
    final existingIndex = wishlist.indexWhere((existingItem) => 
        existingItem['id'] == item['id']);
    
    if (existingIndex == -1) {
      wishlist.add(item);
      await prefs.setStringList(_wishlistKey, 
          wishlist.map((item) => _serializeItem(item)).toList());
    }
  }

  // Remove item from wishlist
  static Future<void> removeFromWishlist(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();
    
    wishlist.removeWhere((item) => item['id'] == itemId);
    await prefs.setStringList(_wishlistKey, 
        wishlist.map((item) => _serializeItem(item)).toList());
  }

  // Get all wishlist items
  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistStrings = prefs.getStringList(_wishlistKey) ?? [];
    
    return wishlistStrings.map((itemString) => _deserializeItem(itemString)).toList();
  }

  // Check if item is in wishlist
  static Future<bool> isInWishlist(int itemId) async {
    final wishlist = await getWishlist();
    return wishlist.any((item) => item['id'] == itemId);
  }

  // Helper method to serialize item to string
  static String _serializeItem(Map<String, dynamic> item) {
    return '${item['id']}|${item['name']}|${item['imageUrl'] ?? ''}';
  }

  // Helper method to deserialize string to item
  static Map<String, dynamic> _deserializeItem(String itemString) {
    final parts = itemString.split('|');
    return {
      'id': int.parse(parts[0]),
      'name': parts[1],
      'imageUrl': parts[2],
    };
  }
}