class CategoriesDataModel {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String logo;
  final String image;
  final String bannerImage;
  final String? description;

  CategoriesDataModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    required this.logo,
    required this.image,
    required this.bannerImage,
    this.description,
  });

  factory CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    return CategoriesDataModel(
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
