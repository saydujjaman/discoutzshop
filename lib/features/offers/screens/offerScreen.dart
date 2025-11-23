import 'package:discountzshop/features/homeDashboard/screens/widgets/wishlist_service.dart';
import 'package:discountzshop/features/offers/screens/OfferDetailsScreen.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/offerProvider.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  List<dynamic> searchOffers = [];
  bool isSearchMode = false;

  void _handleSearch(List<dynamic> offers) {
    setState(() {
      searchOffers = offers;
      isSearchMode = true;
    });
  }

  void _resetToAllOffers() {
    setState(() {
      searchOffers = [];
      isSearchMode = false;
    });
    Provider.of<OfferProvider>(context, listen: false).refreshOffers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final childAspectRatio = (screenWidth / screenHeight) * 1.25;
    final imageHeight = screenWidth * 0.35;

    return ChangeNotifierProvider(
      create: (context) => OfferProvider()..fetchOffers(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: TColors.primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _resetToAllOffers,
                child: Row(
                  children: [
                    Text("All Offers", style: TextStyle(color: TColors.darkerGrey)),
                    SizedBox(width: TSizes.sm / 2),
                    Icon(Icons.arrow_drop_down_circle_outlined, size: 18, color: TColors.primaryColor),
                  ],
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: TColors.grey),
                  ),
                ),
                onPressed: () => _showFilterDialog(context),
                child: Row(
                  children: [
                    Text("Filter", style: TextStyle(color: TColors.black)),
                    SizedBox(width: TSizes.sm / 2),
                    Icon(Iconsax.filter_copy, size: 18, color: TColors.primaryColor),
                  ],
                ),
              ),
              SizedBox(width: TSizes.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showSearchDialog(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(CupertinoIcons.search, color: TColors.darkGrey),
                        hintText: "Search here...",
                        hintStyle: TextStyle(color: TColors.darkGrey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: TColors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: isSearchMode
            ? _buildSearchResults(imageHeight, childAspectRatio)
            : Consumer<OfferProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.offers.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: TColors.primaryColor));
                  }
                  if (provider.error != null) {
                    return Center(child: Text('Error: ${provider.error}'));
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!provider.isLoading && provider.hasMore &&
                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        provider.fetchOffers();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: provider.refreshOffers,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: provider.offers.length + (provider.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == provider.offers.length) {
                              return Center(child: CircularProgressIndicator(color: TColors.primaryColor));
                            }
                            final offer = provider.offers[index];
                            return OfferCard(
                              imageUrl: offer.image ?? "",
                              brand: offer.brandName ?? "",
                              title: offer.name,
                              discount: offer.badge,
                              timeLeft: offer.expiryDate != null ? _calculateTimeLeft(offer.expiryDate!) : "",
                              imageHeight: imageHeight,
                              slug: offer.slug,
                              offerId: offer.id?.toString() ?? '',
                              // ALTERNATIVE: Manual map creation instead of toJson()
                              offerData: {
                                'id': offer.id,
                                'name': offer.name,
                                'image': offer.image,
                                'brandName': offer.brandName,
                                'badge': offer.badge,
                                'expiryDate': offer.expiryDate,
                                'slug': offer.slug,
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSearchResults(double imageHeight, double childAspectRatio) {
    if (searchOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.search, size: 64, color: TColors.grey),
            SizedBox(height: 16),
            Text('No offers found', style: TextStyle(color: TColors.darkGrey)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: searchOffers.length,
        itemBuilder: (context, index) {
          final offer = searchOffers[index];
          return OfferCard(
            imageUrl: offer['offer_image'] ?? "",
            brand: offer['brand_logo'] != null ? "" : "",
            title: offer['offer_name'] ?? 'No Title',
            discount: offer['offer price'] != null 
                ? '৳${offer['offer price']}' 
                : 'No Price',
            timeLeft: offer['offer_validity'] != null && offer['offer_validity'] != 'No Expiry'
                ? _calculateTimeLeft(offer['offer_validity']!)
                : "No Expiry",
            imageHeight: imageHeight,
            slug: offer['offer_slug'],
            offerId: offer['id']?.toString() ?? offer['offer_id']?.toString() ?? '',
            // ALTERNATIVE: Already a Map from API response
            offerData: offer,
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return FilterLocationDialog();
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SearchDialog(onSearchComplete: _handleSearch);
      },
    );
  }

  String _calculateTimeLeft(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now);
      if (difference.isNegative) return "Expired";
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      return "${days}d ${hours}h ${minutes}m";
    } catch (e) {
      return "No Expiry";
    }
  }
}

// SEARCH DIALOG
class SearchDialog extends StatefulWidget {
  final Function(List<dynamic>) onSearchComplete;

  const SearchDialog({required this.onSearchComplete, Key? key}) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  Future<void> _performSearch() async {
    final searchText = _searchController.text.trim();
    if (searchText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter search text')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://www.discountzshop.com/api/global-search?search=$searchText'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final offers = data['offer'] as List? ?? [];
          
          Navigator.pop(context);
          
          if (offers.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No data found for "$searchText"')),
            );
          }
          
          widget.onSearchComplete(offers);
        }
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed. Please try again.')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Search Offers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TColors.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Search Input
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter search text...",
                prefixIcon: Icon(CupertinoIcons.search, color: TColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: TColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: TColors.primaryColor, width: 2),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            SizedBox(height: 16),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: TColors.grey),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Close", style: TextStyle(color: TColors.darkGrey)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text("Search", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// FILTER DIALOG
class FilterLocationDialog extends StatefulWidget {
  @override
  _FilterLocationDialogState createState() => _FilterLocationDialogState();
}

class _FilterLocationDialogState extends State<FilterLocationDialog> {
  List<Map<String, String>> divisions = [];
  List<Map<String, String>> cities = [];
  List<Map<String, String>> areas = [];

  String? selectedDivisionSlug;
  String? selectedCitySlug;
  String? selectedAreaSlug;

  String? selectedDivisionName;
  String? selectedCityName;
  String? selectedAreaName;

  bool isLoadingDivisions = true;
  bool isLoadingCities = false;
  bool isLoadingAreas = false;

  @override
  void initState() {
    super.initState();
    fetchDivisions();
  }

  Future<void> fetchDivisions() async {
    setState(() => isLoadingDivisions = true);
    try {
      final response = await http.get(Uri.parse('https://www.discountzshop.com/api/divisions'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            divisions = List<Map<String, String>>.from(
              data['data'].map((item) => {
                    'name': item['name'] as String,
                    'slug': item['slug'] as String,
                  }),
            );
            isLoadingDivisions = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching divisions: $e");
      setState(() => isLoadingDivisions = false);
    }
  }

  Future<void> fetchCities(String divisionSlug) async {
    setState(() {
      isLoadingCities = true;
      cities.clear();
      areas.clear();
      selectedCitySlug = null;
      selectedAreaSlug = null;
      selectedCityName = null;
      selectedAreaName = null;
    });

    try {
      final response = await http.get(Uri.parse('https://www.discountzshop.com/api/division/$divisionSlug/cities'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final cityList = data['division']['cities'] as List;
          setState(() {
            cities = cityList.map((item) => {
                  'name': item['name'] as String,
                  'slug': item['slug'] as String,
                }).toList();
            isLoadingCities = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching cities: $e");
      setState(() => isLoadingCities = false);
    }
  }

  Future<void> fetchAreas(String citySlug) async {
    setState(() {
      isLoadingAreas = true;
      areas.clear();
      selectedAreaSlug = null;
      selectedAreaName = null;
    });

    try {
      final response = await http.get(Uri.parse('https://www.discountzshop.com/api/city/$citySlug/areas'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final areaList = data['city']['areas'] as List;
          setState(() {
            areas = areaList.map((item) => {
                  'name': item['name'] as String,
                  'slug': item['slug']?.toString() ?? item['id'].toString(),
                }).toList();
            isLoadingAreas = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching areas: $e");
      setState(() => isLoadingAreas = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Filter by Location", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.primaryColor)),
          IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown(
                label: "Select Division",
                items: divisions,
                value: selectedDivisionName,
                isLoading: isLoadingDivisions,
                hint: "Choose Division",
                onChanged: (val) {
                  final selected = divisions.firstWhere((d) => d['name'] == val);
                  setState(() {
                    selectedDivisionName = val;
                    selectedDivisionSlug = selected['slug'];
                  });
                  fetchCities(selected['slug']!);
                },
              ),
              SizedBox(height: 16),

              _buildDropdown(
                label: "Select City",
                items: cities,
                value: selectedCityName,
                isLoading: isLoadingCities,
                hint: selectedDivisionSlug == null ? "First select division" : "Choose City",
                enabled: selectedDivisionSlug != null && !isLoadingCities,
                onChanged: (val) {
                  final selected = cities.firstWhere((c) => c['name'] == val);
                  setState(() {
                    selectedCityName = val;
                    selectedCitySlug = selected['slug'];
                  });
                  fetchAreas(selected['slug']!);
                },
              ),
              SizedBox(height: 16),

              _buildDropdown(
                label: "Select Area",
                items: areas,
                value: selectedAreaName,
                isLoading: isLoadingAreas,
                hint: selectedCitySlug == null ? "First select city" : "Choose Area",
                enabled: selectedCitySlug != null && !isLoadingAreas,
                onChanged: (val) {
                  final selected = areas.firstWhere((a) => a['name'] == val);
                  setState(() {
                    selectedAreaName = val;
                    selectedAreaSlug = selected['slug'];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close", style: TextStyle(color: TColors.darkGrey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: TColors.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, String>> items,
    required String? value,
    required String hint,
    bool isLoading = false,
    bool enabled = true,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: TColors.darkerGrey)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: enabled ? TColors.grey : TColors.lightGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(hint, style: TextStyle(color: TColors.darkGrey)),
              value: value,
              icon: isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item['name'],
                        child: Text(item['name']!),
                      ))
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}


 class OfferCard extends StatefulWidget {
  final String? imageUrl;
  final String? brand;
  final String? title;
  final String? discount;
  final String timeLeft;
  final double imageHeight;
  final String? slug;
  final String offerId;
  final dynamic offerData;

  const OfferCard({
    this.imageUrl,
    this.brand,
    this.title,
    this.discount,
    required this.timeLeft,
    required this.imageHeight,
    this.slug,
    required this.offerId,
    required this.offerData,
    Key? key,
  }) : super(key: key);

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final int id = int.tryParse(widget.offerId) ?? 0;
    if (id == 0) return;

    final isFav = await WishlistService.isInWishlist(id);
    if (mounted) {
      setState(() {
        _isFavorited = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final int id = int.tryParse(widget.offerId) ?? 0;
    if (id == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid offer ID')),
      );
      return;
    }

    final item = {
      'id': id,
      'name': widget.title ?? 'Unknown Offer',
      'imageUrl': widget.imageUrl ?? '',
    };

    if (_isFavorited) {
      await WishlistService.removeFromWishlist(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from wishlist'), duration: Duration(seconds: 1)),
      );
    } else {
      await WishlistService.addToWishlist(item);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to wishlist!'), duration: Duration(seconds: 1)),
      );
    }

    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: TColors.primaryColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Stack(
              children: [
                Image.network(
                  widget.imageUrl ?? '',
                  width: double.infinity,
                  height: widget.imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorited ? Colors.red : TColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brand ?? 'Unknown Brand',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.title ?? 'No Title',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.discount ?? 'No Discount',
                        style: TextStyle(fontSize: 14, color: TColors.primaryColor, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: TColors.primaryColor),
                        const SizedBox(width: 4),
                        Text(widget.timeLeft, style: const TextStyle(fontSize: 10, color: TColors.darkGrey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      if (widget.slug != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OfferDetailsScreen(slug: widget.slug!)),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Oops!!"),
                            content: const Text("Sorry, this item is not available right now"),
                            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Okay"))],
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: TColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("VIEW", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}