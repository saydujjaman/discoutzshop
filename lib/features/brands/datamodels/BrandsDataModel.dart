// class Brands {
//   final int id;
//   final String? name;
//   final String? slug;
//   final String? logo;
//   final String? image;
//   final String? bannerImage;
//   final String? mapUrl;
//   final String? aboutTitle;
//   final String? about;
//   final String? offerDescriptionTitle;
//   final String? offerDescription;
//   final String? url;
//   final String? categoryType;
//   final String? status;
//   final String? categoryName;
//   final String? headquarter;
//   final List<String> countries;
//   final List<String> divisions;
//   final List<String> cities;
//   final List<String> areas;
//   final String? addedByName;

//   Brands({
//     required this.id,
//     this.name,
//     this.slug,
//     this.logo,
//     this.image,
//     this.bannerImage,
//     this.mapUrl,
//     this.aboutTitle,
//     this.about,
//     this.offerDescriptionTitle,
//     this.offerDescription,
//     this.url,
//     this.categoryType,
//     this.status,
//     this.categoryName,
//     this.headquarter,
//     this.countries = const [],
//     this.divisions = const [],
//     this.cities = const [],
//     this.areas = const [],
//     this.addedByName,
//   });

//   factory Brands.fromJson(Map<String, dynamic> json) {
//     return Brands(
//       id: json['id'] ?? 0, // Default to 0 if null, though id should not be null
//       name: json['name']?.toString() ?? '',
//       slug: json['slug']?.toString() ?? '',
//       logo: json['logo']?.toString() ?? '',
//       image: json['image']?.toString() ?? '',
//       bannerImage: json['banner_image']?.toString() ?? '',
//       mapUrl: json['map_url']?.toString(),
//       aboutTitle: json['about_title']?.toString() ?? '',
//       about: json['about']?.toString() ?? '',
//       offerDescriptionTitle: json['offer_description_title']?.toString() ?? '',
//       offerDescription: json['offer_description']?.toString() ?? '',
//       url: json['url']?.toString() ?? '',
//       categoryType: json['category_type']?.toString() ?? '',
//       status: json['status']?.toString() ?? '',
//       categoryName: json['category_name']?.toString() ?? '',
//       headquarter: json['headquarter']?.toString() ?? '',
//       countries: (json['countries'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       divisions: (json['divisions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       cities: (json['cities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       areas: (json['areas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       addedByName: json['added_by_name']?.toString() ?? '',
//     );
//   }
// }

// datamodels/BrandsDataModel.dart
class Brands {
  final int id;
  final String? name;
  final String? slug;
  final String? logo;
  final String? categoryName;

  Brands({
    required this.id,
    this.name,
    this.slug,
    this.logo,
    this.categoryName,
  });

  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(
      id: json['id'] as int,
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      logo: json['logo']?.toString(),
      categoryName: json['category_name']?.toString(),
    );
  }
}