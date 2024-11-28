import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTripCustom {
  static const String baseUrl = 'http://192.168.54.1:8000/api/auth/v1/';

  // Request Custom Trip
  static Future<Map<String, dynamic>> requestTrip({
    required String namaPemesan,
    required String startDate,
    required String endDate,
    required int jumlahPeserta,
    String? tripID,
    String? judul_trip,
    required String jenisCustom,
    required int cityID,
    required String alamatDetail,
    String? catatan,
    required String token, // Token untuk autentikasi
  }) async {
    final url = Uri.parse('${baseUrl}custom-trips');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
            'Bearer $token',
        },
        body: jsonEncode({
          'nama_pemesan': namaPemesan,
          'start_date': startDate,
          'end_date': endDate,
          'jumlah_peserta': jumlahPeserta,
          'tripID': tripID,
          'judul_trip': judul_trip,
          'jenis_custom': jenisCustom,
          'cityID': cityID,
          'alamat_detail': alamatDetail,
          'catatan': catatan,
        }),
      );

      if (response.statusCode == 201) {
        // Request berhasil
        return jsonDecode(response.body);
      } else {
        // Request gagal
        throw Exception(
            'Failed to request custom trip: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  
}
