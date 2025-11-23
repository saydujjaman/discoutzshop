import 'dart:convert';

class firstSlider {
  final int id;
  final String image;
  final String url;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  firstSlider({
    required this.id,
    required this.image,
    required this.url,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory firstSlider.fromJson(Map<String, dynamic> json) {
    return firstSlider(
      id: json['id'],
      image: json['image'],
      url: json['url'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class FirstSliderResponseDataModel {
  final String status;
  final List<firstSlider> data;
  final int count;

  FirstSliderResponseDataModel({
    required this.status,
    required this.data,
    required this.count,
  });

  factory FirstSliderResponseDataModel.fromJson(Map<String, dynamic> json) {
    return FirstSliderResponseDataModel(
      status: json['status'],
      data: (json['data'] as List).map((item) => firstSlider.fromJson(item)).toList(),
      count: json['count'],
    );
  }
}