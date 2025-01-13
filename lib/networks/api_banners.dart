import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiBanners {
  static const String baseUrl = 'https://be.permata.tifpsdku.com/api/v1/';
  static const String imageBaseUrl =
      'https://be.permata.tifpsdku.com/uploads/img/banner/';

  // Mendapatkan data banner
  static Future<List<Map<String, dynamic>>> getBanners() async {
    final response = await http.get(
      Uri.parse('${baseUrl}banner'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bannerData = json.decode(response.body);

      return bannerData.map<Map<String, dynamic>>((banner) {
        return {
          'image': '$imageBaseUrl${banner['banner_assets']}', // URL gambar
          'description':
              banner['description'] ?? 'Deskripsi tidak tersedia', // Deskripsi
        };
      }).toList();
    } else {
      throw Exception(
          'Gagal memuat data banner. Status code: ${response.statusCode}');
    }
  }
}
