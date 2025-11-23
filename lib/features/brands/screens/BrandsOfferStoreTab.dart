/*
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class StoresTab extends StatefulWidget {
  @override
  _StoresTabState createState() => _StoresTabState();
}

class _StoresTabState extends State<StoresTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store List
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text('Oraimo Brand Shop, Bashundhara city shopping complex'),
                  subtitle: Text('BASEMENT #01 SHOP #76, Bashundhara City, Shopping Complex, DHAKA 1215, 017/281/8361'),
                ),
                Divider(),
                ListTile(
                  title: Text('Oraimo Brand Shop'),
                  subtitle: Text('LEVEL-04, SHOP NO-4C-20/A3, JAMUNA FUTURE PARK, DHAKA 1229 01310230969'),
                ),
                Divider(),
                ListTile(
                  title: Text('Oraimo Brand Shop, Mirpur 1'),
                  subtitle: Text('SHOP NO-1/9, 1ST FLOOR, CAPITAL TOWER, SHOPPING COMPLEX BUS STAND, DHAKA 1216, 01762181123'),
                ),
                Divider(),
                ListTile(
                  title: Text('Oraimo Brand Shop Mirpur 10'),
                  subtitle: Text('SHOP#46, 2ND FLOOR, SHAH ALI PLAZA, MIRPUR 10 ROUNDOUT, DHAKA 1216, 01324536753'),
                ),
                Divider(),
                SizedBox(height: TSizes.spaceBtwItems),
                // Map Placeholder
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text('Map Placeholder')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*//*

import 'package:discountzshop/features/brands/Providers/brandDetailsProvider.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/BrandsProvider.dart';

class OfferStoreTab extends StatelessWidget {
  final String slug;

  const OfferStoreTab({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandDetailsProvider>();
    final stores = provider.getStores(slug);

    if (provider.isLoading && stores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(store.title ?? 'Store'),
            subtitle: Text('${store.addressLineOne}\n${store.addressLineTwo ?? ''}'),
            trailing: store.url != null ? const Icon(Icons.map) : null,
            onTap: store.url != null ? () {} : null,
          ),
        );
      },
    );
  }
}*/

import 'package:discountzshop/features/brands/Providers/brandDetailsProvider.dart';
import 'package:discountzshop/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandsOfferStoreTab extends StatelessWidget {
  final String slug;

  const BrandsOfferStoreTab({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandDetailsProvider>();
    final stores = provider.getStores(slug);

    if (provider.isLoading && stores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(store.title ?? 'Store'),
            subtitle: Text('${store.addressLineOne}\n${store.addressLineTwo ?? ''}'),
            trailing: store.url != null ? const Icon(Icons.map) : null,
            onTap: store.url != null
                ? () => _openGoogleMaps(context, store.url!)
                : null,
          ),
        );
      },
    );
  }

  Future<void> _openGoogleMaps(BuildContext context, String iframeHtml) async {
    // Extract the src attribute from the iframe
    final mapUrl = _extractIframeSrc(iframeHtml);
    if (mapUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid map URL')),
      );
      return;
    }

    final uri = Uri.parse(mapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  String? _extractIframeSrc(String iframeHtml) {
    final regex = RegExp(r'src="([^"]*)"');
    final match = regex.firstMatch(iframeHtml);
    return match?.group(1);
  }
}