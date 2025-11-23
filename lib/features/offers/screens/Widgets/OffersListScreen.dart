import 'package:discountzshop/api/apiController.dart';
import 'package:discountzshop/features/offers/screens/OfferDetailsScreen.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OffersListScreen extends StatefulWidget {
  final String slug;
  final String? brandName;

  const OffersListScreen({
    Key? key,
    required this.slug,
    this.brandName,
  }) : super(key: key);

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
  List<dynamic> offers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final apiController = ApiController();
      final offerDetails = await apiController.fetchElaborateOfferDetails(widget.slug);
      final brandMap = offerDetails['brand'] as Map<String, dynamic>?;
      final brandName = brandMap?['slug'] as String? ?? 'Apex';
      final url = Uri.parse('https://www.discountzshop.com/api/brand/${brandName}/offers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final data = decodedResponse['data'] as Map<String, dynamic>?;
        final offersList = data?['offers'] as List<dynamic>? ?? [];

        setState(() {
          offers = offersList;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load offers: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      print('Error fetching offers: $e');
    }
  }

  String _calculateTimeLeft(String? expiryDate) {
    if (expiryDate == null || expiryDate.isEmpty) return "N/A";
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now);
      if (difference.isNegative) return "Expired";
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      return "${days}d: ${hours}h: ${minutes}m";
    } catch (e) {
      return "N/A";
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => FilterLocationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.brandName != null ? '${widget.brandName} Offers' : 'Offers',
          style: TextStyle(color: TColors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: TColors.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
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
                  onPressed: _showFilterDialog, // Filter button now works
                  child: Row(
                    children: [
                      Text("Filter", style: TextStyle(color: TColors.black)),
                      SizedBox(width: TSizes.sm / 2),
                      Icon(Iconsax.filter_copy, size: 18, color: TColors.primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: TColors.primaryColor))
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchOffers,
                        style: ElevatedButton.styleFrom(backgroundColor: TColors.primaryColor),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : offers.isEmpty
                  ? Center(
                      child: Text('No offers available', style: TextStyle(fontSize: 16, color: TColors.darkGrey)),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchOffers,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: offers.length,
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return GestureDetector(
                              onTap: () {
                                final slug = offer['slug'];
                                if (slug != null && slug.toString().isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfferDetailsScreen(slug: slug.toString()),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Oops!!"),
                                      content: const Text("Sorry, this item is not available right now"),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Okay")),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: OfferCard(
                                imageUrl: offer['source_url'] ?? '',
                                brand: offer['brand'] ?? '',
                                title: offer['name'] ?? 'No Title',
                                discount: offer['badge'] ?? 'No Discount',
                                price: offer['price']?.toString() ?? '',
                                offerPrice: offer['offer_price']?.toString() ?? '',
                                timeLeft: _calculateTimeLeft(offer['expiry_date']),
                                imageHeight: imageHeight,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
    );
  }
}

// REUSABLE FILTER DIALOG (Same as before – fully working with your APIs)
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
            print("=== LOCATION FILTER APPLIED (OffersListScreen) ===");
            print("Division: $selectedDivisionName → $selectedDivisionSlug");
            print("City: $selectedCityName → $selectedCitySlug");
            print("Area: $selectedAreaName → $selectedAreaSlug");
            print("================================================");

            // TODO: Apply filter to current offers list or refetch with location params
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
              icon: isLoading
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.arrow_drop_down, color: TColors.darkGrey),
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

// OfferCard remains 100% unchanged
class OfferCard extends StatelessWidget {
  final String imageUrl;
  final String brand;
  final String title;
  final String discount;
  final String price;
  final String offerPrice;
  final String timeLeft;
  final double imageHeight;

  const OfferCard({
    super.key,
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.discount,
    required this.price,
    required this.offerPrice,
    required this.timeLeft,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: TColors.primaryColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 110,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.grey[600], size: 30),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 110,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TColors.primaryColor,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(top: 6, right: 6, child: Icon(Icons.favorite_border, color: TColors.primaryColor, size: 18)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(brand, style: const TextStyle(fontSize: 9, color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines: 1),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(discount, style: const TextStyle(fontSize: 11, color: TColors.primaryColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 10, color: TColors.primaryColor),
                        const SizedBox(width: 1),
                        Text(timeLeft, style: const TextStyle(fontSize: 8, color: TColors.darkGrey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (price.isNotEmpty && offerPrice.isNotEmpty)
                  Row(
                    children: [
                      Text('Tk $offerPrice', style: const TextStyle(fontSize: 10, color: TColors.primaryColor, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 3),
                      Text('Tk $price', style: const TextStyle(fontSize: 8, color: TColors.darkGrey, decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 26),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      backgroundColor: TColors.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    ),
                    child: const Text("VIEW", style: TextStyle(fontSize: 10, color: TColors.white, fontWeight: FontWeight.bold)),
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