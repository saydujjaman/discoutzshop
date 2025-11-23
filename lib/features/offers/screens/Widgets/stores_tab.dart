import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../api/apiController.dart';

class StoresTab extends StatefulWidget {
  final String slug;

  const StoresTab({required this.slug, super.key});

  @override
  State<StoresTab> createState() => _StoresTabState();
}

class _StoresTabState extends State<StoresTab> {
  late Future<Map<String, dynamic>> _combinedData;

  @override
  void initState() {
    super.initState();
    _combinedData = _fetchCombinedData();
  }

  Future<Map<String, dynamic>> _fetchCombinedData() async {
    final apiController = ApiController();
    final offerDetails = await apiController.fetchElaborateOfferDetails(widget.slug);
    final brandMap = offerDetails['brand'] as Map<String, dynamic>?;
    final brandName = brandMap?['slug'] as String? ?? 'Apex';
    final stores = await apiController.getBrandStores(brandName);
    
    return {
      'offerDetails': offerDetails,
      'stores': stores,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _combinedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final combinedData = snapshot.data!;
        final offerDetails = combinedData['offerDetails'] as Map<String, dynamic>;
        final stores = combinedData['stores'] as List<Map<String, dynamic>>? ?? [];
        
        final brand = offerDetails['brand'] as Map<String, dynamic>;
        final bannerImage = brand['banner_image'] as String? ?? 'https://via.placeholder.com/400x150';

        if (stores.isEmpty) {
          return Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  bannerImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                ),
              ),
              const Expanded(
                child: Center(child: Text('No stores available')),
              ),
            ],
          );
        }

        return Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                bannerImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final title = store['title'] as String? ?? 'No Title';
                  final address = store['address_line_one'] as String? ?? 'No Address';
                  final phone = store['phone'] as String?;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (phone != null && phone.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}