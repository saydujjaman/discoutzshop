class OffersBrand {
  final int id;
  final String name;
  final String logo;
  final String banner_image;
  final String middle_banner_left;
  final String middle_banner_right;
  final String about_title;
  final String about;
  final String offer_description_title;
  final String offerDescription;

  OffersBrand({
    required this.id,
    required this.name,
    required this.logo,
    required this.banner_image,
    required this.middle_banner_left,
    required this.middle_banner_right,
    required this.about_title,
    required this.about,
    required this.offer_description_title,
    required this.offerDescription,
  });

  factory OffersBrand.fromJson(Map<String, dynamic> json) {
    return OffersBrand(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      banner_image: json['banner_image'],
      middle_banner_left: json['middle_banner_left'],
      middle_banner_right: json['middle_banner_right'],
      about_title: json['about_title'],
      about: json['about'],
      offer_description_title: json['offer_description_title'],
      offerDescription: json['offer_description'],
    );
  }
}

class OffersOffer {
  final int id;
  final String name;
  final String? badge;
  final int? price;
  final int? offerPrice;
  final String? shortDescription;
  final String? image;

  OffersOffer({
    required this.id,
    required this.name,
    required this.badge,
    required this.price,
    required this.offerPrice,
    required this.shortDescription,
    required this.image,
  });

  factory OffersOffer.fromJson(Map<String, dynamic> json) {
    return OffersOffer(
      id: json['id'],
      name: json['name'],
      badge: json['badge'],
      price: json['price'],
      offerPrice: json['offer_price'],
      shortDescription: json['short_description'],
      image: json['image'],
    );
  }
}

class OfferDetails {
  final OffersBrand brand;
  final OffersOffer offer;

  OfferDetails({
    required this.brand,
    required this.offer,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json) {
    return OfferDetails(
      brand: OffersBrand.fromJson(json['data']['brand']),
      offer: OffersOffer.fromJson(json['data']['offer']),
    );
  }
}