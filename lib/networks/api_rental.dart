import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRental {
  static const String baseUrl = 'http://192.168.186.1:8000/api/v1/';

  // Mendapatkan semua data rental
  static Future<List<Map<String, dynamic>>> getRental() async {
    final response = await http.get(
      Uri.parse('${baseUrl}rental'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> rentalResponse = json.decode(response.body);
      print(rentalResponse); // Debugging untuk melihat struktur JSON dari API
      final List<dynamic> rentalData = rentalResponse['data'];

      // Memproses data rental
      return rentalData.map<Map<String, dynamic>>((rental) {
        return {
          'rentalID': rental['rentalID'] ?? 0,
          'namaKendaraan': rental['nama_kendaraan'] ?? 'Nama tidak tersedia',
          'kapasitasKendaraan':
              rental['kapasitas_kendaraan']?.toString() ?? '0',
          'kapasitasBagasi': rental['kapasitas_bagasi']?.toString() ?? '0',
          'umurKendaraan': rental['umur_kendaraan']?.toString() ?? '0',
          'jenisKendaraan': rental['jenis_kendaraan'] ?? 'Jenis tidak tersedia',
          'deskripsi': rental['deskripsi'] ?? '',
          'denganSupir':
              rental['dengan_supir'] ?? 'tidak', // Pastikan tipe data string
          'harga': rental['harga']?.toString() ?? '0',
          'foto': rental['foto'] != null
              ? 'http://192.168.186.1:8000/uploads/img/rental/foto/${rental['foto']}'
              : '',
        };
      }).toList();
    } else {
      throw Exception(
          'Gagal memuat data rental. Status code: ${response.statusCode}');
    }
  }

  // Detail Rental
  static Future<Map<String, dynamic>> detailRental(int rentalID) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${baseUrl}rental/$rentalID'), // URL endpoint untuk detail rental
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      // Debugging: Cek status response dan body dari API
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debugging: Cek data yang sudah ter-parse
        print('Parsed Data: $data');

        // URL gambar utama dan gambar aset
        const String mainImageBaseUrl =
            'http://192.168.186.1:8000/uploads/img/rental/foto/';
        const String assetImageBaseUrl = 'http://192.168.186.1:8000/';

        // Memastikan gambar utama
        final String mainImageUrl = '$mainImageBaseUrl${data["Data"]["foto"]}';
        print('Main Image URL: $mainImageUrl');

        // Menyusun data yang ingin dikembalikan
        return {
          "rentalID": data["Data"]["rentalID"],
          "namaKendaraan": data["Data"]["nama_kendaraan"],
          "kapasitasKendaraan": data["Data"]["kapasitas_kendaraan"],
          "kapasitasBagasi": data["Data"]["kapasitas_bagasi"],
          "umurKendaraan": data["Data"]["umur_kendaraan"],
          "jenisKendaraan": data["Data"]["jenis_kendaraan"],
          "deskripsi": data["Data"]["deskripsi"],
          "denganSupir": data["Data"]["dengan_supir"],
          "harga": data["Data"]["harga"],
          "foto": mainImageUrl, // Gambar utama kendaraan
          "imagesRental": List<Map<String, dynamic>>.from(
            data["Data"]["images_rental"].map((asset) => {
                  "id": asset["images_rental_id"],
                  "picture":
                      '$assetImageBaseUrl${asset["picture"]}', // Gambar aset tambahan
                }),
          ),
        };
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception(
            'Gagal memuat detail rental: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error Exception: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
