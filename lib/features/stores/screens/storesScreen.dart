import 'package:discountzshop/features/stores/datamodels/storeListDataModel.dart';
import 'package:discountzshop/features/stores/providers/storeListProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../brands/screens/BrandsDetailsMainScreen.dart';

class StoresScreen extends StatefulWidget {
  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final ScrollController _scrollController = ScrollController();
  late StoreListProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = StoreListProvider();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.fetchStores();
    });

    // Handle pagination on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_provider.isLoading &&
          _provider.hasMore) {
        _provider.fetchStores();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconHeight = screenWidth * 0.2;

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final provider = Provider.of<StoreListProvider>(context);

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALL STORES',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.filter_list, size: 16),
                              label: Text('Filter'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.orange),
                                foregroundColor: Colors.orange,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.search, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Grid of Stores
                  Expanded(
                    child: AnimatedBuilder(
                      animation: provider,
                      builder: (context, child) {
                        if (provider.isLoading && provider.stores.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (provider.stores.isEmpty && !provider.isLoading) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 48),
                                SizedBox(height: 16),
                                Text(
                                  'Failed to load stores or no stores found.',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    provider.reset();
                                    provider.fetchStores();
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          itemCount: provider.stores.length + (provider.isLoading ? 1 : 0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= provider.stores.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final store = provider.stores[index];
                            return StoreCard(
                              store: store,
                              imageHeight: iconHeight,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final StoreListDataModel store;
  final double imageHeight;

  const StoreCard({
    required this.store,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandDetailsScreen(slug: store.brandSlug ?? '',initialTab: 1,),
          ),
        );
      },
      child: Card(
        color: Color(0xFFFFF5F0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.store,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Image.network(
                  store.logo ?? '',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 16),
              Text(
                store.title ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.area ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}