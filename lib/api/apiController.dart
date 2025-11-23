import 'dart:convert';
import 'package:discountzshop/features/brands/datamodels/brandDataModel.dart';
import 'package:http/http.dart' as http;
import '../features/brands/datamodels/BrandsDataModel.dart';
import '../features/brands/datamodels/offerDataModel.dart';
import '../features/brands/datamodels/storeDataModel.dart';
import '../features/homeDashboard/datamodels/CouponResponseDataModel.dart';
import '../features/homeDashboard/datamodels/HomepageDataModel.dart';
import '../features/homeDashboard/datamodels/categoriesDataModel.dart';
import '../features/homeDashboard/datamodels/categoryDetailsDataModel.dart';
import '../features/homeDashboard/datamodels/firstSliderDataModel.dart';
import '../features/offers/datamodels/OfferDetailsDataModel.dart';
import '../features/offers/datamodels/offersDataModel.dart';
import '../features/stores/datamodels/storeListDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  static const String _baseUrl = 'https://www.discountzshop.com/api';

  Future<FirstSliderResponseDataModel> fetchFirstSliders() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/home-sliders"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return FirstSliderResponseDataModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load sliders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sliders: $e');
    }
  }

  Future<CouponResponse> getCoupons() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/coupons-all'));
      // print(json.decode(response.statusCode.toString()));
      // print(json.decode(response.body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        return CouponResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coupons: $e');
    }
  }

  Future<HomepageResponse> getHomepage() async {
    try {
      // print('Making API call to $_baseUrl/homepage');
      final response = await http.get(Uri.parse('$_baseUrl/homepage'));

      // print('Homepage API Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print('Homepage API Response Body: $jsonData');
        return HomepageResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load homepage data: ${response.statusCode}');
      }
    } catch (e) {
      print('Homepage API Error: $e');
      throw Exception('Error fetching homepage data: $e');
    }
  }

  Future<List<Offer>> fetchOffers({int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/offers-all?paginate=$limit&page=$page'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return (jsonData['data'] as List)
              .map((offer) => Offer.fromJson(offer))
              .toList();
        } else {
          throw Exception('API returned unsuccessful status');
        }
      } else {
        throw Exception('Failed to load offers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching offers: $e');
    }
  }

  Future<OfferDetails?> fetchOfferDetails(String slug) async {
    final url = '$_baseUrl/api/offer-details/$slug';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("RESPONSE -- ${jsonDecode(response.body)}");
        return OfferDetails.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load offer details');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

// api/apiController.dart
Future<List<Brands>> fetchBrands({int page = 1, int limit = 50}) async {
  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/brands-all?per_page=$limit&page=$page'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        final List categories = jsonData['data'] as List;

        List<Brands> allBrands = [];

        for (var cat in categories) {
          final List brandsJson = cat['brands'] as List;
          final String categoryName = cat['name'] as String;

          final brands = brandsJson.map((b) {
            final brandJson = b as Map<String, dynamic>;
            brandJson['category_name'] = categoryName; // Attach category name
            return Brands.fromJson(brandJson);
          }).toList();

          allBrands.addAll(brands);
        }

        return allBrands;
      } else {
        throw Exception('API error: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
  
  Future<BrandDetailsDataModel> fetchBrandDetails(String slug) async {
    final response = await http.get(Uri.parse('$_baseUrl/brand/$slug'));
    // print('$_baseUrl/brand/$slug');
    // print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return BrandDetailsDataModel.fromJson(data);
    } else {
      throw Exception('Failed to load brand');
    }
  }

  Future<StoreResponse> fetchBrandStores(String slug) async {
    final response = await http.get(Uri.parse('$_baseUrl/brand/$slug/stores'));
    // print('$_baseUrl/brand/$slug/stores');
    // print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return StoreResponse.fromJson(data);
    } else {
      throw Exception('Failed to load stores');
    }
  }

  /*Future<OfferResponse> fetchBrandOffers(String slug) async {
    final response = await http.get(Uri.parse('$_baseUrl/brand/$slug/offers'));
    print(' OFFER -- $_baseUrl/brand/$slug/offers');
    print(" OFFER -- ${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return OfferResponse.fromJson(data);
    } else {
      throw Exception('Failed to load offers');
    }
  }*/
  Future<OfferResponse> fetchBrandOffers(String slug) async {
    final url = Uri.parse('$_baseUrl/brand/$slug/offers');
    print('OFFER -- Fetching from: $url');
    final response = await http.get(url);
    print('OFFER -- Status code: ${response.statusCode}');
    print('OFFER -- Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      // Safely log offers data
      final data = decodedResponse['data'] as Map<String, dynamic>?;
      final offers = data?['offers'] as List<dynamic>? ?? [];
      print('OFFER -- Offers data: $offers');
      return OfferResponse.fromJson(decodedResponse);
    } else {
      print('OFFER -- Failed with status: ${response.statusCode}');
      throw Exception('Failed to load offers: ${response.statusCode}');
    }
  }


  Future<List<dynamic>> fetchBrandOffersList(String slug) async {
  final url = Uri.parse('$_baseUrl/brand/$slug/offers');
  print('OFFER -- Fetching from: $url');
  final response = await http.get(url);
  print('OFFER -- Status code: ${response.statusCode}');
  print('OFFER -- Response body: ${response.body}');

  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);
    final data = decodedResponse['data'] as Map<String, dynamic>?;
    final offers = data?['offers'] as List<dynamic>? ?? [];
    print('OFFER -- Offers data: $offers');
    return offers;
  } else {
    print('OFFER -- Failed with status: ${response.statusCode}');
    throw Exception('Failed to load offers: ${response.statusCode}');
  }
}


  static Future<List<StoreListDataModel>> fetchStores(int page) async {
    final url = Uri.parse('$_baseUrl/api/stores?paginate=10&page=$page');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("All Stores page: $page -- \nResponse - ${json.decode(response.body)} ");
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          final List storesJson = jsonData['data']['stores'];
          return storesJson.map((store) => StoreListDataModel.fromJson(store)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching stores: $e');
      return [];
    }
  }

  Future<List<CategoriesDataModel>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          final categoriesJson = jsonData['data']['categories'] as List;
          return categoriesJson.map((json) => CategoriesDataModel.fromJson(json)).toList();
        } else {
          throw Exception('API returned unsuccessful status');
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<CategoryDetailsDataModel> getCategoryDetails(String slug) async {
    final response = await http.get(Uri.parse('$_baseUrl/category/$slug'));

    print('$_baseUrl/category/$slug');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        return CategoryDetailsDataModel.fromJson(jsonData['data']);
      } else {
        throw Exception('API returned unsuccessful status');
      }
    } else {
      throw Exception('Failed to load category details');
    }
  }

// D8S
Future<Map<String, dynamic>> registerUser({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String passwordConfirmation,
}) async {
  const String url = '$_baseUrl/register';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['status'] == 'success') {
      print('Registration successful, Data: $data');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return {'statusCode': 200, 'message': 'Registration successful', 'data': data};
    } else if (response.statusCode == 422) {
      print('422 Response: ${response.body}');
      String errorMessage = data['message'] ?? 'Validation failed';
      if (data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        errorMessage = errors.values.first[0] ?? errorMessage;
      }
      return {'statusCode': 422, 'message': errorMessage};
    } else {
      print('Registration failed: ${response.statusCode}, Body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'message': data['message'] ?? 'Registration failed'
      };
    }
  } catch (e) {
    print('Error during registration: $e');
    return {'statusCode': 400, 'message': 'Something went wrong: $e'};
  }
}

// D8S
Future<Map<String, dynamic>> sendEmailVerification({required String email}) async {
  const String url = '$_baseUrl/email-verification/send';
  print("This is email- $email");
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      print('Email verification OTP sent, Data: $data');
      return {'statusCode': 200, 'message': 'Verification OTP sent'};
    } else {
      print('Send verification failed: ${response.statusCode}, Body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'message': data['message'] ?? 'Failed to send verification OTP'
      };
    }
  } catch (e) {
    print('Error during email verification request: $e');
    return {'statusCode': 400, 'message': 'Something went wrong: $e'};
  }
}

// D8S
Future<Map<String, dynamic>> verifyEmail({
  required String email,
  required String otp,
}) async {
  const String url = '$_baseUrl/email-verification/verify';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      print('Email verified successfully, Data: $data');
      return {'statusCode': 200, 'message': 'Email verified'};
    } else {
      print('Email verification failed: ${response.statusCode}, Body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'message': data['message'] ?? 'Invalid or expired OTP'
      };
    }
  } catch (e) {
    print('Error during email verification: $e');
    return {'statusCode': 400, 'message': 'Something went wrong: $e'};
  }
}

// D8S
Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
}) async {
  const String url = '$_baseUrl/login';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);
    if ((response.statusCode == 200 || response.statusCode == 201) && data['status'] == 'success') {
      print('Login successful, Data: $data');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return {'statusCode': 200, 'message': 'Login successful'};
    } else if (response.statusCode == 422) {
      print('422 Response: ${response.body}');
      String errorMessage = data['message'] ?? 'Validation failed';
      if (data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        errorMessage = errors.values.first[0] ?? errorMessage;
      }
      return {'statusCode': 422, 'message': errorMessage};
    } else {
      print('Login failed: ${response.statusCode}, Body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'message': data['message'] ?? 'Login failed'
      };
    }
  } catch (e) {
    print('Error during login: $e');
    return {'statusCode': 400, 'message': 'Something went wrong: $e'};
  }
}




// D8S
Future<Map<String, dynamic>> fetchElaborateOfferDetails(String slug) async {
    final url = '$_baseUrl/offer-details/$slug';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == 'success') {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load offer details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching offer details: $e');
      throw Exception('Error fetching offer details: $e');
    }
  }

  // D8S
  Future<Map<String, dynamic>?> fetchBrandOverviewData(String slug) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/brand/$slug'));

      if (response.statusCode == 200) {
        // print('This is overview response data ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Apex brand data: $e');
      return null;
    }
  }

Future<void> resetPassword(String token) async {
  // Construct the URL with the token
  final String url = 'https://www.discountzshop.com/api/reset-password/$token';

  try {
    // Make the GET request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        // Add any additional headers if required, e.g., Authorization
        // 'Authorization': 'Bearer your_token_here',
      },
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Parse the response body
      final responseData = jsonDecode(response.body);
      print('Success: $responseData');
      // Handle the successful response (e.g., show a success message)
    } else {
      // Handle errors
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    print('Exception: $e');
    throw Exception('An error occurred while resetting password: $e');
  }
}

Future<List<Map<String, dynamic>>> getBrandStores(String slug) async {
  try {
    // Construct the full URL with the slug
    final String url = '$_baseUrl/brand/$slug/stores';
    print('Requesting URL: $url'); // Log the URL

    // Make the GET request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        // Add any required headers, e.g., Authorization, if needed
        // 'Authorization': 'Bearer your_token',
      },
    );

    // Log the response status and body
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the status is success and data exists
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        // Extract the stores list from data.stores
        final List<dynamic> stores = jsonResponse['data']['stores'] ?? [];
        // print('Stores fetched: $stores');
        return stores.cast<Map<String, dynamic>>().toList();
      } else {
        throw Exception('Invalid response: Status is not success or data is missing');
      }
    } else {
      // Handle non-200 responses
      throw Exception('Failed to fetch stores: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    // Log the error
    print('Error fetching brand stores: $e');
    throw Exception('Error fetching brand stores: $e');
  }
}

}

