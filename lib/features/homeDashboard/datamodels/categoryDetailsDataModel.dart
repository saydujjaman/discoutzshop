class CategoryDetailsDataModel {
  final Category category;
  final List<CategoryBrand> brands;
  final List<CategoryOffer> offers;

  CategoryDetailsDataModel({
    required this.category,
    required this.brands,
    required this.offers,
  });

  factory CategoryDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsDataModel(
      category: Category.fromJson(json['category']),
      brands: (json['brands'] as List)
          .map((brand) => CategoryBrand.fromJson(brand))
          .toList(),
      offers: (json['offers'] as List)
          .map((offer) => CategoryOffer.fromJson(offer))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String? logo;
  final String? image;
  final String? bannerImage;
  final String? description;

  Category({
    required this.id,
    required this.parentId,
    required this.name,
    required this.slug,
    this.logo,
    this.image,
    this.bannerImage,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      slug: json['slug'],
      logo: json['logo'],
      image: json['image'],
      bannerImage: json['banner_image'],
      description: json['description'],
    );
  }
}

class CategoryBrand {
  final int id;
  final String? name;
  final String? headquarter;
  final String slug;
  final String? logo;
  final String? image;
  final String? mapUrl;
  final String? category;
  final String? createdAt;
  final String? updatedAt;
  final List<String> countries;
  final List<String> divisions;
  final List<String> cities;
  final List<String> areas;

  CategoryBrand({
    required this.id,
    this.name,
    this.headquarter,
    required this.slug,
    this.logo,
    this.image,
    this.mapUrl,
    this.category,
    this.createdAt,
    this.updatedAt,
    required this.countries,
    required this.divisions,
    required this.cities,
    required this.areas,
  });

  factory CategoryBrand.fromJson(Map<String, dynamic> json) {
    return CategoryBrand(
      id: json['id'],
      name: json['name'],
      headquarter: json['headquarter'],
      slug: json['slug'],
      logo: json['logo'],
      image: json['image'],
      mapUrl: json['map_url'],
      category: json['category'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      countries: List<String>.from(json['countries'] ?? []),
      divisions: List<String>.from(json['divisions'] ?? []),
      cities: List<String>.from(json['cities'] ?? []),
      areas: List<String>.from(json['areas'] ?? []),
    );
  }
}

class CategoryOffer {
  final int id;
  final String? badge;
  final String? name;
  final String slug;
  final String? logo;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final String? country;
  final String? division;
  final String? city;
  final String? area;
  final String? brand;
  final String? category;

  CategoryOffer({
    required this.id,
    this.badge,
    this.name,
    required this.slug,
    this.logo,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.country,
    this.division,
    this.city,
    this.area,
    this.brand,
    this.category,
  });

  factory CategoryOffer.fromJson(Map<String, dynamic> json) {
    return CategoryOffer(
      id: json['id'],
      badge: json['badge'],
      name: json['name'],
      slug: json['slug'],
      logo: json['logo'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      country: json['country'],
      division: json['division'],
      city: json['city'],
      area: json['area'],
      brand: json['brand'],
      category: json['category'],
    );
  }
}