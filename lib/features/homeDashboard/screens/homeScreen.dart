import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:discountzshop/features/authentication/login/screens/LoginScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/WishlistScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/AvaiableCouponWidget.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/wishlist_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../datamodels/HomepageDataModel.dart';
import '../providers/HomepageDataProvider.dart';
import '../providers/allCouponProvider.dart';
import 'widgets/DottedContainer.dart';
import 'package:discountzshop/features/homeDashboard/screens/widgets/categoryGrid.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:discountzshop/utils/helpers/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/firstSliderProvider.dart';

import 'dart:convert'; // For jsonDecode
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

// Import CustomDrawer
import './widgets/CustomDrawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //First slider
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late String userName = '';
  late String membership = 'Silver Member'; // Default to Silver Member
  bool isLoggedIn = false;

  // Track heart icon state (favorited or not)
  bool isFavorited = false;

  // Track active tabs for different sections
  int _activeDealsTab = 0;
  int _activeDealsOfTheDayTab = 0;

  // Tab names for both sections
  final List<String> _dealsTabs = [
    'Hot Deals',
    'Cashback',
    'Flat %',
    'Buy 1 Get 1',
    'Upto 50% Off',
    'More'
  ];

  Future<void>? _fetchSlidersFuture;
  late Future<void> _fetchHomepageFuture;
  late final homepageProvider;
  
  @override
  void initState() {
    super.initState();
    _clearOldWishlistData();
    final provider = Provider.of<FirstSliderProvider>(context, listen: false);
    homepageProvider = Provider.of<HomepageProvider>(context, listen: false);
    _fetchHomepageFuture = homepageProvider.fetchHomepageData();
    _fetchSlidersFuture = provider.fetchSliders();
    _loadUserData();
  }

  // ADD THIS METHOD INSIDE _HomeScreenState class
  Future<void> _clearOldWishlistData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorited_offers');
    await prefs.remove('favorited_offers_data');
    print("Old wishlist data cleared! You can now remove this function.");
  }

  void _showSearchDialog(BuildContext context) {
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    searchQuery = value;
                  },
                  onSubmitted: (value) {
                    _performSearch(value);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        _performSearch(searchQuery);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // Implement your search logic here
      print('Searching for: $query');
      // You can add navigation to search results page or filter functionality
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a search term'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Helper method to load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final userData = jsonDecode(userString);
      if (mounted) {
        setState(() {
          userName = userData['name'] ?? '';
          membership = userData['membership_type'] ?? 'Silver Member';
          isLoggedIn = true;
        });
      }
    }
  }

  // Handle heart icon tap
  void _onHeartIconTap() {
    if (!isLoggedIn) {
      // Show snackbar if user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not logged in'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Toggle favorite state
      setState(() {
        isFavorited = !isFavorited;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WishlistScreen(),
        ),
      );
    }
  }

  Future<int> _getWishlistCount() async {
    final wishlist = await WishlistService.getWishlist();
    return wishlist.length;
  }

  // Handle tab selection for Deals section
  void _selectDealsTab(int index) {
    setState(() {
      _activeDealsTab = index;
    });
    // You can add additional logic here to filter content based on selected tab
    print('Deals tab selected: ${_dealsTabs[index]}');
  }

  // Handle tab selection for Deals of the Day section
  void _selectDealsOfTheDayTab(int index) {
    setState(() {
      _activeDealsOfTheDayTab = index;
    });
    // You can add additional logic here to filter content based on selected tab
    print('Deals of the Day tab selected: ${_dealsTabs[index]}');
  }

  @override
  void dispose() {
    _currentIndex.dispose(); // FirstSlider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstSliderProvider =
        Provider.of<FirstSliderProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Scaffold(
      // Add drawer property
      drawer: const CustomDrawer(),
      appBar: 
      AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TColors.primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: TColors.white,
              size: 24,
            ),
          ),
        ),
        title: isLoggedIn
            ? Row(
                children: [
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(color: TColors.white, fontSize: 16),
                      ),
                      Text(
                        membership,
                        style: const TextStyle(color: TColors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
        titleSpacing: 0,
        actions: isLoggedIn
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _showSearchDialog(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.search,
                            color: TColors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4), // Gap between icons
                      InkWell(
                        onTap: _onHeartIconTap,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FaIcon(
                                isFavorited
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: TColors.white,
                                size: 24,
                              ),
                              Positioned(
                                top: -12,
                                right: -10,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: TColors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: 
                                  FutureBuilder<int>(
                                    future: _getWishlistCount(),
                                    builder: (context, snapshot) {
                                      final count = snapshot.data ?? 0;
                                      return Text(
                                        count > 9 ? '9+' : count.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]
            : [
                InkWell(
                  onTap: _onHeartIconTap,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: FaIcon(
                      FontAwesomeIcons.heart,
                      color: TColors.white,
                      size: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: TColors.white,
                    ),
                    child: Icon(
                      Icons.person_2_outlined,
                      color: TColors.primaryColor,
                    ),
                  ),
                ),
              ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Conditionally show Search Bar or User Card
                if (!isLoggedIn)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search store here...',
                        suffixIcon: Icon(Icons.search, color: TColors.darkGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: TColors.darkGrey),
                        ),
                        filled: true,
                        fillColor: TColors.white,
                      ),
                    ),
                  )
                else
                  _buildUserCard(),

                // --Top Carousel
                FutureBuilder<void>(
                  future: _fetchSlidersFuture, // Use stored future
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitThreeInOut(
                          color: TColors.primaryColor,
                          size: 18,
                        ),
                      );
                    } else if (snapshot.hasError ||
                        firstSliderProvider.error != null) {
                      return Center(
                          child: Text(
                              'Error: ${firstSliderProvider.error ?? snapshot.error}'));
                    } else if (firstSliderProvider.sliders.isEmpty) {
                      return const Center(child: Text('No sliders available'));
                    }

                    return Column(
                      children: [
                        CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              // Update the current index for the indicator
                              _currentIndex.value = index;
                            },
                          ),
                          items: firstSliderProvider.sliders.map((slider) {
                            return _buildBanner(slider.image);
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<int>(
                          valueListenable: _currentIndex,
                          builder: (context, currentIndex, child) {
                            return SmoothPageIndicator(
                              controller:
                                  PageController(initialPage: currentIndex),
                              // Still needed for animation
                              count: firstSliderProvider.sliders.length,
                              effect: const ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: TColors.primaryColor,
                                // Replace with TColors.primaryColor
                                dotColor: TColors.grey,
                                spacing: 8,
                              ),
                              onDotClicked: (index) {
                                // Navigate to the clicked page
                                _carouselController.animateToPage(index);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                // Categories
                const CategoryGrid(),

                // Available Coupon Search
                FutureBuilder<void>(
                  future: couponProvider.fetchCoupons(), // Trigger the fetch
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (couponProvider.errorMessage != null) {
                      return Center(child: Text(couponProvider.errorMessage!));
                    }
                    if (couponProvider.coupons.isEmpty) {
                      return const Center(child: Text('No coupons available'));
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: TColors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const CouponHeader(),
                          const SizedBox(height: TSizes.sm),
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: couponProvider.coupons.length,
                              itemBuilder: (context, index) {
                                final coupon = couponProvider.coupons[index];
                                // print("${coupon.badge} -- ${coupon.couponCode} -- ${coupon.logo}");
                                return _buildCoupon(
                                  coupon.badge,
                                  coupon.couponCode,
                                  coupon.logo,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                //Offer Banner
                FutureBuilder<void>(
                  future: _fetchHomepageFuture,
                  builder: (context, snapshot) {
                    final homepageProvider =
                        Provider.of<HomepageProvider>(context);

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (homepageProvider.errorMessage != null) {
                      return Center(
                          child: Text(homepageProvider.errorMessage!));
                    }
                    if (homepageProvider.homepageResponse == null) {
                      return const Center(child: Text('No homepage data available'));
                    }

                    final homepageData =
                        homepageProvider.homepageResponse!.homepageData;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(homepageData.offerBanner),
                          SizedBox(height: TSizes.sm ?? 8.0),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Deals Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: TColors.primaryColor.withOpacity(0.05),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: _dealsTabs.asMap().entries.map((entry) {
                            int index = entry.key;
                            String title = entry.value;
                            return _buildTab(
                              title, 
                              _activeDealsTab == index, 
                              () => _selectDealsTab(index)
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 230,
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 columns
                            crossAxisSpacing: 6.0, // Spacing between columns
                            mainAxisSpacing: 6.0, // Spacing between rows
                            childAspectRatio: 1.5, // Square cells
                          ),
                          itemCount: 9, // 2 rows * 3 columns = 6 items
                          itemBuilder: (context, index) {
                            return DottedCustomContainer(
                              imageString:
                                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Flogotyp.us%2Flogo%2Fbata%2F&psig=AOvVaw0fFHUJCuRup4-KP6zzon-v&ust=1748513889810000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCKjo6v33xY0DFQAAAAAdAAAAABAJ",
                              offerPercentage: "offerPercentage",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                FutureBuilder<void>(
                  future: _fetchHomepageFuture,
                  builder: (context, snapshot) {
                    final homepageProvider =
                        Provider.of<HomepageProvider>(context);

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (homepageProvider.errorMessage != null) {
                      return Center(
                          child: Text(homepageProvider.errorMessage!));
                    }
                    if (homepageProvider.homepageResponse == null) {
                      return const Center(child: Text('No homepage data available'));
                    }

                    final homepageData =
                        homepageProvider.homepageResponse!.homepageData;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Offer Slider (Carousel)
                          _buildOfferSlider(homepageData),
                          SizedBox(height: TSizes.sm ?? 8.0),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Deals of the Day
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    'Deals of the Day',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: _dealsTabs.asMap().entries.map((entry) {
                      int index = entry.key;
                      String title = entry.value;
                      return _buildTab(
                        title, 
                        _activeDealsOfTheDayTab == index, 
                        () => _selectDealsOfTheDayTab(index)
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  height: 280,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.sm),
                Container(
                  height: 280,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      _buildDeal('Flat 30% OFF', '25 April 2024',
                          'https://plus.unsplash.com/premium_photo-1674815329488-c4fc6bf4ced8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // BOTTOM BAR SLIDER
                FutureBuilder<void>(
                  future: _fetchHomepageFuture,
                  builder: (context, snapshot) {
                    final homepageProvider =
                        Provider.of<HomepageProvider>(context);

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (homepageProvider.errorMessage != null) {
                      return Center(
                          child: Text(homepageProvider.errorMessage!));
                    }
                    if (homepageProvider.homepageResponse == null) {
                      return const Center(child: Text('No homepage data available'));
                    }

                    final homepageData =
                        homepageProvider.homepageResponse!.homepageData;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bottom Banner Slider
                          _buildBottomSlider(homepageData),
                        ],
                      ),
                    );
                  },
                ),

                // => Currently Working
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFFEBFD),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 4,
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildProductHorizontal(
                              'Sytherine',
                              'Stylish cafe chair',
                              'BDT 2,500',
                              'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                            const SizedBox(height: 16),
                            _buildProductHorizontal(
                              'Sytherine',
                              'Stylish cafe chair',
                              'BDT 2,500',
                              'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Monitors
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyTBVZKemRyQpZxelXzx2NHgsF_IgLx3j_1w&s',
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyTBVZKemRyQpZxelXzx2NHgsF_IgLx3j_1w&s',
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyTBVZKemRyQpZxelXzx2NHgsF_IgLx3j_1w&s',
                        ),
                      ),
                    ],
                  ),
                ),

                // Belts
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlueAccent.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTV6VgPuMyIJlOK5goJCGjDS4NR4wxYyDNMmQ&s',
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://fabrilife.com/products/6505bbdf8f0c2-square.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 320,
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: _buildProduct(
                          'Sytherine',
                          'Stylish cafe chair',
                          'BDT 2,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkEFQeYkfSQ23-Dc92oeQI4abxDcrpRpHUYw&s',
                        ),
                      ),
                    ],
                  ),
                ),

                // Smarphones
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pinkAccent.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: _buildProduct(
                          'iPhone',
                          'iPhone 16 Pro Max',
                          'BDT 1,21,500',
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwnjRu2piR1q7hR_dy4OVQsuY2aPXU8rOhpg&s',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildProductHorizontal(
                              'Samsung',
                              'Samsung S25 Ultra 5g',
                              'BDT 1,22,000',
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Fz1YScUkysiCy8G54_iNRiKag6nGHxN__Q&s',
                            ),
                            const SizedBox(height: 16),
                            _buildProductHorizontal(
                              'Sytherine',
                              'Stylish cafe chair',
                              'BDT 2,500',
                              'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Partner Brands
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    'Partner Brands',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildPartnerBrand(
                          'https://e7.pngegg.com/pngimages/117/377/png-clipart-kfc-logo-kfc-icon-food-kentucky-fried-chicken.png'),
                      _buildPartnerBrand(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKw3Ssk8L6gEiq0L0kVMqVpcTxcJvLTR2Mnw&s'),
                      _buildPartnerBrand(
                          'https://bdtickets.com/images/logo-new-2.png'),
                      _buildPartnerBrand(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2r5G0CBdTUTOTURkzMYwhHmXl7lxilcK_Hw&s'),
                      _buildPartnerBrand(
                          'https://w7.pngwing.com/pngs/207/567/png-transparent-bata-hd-logo-thumbnail.png'),
                      _buildPartnerBrand(
                          'https://mir-s3-cdn-cf.behance.net/projects/404/38db8c139830717.Y3JvcCwxMDgwLDg0NCwwLDExNw.jpg'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add this package for date formatting

  Widget _buildUserCard() {
    // Dynamic expiry: today + 60 days
    final DateTime expiryDate = DateTime.now().add(const Duration(days: 60));
    final String formattedDate = DateFormat('dd MMM, yyyy').format(expiryDate);

    // Your actual data
    final int balancePoints = 2350;
    final int favoriteBrandsCount = 12;
    final int wishlistCount = 13;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row — Reduced size for "Your Balance Point"
          Row(
            children: [
              // Left: Your Balance Point — Smaller & Compact
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6), // Reduced from 8
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.wallet,
                      color: Colors.black87,
                      size: 18, // Reduced from 24
                    ),
                  ),
                  const SizedBox(width: 8), // Reduced from 12
                  Text(
                    'Your Balance Point',
                    style: TextStyle(
                      fontSize: 13,        // Reduced from 15
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right: Favorite Brands (kept as-is, looks good)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$favoriteBrandsCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Favorite Brands',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bottom Row — Points + Wishlist
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left: Big Points + Expiry
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$balancePoints',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Point',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Valid till $formattedDate',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right: Wishlist
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$wishlistCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your Wishlist',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(String imageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Set banner width to 90% of screen width, accounting for margins
    final bannerWidth = screenWidth * 0.8;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(right: 12.0),
      width: bannerWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildOfferSlider(HomepageData homepageData) {
    final sliderItems = [
      {
        'image': homepageData.offerSliderImageOne,
        'link': homepageData.offerSliderImageOneLink
      },
      {
        'image': homepageData.offerSliderImageTwo,
        'link': homepageData.offerSliderImageTwoLink
      },
      {
        'image': homepageData.offerSliderImageThree,
        'link': homepageData.offerSliderImageThreeLink
      },
      {
        'image': homepageData.offerSliderImageFour,
        'link': homepageData.offerSliderImageFourLink
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          aspectRatio: 2.0,
        ),
        items: sliderItems.map((item) {
          return GestureDetector(
            onTap: item['link'] != null
                ? () async {
                    final url = Uri.parse(item['link']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      print('Could not launch ${item['link']}');
                    }
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomSlider(HomepageData homepageData) {
    final sliderItems = [
      {
        'image': homepageData.bottomBannerSliderOne,
        'link': homepageData.bottomBannerSliderOneLink
      },
      {
        'image': homepageData.bottomBannerSliderTwo,
        'link': homepageData.bottomBannerSliderTwoLink
      },
      {
        'image': homepageData.bottomBannerSliderThree,
        'link': homepageData.bottomBannerSliderThreeLink
      },
      {
        'image': homepageData.bottomBannerSliderFour,
        'link': homepageData.bottomBannerSliderFourLink
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          aspectRatio: 2.0,
        ),
        items: sliderItems.map((item) {
          return GestureDetector(
            onTap: item['link'] != null
                ? () async {
                    final url = Uri.parse(item['link']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      print('Could not launch ${item['link']}');
                    }
                  }
                : null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderItem(String imageUrl, String link) {
    return GestureDetector(
      onTap: () => launchURL(link),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }

  void launchURL(String url) async {
    // Implement URL launching logic here (e.g., using url_launcher package)
    // For now, this is a placeholder
    print('Launching URL: $url');
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.orange,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCoupon(String discount, String code, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0XFFf3faff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TColors.info.withOpacity(0.5),
        ),
      ),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFFf4f4f5),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$discount Off",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    color: TColors.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Modified _buildTab to include onTap callback
  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
            side: BorderSide(
              color: isSelected ? TColors.primaryColor : TColors.grey,
            ),
          ),
          label: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isSelected ? TColors.primaryColor : TColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildFeaturedDeal(String title, String discount, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      width: 300,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 300,
              height: 200,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeal(String discount, String date, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.grey),
        color: const Color(0XFFf8f8f8),
      ),
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            discount,
            style: const TextStyle(
              color: TColors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Daraz Free Delivery Festival",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
                color: TColors.primaryColor.withOpacity(0.1),
                border:
                    Border.all(color: TColors.primaryColor.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.ticket_discount_copy, size: 18),
                const SizedBox(width: 5),
                Text(
                  'FREEDEL24',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColors.darkerGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Expires on: $date",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(
    String brand,
    String name,
    String price,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  brand,
                  style: const TextStyle(
                    color: TColors.darkerGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: TColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: TColors.darkerGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.black,
                    minimumSize: const Size(10, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHorizontal(String brand, String name, String price, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6EA), // Light pinkish background
        borderRadius: BorderRadius.circular(8),
      ),
      height: 180, // Increased height to accommodate content and avoid overflow
      // Fixed width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 60, // Image height
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
                children: [
                  Text(
                    brand,
                    style: const TextStyle(
                      color: Colors.black, // High contrast
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.black,
                      minimumSize: const Size(10, 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerBrand(String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}