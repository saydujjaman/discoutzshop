import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/brandDetailsProvider.dart';
import 'BrandsOfferTab.dart';
import 'BrandsOverviewTab.dart';
import 'BrandsOfferStoreTab.dart';

class BrandDetailsScreen extends StatefulWidget {
  final String slug;
  final int initialTab; // 0 for Overview, 1 for Stores, 2 for Offers

  const BrandDetailsScreen(
      {super.key, required this.slug, this.initialTab = 0});

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _initialTab;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    _tabController.addListener(_handleTabChange);
    _initialTab = widget.initialTab;
    _initializeData();
  }

  void _initializeData() {
    final provider = context.read<BrandDetailsProvider>();
    print("Initializing data for slug: ${widget.slug}");
    provider.loadBrandData(widget.slug); // Trigger the data load
  }

  void _handleTabChange() {
    if (_tabController.index != _initialTab) {
      setState(() {
        _initialTab = _tabController.index;
      });
      _initializeData();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrandDetailsProvider(),
      child: Builder(
        builder: (context) {
          final provider =
              Provider.of<BrandDetailsProvider>(context, listen: false);
          return FutureBuilder<void>(
            future: provider.loadBrandData(widget.slug),
            // Use the future from the provider
            builder: (context, snapshot) {
              print(
                  "FutureBuilder state: ${snapshot.connectionState}, error: ${snapshot.error}, data: , isLoading: ${provider.isLoading}, brand: ${provider.getBrand(widget.slug)}");
              if (snapshot.connectionState == ConnectionState.waiting ||
                  provider.isLoading) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError || provider.error != null) {
                return Scaffold(
                    body: Center(
                        child: Text(
                            'Error: ${provider.error ?? snapshot.error}')));
              }

              final brand = provider.getBrand(widget.slug);
              if (brand == null) {
                return const Scaffold(
                    body: Center(child: Text('Brand not found')));
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(_tabController.index == 0
                      ? 'Overview'
                      : _tabController.index == 1
                          ? 'Stores'
                          : 'Offers'),
                  centerTitle: true,
                  actions: [
                    IconButton(icon: const Icon(Icons.search), onPressed: () {})
                  ],
                ),
                body: Column(
                  children: [
                    SizedBox(
                      height: 190, // Adjust based on how much you want the logo to overlap
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Banner Image
                          Container(
                            width: double.infinity,
                            height: 150,
                            child: Image.network(
                              brand.bannerImage ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[300]),
                            ),
                          ),

                          // Logo Positioned
                          Positioned(
                            top: 110, // Adjust this to control overlap
                            left: 16,
                            child: Visibility(
                              visible: brand.logo != null,
                              child: Card(
                                elevation: 6,
                                color: TColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    brand.logo!,
                                    width: 60,
                                    height: 60, // Adjust size if needed
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Container(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: TColors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(64.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: TColors.black,
                        indicator: BoxDecoration(
                          color: TColors.primaryColor,
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        indicatorPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: -20),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Stores'),
                          Tab(text: 'Offers'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          BrandsOverviewTab(slug: widget.slug),
                          BrandsOfferStoreTab(slug: widget.slug),
                          BrandsOfferTab(slug: widget.slug),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
