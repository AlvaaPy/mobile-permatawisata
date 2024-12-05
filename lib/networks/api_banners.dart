import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiBanners {
  static const String baseUrl = 'http://192.168.119.1:8000/api/v1/';
  static const String imageBaseUrl =
      'http://192.168.119.1:8000/uploads/img/banner/';

  // Mendapatkan data banner
  static Future<List<String>> getBanners() async {
    final response = await http.get(
      Uri.parse('${baseUrl}banner'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bannerData = json.decode(response.body);

      // Debugging: Log response
      print('Response data: $bannerData');

      // Hanya mengambil URL gambar dari setiap banner
      return bannerData.map<String>((banner) {
        final imageUrl = '$imageBaseUrl${banner['banner_assets']}';
        
        // Debugging: Log image URL
        print('Image URL: $imageUrl');
        
        return imageUrl;
      }).toList();
    } else {
      throw Exception(
          'Gagal memuat data banner. Status code: ${response.statusCode}');
    }
  }
}
