import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCities {
  static const String baseUrl = 'http://192.168.119.1:8000/api/v1/';

  // Mendapatkan semua data kota
  static Future<List<Map<String, dynamic>>> getCities() async {
    final response = await http.get(
      Uri.parse('${baseUrl}cities'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> cityData = json.decode(response.body);

      // Memproses setiap kota untuk mengambil data utama
      return cityData.map<Map<String, dynamic>>((city) {
        return {
          'cityID': city['cityID'],
          'city_name': city['city_name'],
          'province_name': city['province']['province_name'],
          'country_name': city['country']['country_name'],
        };
      }).toList();
    } else {
      throw Exception(
          'Gagal memuat data kota. Status code: ${response.statusCode}');
    }
  }
}