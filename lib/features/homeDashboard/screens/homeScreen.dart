import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:discountzshop/features/authentication/login/screens/LoginScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/SearchResultsScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/WishlistScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/OfferCard.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/categoryGrid.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/firstSliderProvider.dart';
import '../providers/HomepageDataProvider.dart';
import '../providers/allCouponProvider.dart';
import 'widgets/CustomDrawer.dart';
import 'HomeScreenWidgets/home_sections.dart';
import 'HomeScreenWidgets/home_widgets.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final CarouselSliderController _carouselController = CarouselSliderController();
  final TextEditingController _searchController = TextEditingController();

  String userName = '';
  String membership = 'Silver Member';
  bool isLoggedIn = false;

  // Search State
  bool _isSearching = false;
  bool _isLoadingSearch = false;
  String _currentQuery = '';
  List<dynamic> _searchResults = [];
  String? _searchError;

  late Future<void> _fetchSlidersFuture;
  late Future<void> _fetchHomepageFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    final firstSliderProvider = Provider.of<FirstSliderProvider>(context, listen: false);
    final homepageProvider = Provider.of<HomepageProvider>(context, listen: false);

    _fetchSlidersFuture = firstSliderProvider.fetchSliders();
    _fetchHomepageFuture = homepageProvider.fetchHomepageData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final userData = jsonDecode(userString);
      setState(() {
        userName = userData['name'] ?? '';
        membership = userData['membership_type'] ?? 'Silver Member';
        isLoggedIn = true;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search term')),
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoadingSearch = true;
      _currentQuery = trimmed;
      _searchResults = [];
      _searchError = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.discountzshop.com/api/global-search?search=$trimmed'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data['status'] == 'success' ? (data['offer'] ?? []) : [];
        });
      } else {
        setState(() => _searchError = 'Failed to load results');
      }
    } catch (e) {
      setState(() => _searchError = 'No internet connection');
    } finally {
      setState(() => _isLoadingSearch = false);
    }
  }

  void _exitSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentQuery = '';
      _searchResults.clear();
      _searchError = null;
    });
  }

  Future<int> _getWishlistCount() async {
    final wishlist = await WishlistService.getWishlist();
    return wishlist.length;
  }

  void _onHeartIconTap() {
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WishlistScreen()),
      );
    }
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstSliderProvider = Provider.of<FirstSliderProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),

            Expanded(
              child: _isSearching
                  ? SearchResultsScreen(
                      query: _currentQuery,
                      results: _searchResults,
                      isLoading: _isLoadingSearch,
                      error: _searchError,
                      onBack: _exitSearch,
                    )
                  : _buildNormalHomepage(firstSliderProvider, couponProvider),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: TColors.primaryColor,
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ),
      title: isLoggedIn
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(membership, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            )
          : null,
      actions: isLoggedIn
          ? [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: () {
                  if (_searchController.text.trim().isNotEmpty) {
                    _performSearch(_searchController.text);
                  }
                },
              ),
              InkWell(
                onTap: _onHeartIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      const FaIcon(FontAwesomeIcons.heart, color: Colors.white, size: 26),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: FutureBuilder<int>(
                          future: _getWishlistCount(),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return count == 0
                                ? const SizedBox()
                                : CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      count > 99 ? '99+' : '$count',
                                      style: const TextStyle(fontSize: 9, color: Colors.white),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.heart, color: Colors.white),
                onPressed: _onHeartIconTap,
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
            ],
    );
  }

  // Updated Search Bar — Icon on Right + Triggers Search
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => _performSearch(value),
        decoration: InputDecoration(
          hintText: 'Search store here......',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: TColors.primaryColor, size: 28),
            onPressed: () {
              if (_searchController.text.trim().isNotEmpty) {
                _performSearch(_searchController.text);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNormalHomepage(FirstSliderProvider firstSliderProvider, CouponProvider couponProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isLoggedIn) UserCardWidget(userName: userName, membership: membership),

          TopCarouselSection(
            fetchSlidersFuture: _fetchSlidersFuture,
            firstSliderProvider: firstSliderProvider,
            currentIndex: _currentIndex,
            carouselController: _carouselController,
          ),

          const CategoryGrid(),

          AvailableCouponSection(couponProvider: couponProvider),

          const SizedBox(height: TSizes.spaceBtwItems),

          OfferBannerSection(fetchHomepageFuture: _fetchHomepageFuture),

          const SizedBox(height: TSizes.spaceBtwItems),

          DealsTabSection(
            dealsTabs: const ['Hot Deals', 'Cashback', 'Flat %', 'Buy 1 Get 1', 'Upto 50% Off', 'More'],
            activeTab: 0,
            onTabSelect: (index) {},
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          OfferSliderSection(fetchHomepageFuture: _fetchHomepageFuture),

          const SizedBox(height: TSizes.spaceBtwItems),

          DealsOfTheDaySection(
            dealsTabs: const ['Hot Deals', 'Cashback', 'Flat %', 'Buy 1 Get 1', 'Upto 50% Off', 'More'],
            activeTab: 0,
            onTabSelect: (index) {},
          ),

          BottomSliderSection(fetchHomepageFuture: _fetchHomepageFuture),

          const ProductShowcaseSection(),

          const PartnerBrandsSection(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}