import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiVoucher {
  static const String baseUrl = 'http://192.168.186.1:8000/api/v1/';
  static const String imageBaseUrl = 'http://192.168.186.1:8000/uploads/img/voucher/';

  // Ambil data voucher yang penting
  static Future<List<Map<String, dynamic>>> getVoucher() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}voucher'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decode JSON response
        final List<dynamic> voucherData = json.decode(response.body);

        // Ambil data yang penting
        return voucherData.map<Map<String, dynamic>>((voucher) {
          return {
            'voucherID': voucher['voucherID'],
            'voucher_code': voucher['voucher_code'],
            'picture': '$imageBaseUrl${voucher['picture']}', // URL gambar lengkap
            'fixed_discount': voucher['fixed_discount'],
            'percentage_discount': voucher['percentage_discount'],
            'valid_from': voucher['valid_from'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load vouchers');
      }
    } catch (e) {
      print('Error fetching vouchers: $e');
      return [];
    }
  }
}
