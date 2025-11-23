import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/wishlist_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    final wishlist = await WishlistService.getWishlist();
    setState(() {
      _wishlistItems = wishlist;
      _isLoading = false;
    });
  }

  Future<void> _removeItem(int itemId) async {
    await WishlistService.removeFromWishlist(itemId);
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Removed from wishlist"),
        duration: Duration(seconds: 1),
      ),
    );

    // Refresh list
    await _loadWishlist();

    // THIS IS THE KEY: Notify HomeScreen to update badge count
    // We trigger a rebuild of the entire app context using a simple trick
    // (Since we don't have Provider here, we use SharedPreferences listener simulation)
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('wishlist_updated', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Wish List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap heart on offers to save them here',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.white,
                        child: const Row(
                          children: [
                            Expanded(flex: 1, child: Text('Sl', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                            Expanded(flex: 2, child: Text('Image', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                            Expanded(flex: 4, child: Text('Offer Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                            Expanded(flex: 2, child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = _wishlistItems[index];
                            return _buildWishlistItem(item, index + 1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item, int serialNumber) {
    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      onDismissed: (direction) {
        _removeItem(item['id']);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Serial
            Expanded(flex: 1, child: Text(serialNumber.toString(), style: const TextStyle(fontWeight: FontWeight.w500))),

            // Image
            Expanded(
              flex: 2,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: item['imageUrl'] != null && item['imageUrl'].toString().isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item['imageUrl'], fit: BoxFit.cover),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),

            // Name
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  item['name'] ?? 'Unknown Offer',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Delete Button
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () => _removeItem(item['id']),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
                tooltip: 'Remove from wishlist',
              ),
            ),
          ],
        ),
      ),
    );
  }
}