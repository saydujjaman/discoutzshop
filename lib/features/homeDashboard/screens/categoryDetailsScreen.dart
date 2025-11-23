import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/colors.dart';
import '../providers/categoryDetailsProvider.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String slug;

  const CategoryDetailsScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryDetailsProvider()..fetchCategoryDetails(slug),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category Details'),
        ),
        body: Consumer<CategoryDetailsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }

            if (provider.categoryDetails == null) {
              return const Center(child: Text('No data available'));
            }

            final details = provider.categoryDetails!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Banner
                  Image.network(
                    details.category.bannerImage ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, url, error) => Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: Text(
                          details.category.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.category.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        // Brands Section
                        Text(
                          'Brands',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        details.brands.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No brands available for this category',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: details.brands.length,
                                  itemBuilder: (context, index) {
                                    final brand = details.brands[index];
                                    return Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                brand.logo ?? '',
                                                fit: BoxFit.contain,
                                                height: 50,
                                                width: 50,
                                                errorBuilder:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error_outline,
                                                  color: TColors.primaryColor,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            brand.name ?? 'Unnamed Brand',
                                            maxLines: 2,
                                            softWrap: true,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 16),
                        // Offers Section
                        Text(
                          'Offers',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        details.offers.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No offers available for this category',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: details.offers.length,
                                itemBuilder: (context, index) {
                                  final offer = details.offers[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Image.network(
                                        offer.image ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: TColors.primaryColor,
                                          size: 30.0,
                                        ),
                                      ),
                                      title:
                                          Text(offer.name ?? 'Unnamed Offer'),
                                      subtitle: Text(offer.badge ?? ''),
                                      trailing:
                                          Text(offer.brand ?? 'Unknown Brand'),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
