import 'package:discountzshop/features/brands/screens/BrandsOfferStoreTab.dart';
import 'package:discountzshop/features/offers/screens/Widgets/OffersListScreen.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import './Widgets/offers_tab.dart';
import './Widgets/overview_tab.dart';
import './Widgets/stores_tab.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String slug;

  const OfferDetailsScreen({
    required this.slug,
    super.key,
  });

  @override
  _OfferDetailsScreenState createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = ['Overview', 'Stores', 'Offers', 'All Offers'];

  @override
  void initState() {
    super.initState();
    // Always start on "Offers" tab (index 2)
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 2, // This forces "Offers" tab to be active by default
    );
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_tabTitles[_tabController.index]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: TColors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(64.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: TColors.black,
              indicator: BoxDecoration(
                color: TColors.primaryColor,
                borderRadius: BorderRadius.circular(64.0),
              ),
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: -10.0),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Stores'),
                Tab(text: 'Offers'),
                Tab(text: 'All Offers'),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OverviewTab(slug: widget.slug),
                StoresTab(slug: widget.slug),
                OffersTab(slug: widget.slug),
                OffersListScreen(slug: widget.slug),
              ],
            ),
          ),
        ],
      ),
    );
  }
}