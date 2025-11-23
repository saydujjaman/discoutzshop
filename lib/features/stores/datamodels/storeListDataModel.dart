class StoreListDataModel {
  final int id;
  final String? title;
  final String? slug;
  final String? addressLineOne;
  final String? addressLineTwo;
  final String? logo;
  final String? location;
  final String? description;
  final String? url;
  final String? category;
  final String? brandSlug;
  final String? brand;
  final String? country;
  final String? division;
  final String? city;
  final String? area;

  StoreListDataModel({
    required this.id,
    this.title,
    this.slug,
    this.addressLineOne,
    this.addressLineTwo,
    this.logo,
    this.location,
    this.description,
    this.url,
    this.category,
    this.brandSlug,
    this.brand,
    this.country,
    this.division,
    this.city,
    this.area,
  });

  factory StoreListDataModel.fromJson(Map<String, dynamic> json) {
    return StoreListDataModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      addressLineOne: json['address_line_one'] ?? '',
      addressLineTwo: json['address_line_two'] ?? '',
      logo: json['logo'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      category: json['category'] ?? '',
      brandSlug: json['brand_slug'] ?? '',
      brand: json['brand'] ?? '',
      country: json['country'] ?? '',
      division: json['division'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
    );
  }
}