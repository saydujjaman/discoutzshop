import 'dart:convert';

class HomepageResponse {
  final String status;
  final HomepageData homepageData;
  final List<dynamic> offers;

  HomepageResponse({
    required this.status,
    required this.homepageData,
    required this.offers,
  });

  factory HomepageResponse.fromJson(Map<String, dynamic> json) {
    return HomepageResponse(
      status: json['status'] as String,
      homepageData: HomepageData.fromJson(json['homepage_data'] as Map<String, dynamic>),
      offers: json['offers'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'homepage_data': homepageData.toJson(),
      'offers': offers,
    };
  }
}

class HomepageData {
  final int id;
  final String topBanner;
  final String? topBannerLink;
  final String offerBanner;
  final String? offerBannerLink;
  final String dealTitle;
  final String dealHeader;
  final int? dealBrandId;
  final String dealBrandImage;
  final String offerSliderImageOne;
  final String offerSliderImageTwo;
  final String offerSliderImageThree;
  final String offerSliderImageFour;
  final String? offerSliderImageOneLink;
  final String? offerSliderImageTwoLink;
  final String? offerSliderImageThreeLink;
  final String? offerSliderImageFourLink;
  final String bottomBannerSliderOne;
  final String? bottomBannerSliderOneLink;
  final String bottomBannerSliderTwo;
  final String? bottomBannerSliderTwoLink;
  final String bottomBannerSliderThree;
  final String? bottomBannerSliderThreeLink;
  final String bottomBannerSliderFour;
  final String? bottomBannerSliderFourLink;
  final String createdAt;
  final String updatedAt;
  final String imageOne;
  final String imageTwo;
  final String imageThree;

  HomepageData({
    required this.id,
    required this.topBanner,
    this.topBannerLink,
    required this.offerBanner,
    this.offerBannerLink,
    required this.dealTitle,
    required this.dealHeader,
    this.dealBrandId,
    required this.dealBrandImage,
    required this.offerSliderImageOne,
    required this.offerSliderImageTwo,
    required this.offerSliderImageThree,
    required this.offerSliderImageFour,
    this.offerSliderImageOneLink,
    this.offerSliderImageTwoLink,
    this.offerSliderImageThreeLink,
    this.offerSliderImageFourLink,
    required this.bottomBannerSliderOne,
    this.bottomBannerSliderOneLink,
    required this.bottomBannerSliderTwo,
    this.bottomBannerSliderTwoLink,
    required this.bottomBannerSliderThree,
    this.bottomBannerSliderThreeLink,
    required this.bottomBannerSliderFour,
    this.bottomBannerSliderFourLink,
    required this.createdAt,
    required this.updatedAt,
    required this.imageOne,
    required this.imageTwo,
    required this.imageThree,
  });

  factory HomepageData.fromJson(Map<String, dynamic> json) {
    return HomepageData(
      id: json['id'] as int,
      topBanner: json['top_banner'] as String,
      topBannerLink: json['top_banner_link'] as String?,
      offerBanner: json['offer_banner'] as String,
      offerBannerLink: json['offer_banner_link'] as String?,
      dealTitle: json['deal_title'] as String,
      dealHeader: json['deal_header'] as String,
      dealBrandId: json['deal_brand_id'] as int?,
      dealBrandImage: json['deal_brand_image'] as String,
      offerSliderImageOne: json['offer_slider_image_one'] as String,
      offerSliderImageTwo: json['offer_slider_image_two'] as String,
      offerSliderImageThree: json['offer_slider_image_three'] as String,
      offerSliderImageFour: json['offer_slider_image_four'] as String,
      offerSliderImageOneLink: json['offer_slider_image_one_link'] as String?,
      offerSliderImageTwoLink: json['offer_slider_image_two_link'] as String?,
      offerSliderImageThreeLink: json['offer_slider_image_three_link'] as String?,
      offerSliderImageFourLink: json['offer_slider_image_four_link'] as String?,
      bottomBannerSliderOne: json['bottom_banner_slider_one'] as String,
      bottomBannerSliderOneLink: json['bottom_banner_slider_one_link'] as String?,
      bottomBannerSliderTwo: json['bottom_banner_slider_two'] as String,
      bottomBannerSliderTwoLink: json['bottom_banner_slider_two_link'] as String?,
      bottomBannerSliderThree: json['bottom_banner_slider_three'] as String,
      bottomBannerSliderThreeLink: json['bottom_banner_slider_three_link'] as String?,
      bottomBannerSliderFour: json['bottom_banner_slider_four'] as String,
      bottomBannerSliderFourLink: json['bottom_banner_slider_four_link'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      imageOne: json['image_one'] as String,
      imageTwo: json['image_two'] as String,
      imageThree: json['image_three'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'top_banner': topBanner,
      'top_banner_link': topBannerLink,
      'offer_banner': offerBanner,
      'offer_banner_link': offerBannerLink,
      'deal_title': dealTitle,
      'deal_header': dealHeader,
      'deal_brand_id': dealBrandId,
      'deal_brand_image': dealBrandImage,
      'offer_slider_image_one': offerSliderImageOne,
      'offer_slider_image_two': offerSliderImageTwo,
      'offer_slider_image_three': offerSliderImageThree,
      'offer_slider_image_four': offerSliderImageFour,
      'offer_slider_image_one_link': offerSliderImageOneLink,
      'offer_slider_image_two_link': offerSliderImageTwoLink,
      'offer_slider_image_three_link': offerSliderImageThreeLink,
      'offer_slider_image_four_link': offerSliderImageFourLink,
      'bottom_banner_slider_one': bottomBannerSliderOne,
      'bottom_banner_slider_one_link': bottomBannerSliderOneLink,
      'bottom_banner_slider_two': bottomBannerSliderTwo,
      'bottom_banner_slider_two_link': bottomBannerSliderTwoLink,
      'bottom_banner_slider_three': bottomBannerSliderThree,
      'bottom_banner_slider_three_link': bottomBannerSliderThreeLink,
      'bottom_banner_slider_four': bottomBannerSliderFour,
      'bottom_banner_slider_four_link': bottomBannerSliderFourLink,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image_one': imageOne,
      'image_two': imageTwo,
      'image_three': imageThree,
    };
  }
}