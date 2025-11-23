class Store {
  final int id;
  final String? title;
  final String? addressLineOne;
  final String? addressLineTwo;
  final String? url;

  Store({
    required this.id,
    this.title,
    this.addressLineOne,
    this.addressLineTwo,
    this.url,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      title: json['title'],
      addressLineOne: json['address_line_one'],
      addressLineTwo: json['address_line_two'],
      url: json['url'],
    );
  }
}

class StoreResponse {
  final List<Store>? stores;

  StoreResponse({this.stores});

  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      stores: (json['stores'] as List<dynamic>?)?.map((e) => Store.fromJson(e)).toList(),
    );
  }
}