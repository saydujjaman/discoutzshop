import 'package:discountzshop/features/brands/screens/brandsScreen.dart';
import 'package:discountzshop/features/maps/screens/mapsScreen.dart';
import 'package:discountzshop/features/offers/screens/offerScreen.dart';
import 'package:discountzshop/features/stores/screens/storesScreen.dart';
import 'package:discountzshop/features/homeDashboard/screens/homeScreen.dart';
import 'package:discountzshop/utils/constants/colors.dart';
import 'package:discountzshop/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedMobileIndex = 0;

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunction.isDarkMode(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _onWillPop();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            child: _getSelectedMobileScreen(_selectedMobileIndex),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: darkMode ? Colors.black : Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Iconsax.home_copy, "Home", 0),
              _buildNavItem(Iconsax.discount_circle_copy, "Offers", 1),
              // _buildNavItem(Iconsax.location_copy, "Maps", 2, isMaps: true),
              const SizedBox(width: 20),
              _buildNavItem(Iconsax.tag_copy, "Brands", 3),
              _buildNavItem(Iconsax.shop_copy, "Stores", 4),
            ],
          ),
        ),
        floatingActionButton: ClipOval(
          child: Container(
            padding: EdgeInsets.all(6),
            color: Colors.white,
            child: Material(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
              color: TColors.primaryColor,
              child: InkWell(
                onTap: ()=> _onItemTapped(2),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Iconsax.location_copy,size: 28,color: Colors.white,),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isMaps = false}) {
    final darkMode = THelperFunction.isDarkMode(context);
    final isSelected = _selectedMobileIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMaps && isSelected)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: darkMode ? TColors.white.withOpacity(0.3) : TColors.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: darkMode ? TColors.white : TColors.primaryColor),
            )
          else
            Icon(icon, color: isSelected ? (darkMode ? TColors.white : TColors.primaryColor) : null),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? (darkMode ? TColors.white : TColors.primaryColor) : null,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedMobileIndex == 0) {
      final shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    } else {
      setState(() {
        _selectedMobileIndex = 0;
      });
      return false;
    }
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedMobileIndex != 0) {
      _selectedMobileIndex = 0;
    }
    setState(() {
      _selectedMobileIndex = index;
    });
  }

  Widget _getSelectedMobileScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return OfferScreen();
      case 2:
        return MapLocationScreen();
      case 3:
        return BrandsScreen();
      case 4:
        return StoresScreen();
      default:
        return const Text('Select a screen');
    }
  }
}
