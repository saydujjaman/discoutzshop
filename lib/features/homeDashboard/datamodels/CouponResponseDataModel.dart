import 'dart:convert';

class CouponResponse {
  final String status;
  final List<Coupon> data;
  final int count;

  CouponResponse({
    required this.status,
    required this.data,
    required this.count,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => Coupon.fromJson(item))
          .toList(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'count': count,
    };
  }
}

class Coupon {
  final int id;
  final String countryId;
  final String divisionId;
  final String cityId;
  final String areaId;
  final List<String> notifyTo;
  final dynamic tags;
  final int categoryId;
  final int brandId;
  final dynamic storeId;
  final int addedBy;
  final String badge;
  final String name;
  final String slug;
  final String logo;
  final String image;
  final String bannerImage;
  final dynamic price;
  final dynamic offerPrice;
  final String shortDescription;
  final String description;
  final String locations;
  final String url;
  final String sourceUrl;
  final String mapUrl;
  final String couponCode;
  final dynamic startDate;
  final dynamic notificationDate;
  final dynamic expiryDate;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<String> countries;
  final List<String> divisions;
  final List<String> cities;
  final List<String> areas;
  final List<String> addedByName;
  final List<String> categoryName;
  final List<String> brandName;
  final List<String> storeName;

  Coupon({
    required this.id,
    required this.countryId,
    required this.divisionId,
    required this.cityId,
    required this.areaId,
    required this.notifyTo,
    required this.tags,
    required this.categoryId,
    required this.brandId,
    required this.storeId,
    required this.addedBy,
    required this.badge,
    required this.name,
    required this.slug,
    required this.logo,
    required this.image,
    required this.bannerImage,
    required this.price,
    required this.offerPrice,
    required this.shortDescription,
    required this.description,
    required this.locations,
    required this.url,
    required this.sourceUrl,
    required this.mapUrl,
    required this.couponCode,
    required this.startDate,
    required this.notificationDate,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.countries,
    required this.divisions,
    required this.cities,
    required this.areas,
    required this.addedByName,
    required this.categoryName,
    required this.brandName,
    required this.storeName,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as int,
      countryId: json['country_id'] as String,
      divisionId: json['division_id'] as String,
      cityId: json['city_id'] as String,
      areaId: json['area_id'] as String,
      notifyTo: List<String>.from(json['notify_to'] as List<dynamic>),
      tags: json['tags'],
      categoryId: json['category_id'] as int,
      brandId: json['brand_id'] as int,
      storeId: json['store_id'],
      addedBy: json['added_by'] as int,
      badge: json['badge'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: json['logo'] ,
      image: json['image'] as String,
      bannerImage: json['banner_image'] as String,
      price: json['price'],
      offerPrice: json['offer_price'],
      shortDescription: json['short_description'] as String,
      description: json['description'] as String,
      locations: json['locations'] as String,
      url: json['url'] as String,
      sourceUrl: json['source_url'] as String,
      mapUrl: json['map_url'] as String,
      couponCode: json['coupon_code'] as String,
      startDate: json['start_date'],
      notificationDate: json['notification_date'],
      expiryDate: json['expiry_date'],
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      countries: List<String>.from(json['countries'] as List<dynamic>),
      divisions: List<String>.from(json['divisions'] as List<dynamic>),
      cities: List<String>.from(json['cities'] as List<dynamic>),
      areas: List<String>.from(json['areas'] as List<dynamic>),
      addedByName: List<String>.from(json['added_by_name'] as List<dynamic>),
      categoryName: List<String>.from(json['category_name'] as List<dynamic>),
      brandName: List<String>.from(json['brand_name'] as List<dynamic>),
      storeName: List<String>.from(json['store_name'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'division_id': divisionId,
      'city_id': cityId,
      'area_id': areaId,
      'notify_to': notifyTo,
      'tags': tags,
      'category_id': categoryId,
      'brand_id': brandId,
      'store_id': storeId,
      'added_by': addedBy,
      'badge': badge,
      'name': name,
      'slug': slug,
      'logo': logo,
      'image': image,
      'banner_image': bannerImage,
      'price': price,
      'offer_price': offerPrice,
      'short_description': shortDescription,
      'description': description,
      'locations': locations,
      'url': url,
      'source_url': sourceUrl,
      'map_url': mapUrl,
      'coupon_code': couponCode,
      'start_date': startDate,
      'notification_date': notificationDate,
      'expiry_date': expiryDate,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'countries': countries,
      'divisions': divisions,
      'cities': cities,
      'areas': areas,
      'added_by_name': addedByName,
      'category_name': categoryName,
      'brand_name': brandName,
      'store_name': storeName,
    };
  }
}