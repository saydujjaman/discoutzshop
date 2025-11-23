// screens/BrandsScreen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/colors.dart';
import '../Providers/BrandsProvider.dart';
import '../datamodels/BrandsDataModel.dart';
import 'BrandsDetailsMainScreen.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrandProvider(),
      child: Scaffold(
        appBar: 
        AppBar(
          title: const Text("Brands"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.search),
            ),
          ],
        ),
      
      
      
      
        body: Consumer<BrandProvider>(
          builder: (context, provider, child) {
            return FutureBuilder(
              future: provider.initialFetch,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    provider.brandsByCategory.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!provider.isLoading &&
                        provider.hasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      provider.loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: provider.refresh,
                    child: ListView(
                      children: [
                        // Banner
                        Image.network(
                          'https://discountzshop.com/storage/pagebanner/image/pZqnWzipzm1726390129.jpg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: 160,
                          errorBuilder: (_, __, ___) => Container(
                            height: 160,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 80),
                          ),
                        ),

                        // Categories & Brands
                        ...provider.brandsByCategory.entries.map((entry) {
                          return _buildSection(
                            context: context,
                            title: entry.key,
                            brands: entry.value,
                          );
                        }),

                        if (provider.isLoading && provider.brandsByCategory.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        if (!provider.hasMore && provider.brandsByCategory.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: Text("No more brands")),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Brands> brands,
  }) {
    if (brands.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 2, color: TColors.primaryColor),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return GestureDetector(
                onTap: () {
                  if (brand.slug == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrandDetailsScreen(
                        initialTab: 0,
                        slug: brand.slug!,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      brand.logo ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.branding_watermark,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}