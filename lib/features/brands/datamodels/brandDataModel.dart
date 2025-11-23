class BrandDetailsDataModel {
  final int id;
  final List<int>? countryId;
  final List<int>? divisionId;
  final List<int>? cityId;
  final List<int>? areaId;
  final int? categoryId;
  final String? name;
  final int? addedBy;
  final String? headquarter;
  final String? slug;
  final String? logo;
  final String? image;
  final String? bannerImage;
  final String? middleBannerLeft;
  final String? middleBannerRight;
  final String? mapUrl;
  final String? aboutTitle;
  final String? about;
  final String? offerDescriptionTitle;
  final String? offerDescription;

  BrandDetailsDataModel({
    required this.id,
    this.countryId,
    this.divisionId,
    this.cityId,
    this.areaId,
    this.categoryId,
    this.name,
    this.addedBy,
    this.headquarter,
    this.slug,
    this.logo,
    this.image,
    this.bannerImage,
    this.middleBannerLeft,
    this.middleBannerRight,
    this.mapUrl,
    this.aboutTitle,
    this.about,
    this.offerDescriptionTitle,
    this.offerDescription,
  });

  factory BrandDetailsDataModel.fromJson(Map<String, dynamic> json) {
    // Helper function to convert dynamic value to int
    int? convertToInt(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        return int.tryParse(value) ?? 0; // Convert string to int, default to 0 if invalid
      }
      return value as int?; // Assume it's already an int if not a string
    }

    // Helper function to convert dynamic value to int list
    List<int>? convertToIntList(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        return [int.tryParse(value) ?? 0]; // Convert string to single-item list
      } else if (value is List) {
        return (value as List<dynamic>).map((e) => int.tryParse(e.toString()) ?? 0).toList();
      }
      return null;
    }

    return BrandDetailsDataModel(
      id: convertToInt(json['id']) ?? 0, // Required, default to 0 if null
      countryId: convertToIntList(json['country_id']),
      divisionId: convertToIntList(json['division_id']),
      cityId: convertToIntList(json['city_id']),
      areaId: convertToIntList(json['area_id']),
      categoryId: convertToInt(json['category_id']),
      name: json['name'],
      addedBy: convertToInt(json['added_by']),
      headquarter: json['headquarter'],
      slug: json['slug'],
      logo: json['logo'],
      image: json['image'],
      bannerImage: json['banner_image'],
      middleBannerLeft: json['middle_banner_left'],
      middleBannerRight: json['middle_banner_right'],
      mapUrl: json['map_url'],
      aboutTitle: json['about_title'],
      about: json['about'],
      offerDescriptionTitle: json['offer_description_title'],
      offerDescription: json['offer_description'],
    );
  }
}