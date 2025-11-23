class Offer {
  final int id;
  final String? badge; // Changed to nullable
  final String? name;  // Changed to nullable
  final String? slug;  // Changed to nullable
  final String? image;
  final String? price;
  final String? offerPrice;
  final String? shortDescription;
  final String? url;
  final String? sourceUrl;
  final String? couponCode;
  final String? startDate;
  final String? expiryDate;
  final String? status;
  final String? categoryName;
  final String? brandName;
  final List<String> areas;

  Offer({
    required this.id,
    this.badge,
    this.name,
    this.slug,
    this.image,
    this.price,
    this.offerPrice,
    this.shortDescription,
    this.url,
    this.sourceUrl,
    this.couponCode,
    this.startDate,
    this.expiryDate,
    this.status,
    this.categoryName,
    this.brandName,
    required this.areas,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      badge: json['badge']?.toString(), // Convert to String or null
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      image: json['image']?.toString(),
      price: json['price']?.toString(),
      offerPrice: json['offer_price']?.toString(),
      shortDescription: json['short_description']?.toString(),
      url: json['url']?.toString(),
      sourceUrl: json['source_url']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      startDate: json['start_date']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      status: json['status']?.toString(),
      categoryName: json['category_name']?.toString(),
      brandName: json['brand_name']?.toString(),
      areas: json['areas'] != null ? List<String>.from(json['areas']) : [],
    );
  }
}