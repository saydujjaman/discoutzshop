import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../api/apiController.dart';
class OffersTab extends StatefulWidget {
  final String slug;

  const OffersTab({required this.slug, super.key});

  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _fetchOfferDetails();
  }

  Future<Map<String, dynamic>> _fetchOfferDetails() async {
    final apiController = ApiController();
    return await apiController.fetchElaborateOfferDetails(widget.slug);
  }

  String _calculateDaysLeft(String? expiryDate) {
    if (expiryDate == null) return "No expiry date";
    final expiry = DateTime.parse(expiryDate);
    final now = DateTime.now();
    final difference = expiry.difference(now);
    if (difference.isNegative) return "Expired";
    return "${difference.inDays} days left";
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL')),
      );
      return;
    }

    String urlToLaunch = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      urlToLaunch = 'https://$url';
    }

    final Uri uri = Uri.parse(urlToLaunch);

    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('No data available: ${snapshot.error}'));
        }

        final data = snapshot.data!;
        final brand = data['brand'] as Map<String, dynamic>;
        final offer = data['offer'] as Map<String, dynamic>;

        final bannerImage = brand['banner_image'] as String? ?? 'https://via.placeholder.com/400x150';
        final shortDescription = offer['short_description'] as String? ?? 'No description available';
        final expiryDate = offer['expiry_date'] as String?;
        final sourceUrl = offer['source_url'] as String?;

        return SingleChildScrollView(
          child: Column(
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
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(
                  offer['image'] as String? ?? 'https://via.placeholder.com/100',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${offer['badge'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          offer['name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          offer['price']?.toStringAsFixed(2) ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Offer Price: ${offer['offer_price']?.toStringAsFixed(2) ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          shortDescription,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Expiry: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(expiryDate ?? DateTime.now().toIso8601String()))}',
                          style: const TextStyle(fontSize: 12, color: TColors.darkGrey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _calculateDaysLeft(expiryDate),
                          style: const TextStyle(fontSize: 12, color: TColors.primaryColor),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _launchURL(sourceUrl),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'See Offers',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}