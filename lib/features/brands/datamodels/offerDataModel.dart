import 'dart:convert';

// Helper function to convert dynamic value to int
int? convertToInt(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return value as int?;
}

// Helper function to convert dynamic value to int list
List<int>? convertToIntList(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    try {
      final decoded = jsonDecode(value) as List<dynamic>?;
      return decoded?.map((e) => convertToInt(e) ?? 0).toList();
    } catch (e) {
      return [convertToInt(value) ?? 0];
    }
  } else if (value is List) {
    return (value as List<dynamic>).map((e) => convertToInt(e) ?? 0).toList();
  }
  return null;
}

class BrandOffersDataModel {
  final int id;
  final String? name;
  final String? shortDescription;
  final String? badge;
  final String? expiryDate;
  final String? image;
  final double? price; // Add this
  final double? offerPrice; // Add this

  BrandOffersDataModel({
    required this.id,
    this.name,
    this.shortDescription,
    this.badge,
    this.expiryDate,
    this.image,
    this.price,
    this.offerPrice,
  });

  factory BrandOffersDataModel.fromJson(Map<String, dynamic> json) {
    return BrandOffersDataModel(
      id: convertToInt(json['id']) ?? 0,
      name: json['name'],
      shortDescription: json['short_description'],
      badge: json['badge'],
      expiryDate: json['expiry_date'],
      image: json['image'],
      price: (json['price'] as num?)?.toDouble(),
      offerPrice: (json['offer_price'] as num?)?.toDouble(),
    );
  }
}

class OfferResponse {
  final List<BrandOffersDataModel>? offers;

  OfferResponse({this.offers});

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    print("OfferResponse.fromJson - Input JSON: $json");
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      print("OfferResponse.fromJson - No 'data' key found");
      return OfferResponse(offers: []);
    }

    final offersList = data['offers'] as List<dynamic>?;
    print("OfferResponse.fromJson - Offers list: $offersList");
    if (offersList == null || offersList.isEmpty) {
      print("OfferResponse.fromJson - No offers or empty offers list");
      return OfferResponse(offers: []);
    }

    final parsedOffers = offersList
        .map((e) => BrandOffersDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    print("OfferResponse.fromJson - Parsed offers: $parsedOffers");
    return OfferResponse(offers: parsedOffers);
  }
}