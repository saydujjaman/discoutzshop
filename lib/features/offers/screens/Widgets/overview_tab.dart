import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../api/apiController.dart';

class OverviewTab extends StatefulWidget {
  final String slug;
  const OverviewTab({required this.slug, super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late Future<Map<String, dynamic>> _combinedData;

  @override
  void initState() {
    super.initState();
    _combinedData = _fetchCombinedData();
  }

  Future<Map<String, dynamic>> _fetchCombinedData() async {
    final apiController = ApiController();
    print("This is widget slug from overview section- ${widget.slug}");
    final offerDetails = await apiController.fetchElaborateOfferDetails(widget.slug);
    final brandMap = offerDetails['brand'] as Map<String, dynamic>?;
    print("This is brandmap - $brandMap");
    final brandName = brandMap?['slug'] as String? ?? 'Apex';
    final overviewData = await apiController.fetchBrandOverviewData(brandName);
    
    return {
      'offerDetails': offerDetails,
      'overviewData': overviewData,
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
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('No data available: ${snapshot.error}'));
        }

        final combinedData = snapshot.data!;
        final offerDetails = combinedData['offerDetails'] as Map<String, dynamic>;
        final overviewData = combinedData['overviewData'] as Map<String, dynamic>?;
        
        final brand = offerDetails['brand'] as Map<String, dynamic>;
        final bannerImage = brand['banner_image'] as String? ?? 'https://via.placeholder.com/400x150';
        
        final dataMap = overviewData?['data'] as Map<String, dynamic>? ?? {};
        final aboutTitle = dataMap['about_title'] as String? ?? 'No Title';
        final about = dataMap['about'] as String? ?? 'No description available';
        final middleBannerLeft = dataMap['middle_banner_left'] as String? ?? 'https://via.placeholder.com/200';
        final middleBannerRight = dataMap['middle_banner_right'] as String? ?? 'https://via.placeholder.com/200';
        final offerDescriptionTitle = dataMap['offer_description_title'] as String? ?? 'No Title';
        final offerDescription = dataMap['offer_description'] as String? ?? 'No description available';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aboutTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      about,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      children: [
                        Expanded(
                          child: Image.network(
                            middleBannerLeft,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                          ),
                        ),
                        Expanded(
                          child: Image.network(
                            middleBannerRight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      offerDescriptionTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      offerDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}