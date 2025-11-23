import 'package:carousel_slider/carousel_slider.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../homeDashboard/providers/firstSliderProvider.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  //First slider
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  Future<void>? _fetchSlidersFuture;

  @override
  Widget build(BuildContext context) {
    final firstSliderProvider =
        Provider.of<FirstSliderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFFF15A2E), // #f15a2e
                      Color(0xFFF15B2F), // #f15b2f
                      Color(0xFFF36237), // #f36237
                      Color(0xFFF8754C), // #f8754c
                      Color(0xFFFF9875), // #ff9875
                      Color(0xFFFFC8B2), // #ffc8b2
                      Color(0xFFFFE8DE), // #ffe8de
                      Color(0xFFFFF8F5), // #fff8f5
                      Color(0xFFFFFEFE), // #fffefe
                      Color(0xFFFFFFFF),
                    ],
                  ),
                ), // Exact red color from the image
                child: Column(
                  children: [
                    // SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 30,
                              ), // Placeholder for profile picture
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jaydon Lipshutz',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Gold Member',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Iconsax.search_normal,
                              color: Colors.white,
                              // size: 28,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Iconsax.notification,
                              color: Colors.white,
                              // size: 28,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: TColors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.wallet_2,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Your Balance Point",
                                    style: TextStyle(color: TColors.darkGrey),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '2350 Point',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Valid till 30 Jun 2021',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        color: TColors.primaryColor
                                            .withOpacity(0.1)),
                                    child: Icon(
                                      Icons.bookmark_add_outlined,
                                      color: TColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '12',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Favourite brands',
                                        style: TextStyle(
                                          color: TColors.darkGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: TColors.darkerGrey,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        color: TColors.primaryColor
                                            .withOpacity(0.1)),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: TColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '13',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Yout Wishlist',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Points and Wishlist Section

              // Super Deals Section
              SizedBox(height: TSizes.spaceBtwItems),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: TColors.primaryColor.withOpacity(0.5)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[TColors.white, TColors.primaryColor],
                    // Gradient from https://learnui.design/tools/gradient-generator.html
                    tileMode: TileMode.mirror,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.flash, color: TColors.primaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Super Deals',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: TColors.white,
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Check',
                          style: TextStyle(
                            color: TColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Trending Now Section
              SizedBox(height: TSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFFFF3D00),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildTrendingCard(
                        'https://images.unsplash.com/photo-1629198688000-71f23e745b6e?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    _buildTrendingCard(
                        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    _buildTrendingCard(
                        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                  ],
                ),
              ),
              // Browse by Category Section
              SizedBox(height: TSizes.spaceBtwItems),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: TColors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Browse by Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFFFF3D00),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryItem(Icons.watch, 'Watches & Jewels'),
                        _buildCategoryItem(Icons.chair, 'Home & Decor'),
                        _buildCategoryItem(
                            Icons.electrical_services, 'Electronics & Gadgets'),
                        _buildCategoryItem(
                            Icons.face_retouching_natural, 'Beauty & Care'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              // BANNER
              FutureBuilder<void>(
                future: _fetchSlidersFuture, // Use stored future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitThreeInOut(
                        color: TColors.primaryColor,
                        // Replace with TColors.primaryColor if defined
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
                          height: 100,
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
                            effect: ExpandingDotsEffect(
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
              SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCard(String imageUrl) {
    return Container(
      margin: EdgeInsets.only(right: 12.0),
      width: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              64.0,
            ),
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFFFF3D00),
              size: 30,
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(String imageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Set banner width to 90% of screen width, accounting for margins
    final bannerWidth = screenWidth * 0.8;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(right: 12.0),
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
}
