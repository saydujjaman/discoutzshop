import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/colors.dart';
import '../../datamodels/categoriesDataModel.dart';
import '../../providers/categoriesProvider.dart';
import '../categoryDetailsScreen.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    // Fetch categories when widget is initialized
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        final displayedCategories = _showAll
            ? provider.categories
            : provider.categories.take(8).toList();

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: displayedCategories
                    .map((category) => _buildCategoryItem(context, category))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _showAll
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _showAll = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: TColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      child: const Text(
                        'Collapse',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : (provider.categories.length > 8
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _showAll = true;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: TColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64.0),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: const Text(
                            'See More',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, CategoriesDataModel category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(slug: category.slug),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 2,
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64.0)),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(
                category.logo,
                width: 30.0,
                height: 30.0,
                fit: BoxFit.contain,
                // placeholder: (context, url) => const CircularProgressIndicator(),
                errorBuilder: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: TColors.primaryColor,
                  size: 30.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
