import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiReservation {
  static const String baseUrl = 'http://192.168.186.1:8000/api/auth/v1/';

  static Future<Map<String, dynamic>> reservation({
  required int tripID,
  required int jumlah_peserta,
  required String nama_pemesan,
  required String email_pemesan,
  required String no_telepon_pemesan,
  required String meeting_points,
  required String tgl_reservation,
  required String tgl_start,
  required String tgl_end,
  String? voucherID,
  required String token,
  required List<Map<String, String>> participants, // Menambahkan peserta
}) async {
  final url = Uri.parse('${baseUrl}reservasi');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'tripID': tripID,
        'jumlah_peserta': jumlah_peserta,
        'nama_pemesan': nama_pemesan,
        'email_pemesan': email_pemesan,
        'no_telepon_pemesan': no_telepon_pemesan,
        'meeting_points': meeting_points,
        'tgl_reservation': tgl_reservation,
        'tgl_start': tgl_start,
        'tgl_end': tgl_end,
        'voucherID': voucherID,
        'participants': participants, // Mengirimkan peserta
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to request reservation: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

}
