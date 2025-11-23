import 'package:discountzshop/features/authentication/login/screens/LoginScreen.dart';
import 'package:discountzshop/features/homeDashboard/providers/firstSliderProvider.dart';
import 'package:discountzshop/navigation_menu.dart';
import 'package:discountzshop/features/homeDashboard/screens/homeScreen.dart';
import 'package:discountzshop/screens/welcomeScreen.dart';
import 'package:discountzshop/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/brands/Providers/BrandsProvider.dart';
import 'features/brands/Providers/brandDetailsProvider.dart';
import 'features/homeDashboard/providers/HomepageDataProvider.dart';
import 'features/homeDashboard/providers/allCouponProvider.dart';
import 'features/homeDashboard/providers/categoriesProvider.dart';
import 'features/homeDashboard/providers/categoryDetailsProvider.dart';
import 'features/offers/providers/OfferDetailsProvider.dart';
import 'features/offers/providers/offerProvider.dart';
import 'features/stores/providers/storeListProvider.dart';

void main() {
  runApp(const DiscountZShop());
}

class DiscountZShop extends StatelessWidget {
  const DiscountZShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirstSliderProvider>(create: (_) => FirstSliderProvider()),
        ChangeNotifierProvider<CouponProvider>(create: (_) => CouponProvider()),
        ChangeNotifierProvider<HomepageProvider>(create: (_) => HomepageProvider()),
        ChangeNotifierProvider<BrandProvider>(create: (_) => BrandProvider()),
        ChangeNotifierProvider<OfferProvider>(create: (_) => OfferProvider()),
        ChangeNotifierProvider<BrandDetailsProvider>(create: (_) => BrandDetailsProvider()),
        ChangeNotifierProvider<OfferDetailsProvider>(create: (_) => OfferDetailsProvider()),
        ChangeNotifierProvider<StoreListProvider>(create: (_) => StoreListProvider()),
        ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
        ChangeNotifierProvider<CategoryDetailsProvider>(create: (_) => CategoryDetailsProvider()),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        home:/*LoginScreen()*/NavigationMenu(),
        theme: TAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

