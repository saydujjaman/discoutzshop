import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/constants/colors.dart';

class CouponHeader extends StatefulWidget {
  const CouponHeader({super.key});

  @override
  _CouponHeaderState createState() => _CouponHeaderState();
}

class _CouponHeaderState extends State<CouponHeader> {
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Row(
        children: [
          const Text(
            "Available Coupon",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Replace with TColors.textColor if defined
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            Iconsax.ticket_discount,
            color: TColors.primaryColor, // Replace with TColors.primaryColor
            size: 28,
          ),
          const SizedBox(width: 5),
          Spacer(),
          IconButton(
            icon: const Icon(
              Iconsax.search_normal_copy,
              color: TColors.primaryColor, // Replace with TColors.primaryColor
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _isSearchActive = true;
              });
            },
          ),
        ],
      ),
      secondChild: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search Coupon Code",
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: const Icon(Iconsax.close_circle, color: Colors.grey),
            onPressed: () {
              setState(() {
                _isSearchActive = false;
                _searchController.clear();
              });
            },
          ),
        ),
        onChanged: (value) {
          // Add search logic here, e.g., filter coupons based on value
        },
      ),
      crossFadeState: _isSearchActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}