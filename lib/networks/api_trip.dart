import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTrip {
  static const String baseUrl = 'http://192.168.121.1:8000/api/v1/';

  // Mendapatkan semua data trip
  static Future<List<Map<String, dynamic>>> getTrips() async {
    final response = await http.get(
      Uri.parse('${baseUrl}package-trip'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tripData = json.decode(response.body);

      // Memproses setiap trip untuk mengambil data utama dan gambar
      return tripData.map<Map<String, dynamic>>((trip) {
        return {
          'tripID': trip['tripID'],
          'namaTrip': trip['namaTrip'],
          'alamat': trip['alamat'],
          'deskripsi': trip['deskripsi'],
          'meeting_point': trip['meeting_point'],
          'price': trip['price'],
          'start_date': trip['start_date'],
          'end_date': trip['end_date'],
          'rating': trip['rating'] ?? 'N/A',
          'picture':
              'http://192.168.121.1:8000/uploads/img/trip/${trip['picture']}', // URL gambar utama
        };
      }).toList();
    } else {
      throw Exception(
          'Gagal memuat data trip. Status code: ${response.statusCode}');
    }
  }
  
  // detail Trip
  static Future<Map<String, dynamic>> detailTrips(int tripID) async {
  try {
    final response = await http.get(
      Uri.parse('${baseUrl}package-trip/$tripID'),
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

      // URL gambar utama dan aset tambahan
      final String mainImageBaseUrl = 'http://192.168.121.1:8000/uploads/img/trip/';
      final String assetImageBaseUrl = 'http://192.168.121.1:8000/uploads/img/assetstrip/';

      // Memastikan gambar utama
      final String mainImageUrl = '$mainImageBaseUrl${data["picture"]}';
      print('Main Image URL: $mainImageUrl');

      // Menyusun data yang ingin dikembalikan
      return {
        "tripID": data["tripID"],
        "namaTrip": data["namaTrip"],
        "alamat": data["alamat"],
        "deskripsi": data["deskripsi"],
        "meeting_point": data["meeting_point"],
        "price": data["price"],
        "start_date": data["start_date"],
        "end_date": data["end_date"],
        "rating": data["rating"] ?? "N/A",
        "picture": mainImageUrl, // Gambar utama
        "city": {
          "cityID": data["city"]["cityID"],
        },
        "itenary_trip": List<Map<String, dynamic>>.from(
          data["itenary_trip"].map((itenary) => {
            "itenaryID": itenary["itenaryID"],
            "hari_ke": itenary["hari_ke"],
            "deskripsi": itenary["deskripsi"],
            "waktu_mulai": itenary["waktu_mulai"],
            "waktu_selesai": itenary["waktu_selesai"],
          }),
        ),
        // Memperbaiki bagian gambar aset trip agar tidak ada duplikasi path
        "package_trip_asset": List<Map<String, dynamic>>.from(
          data["package_trip_asset"].map((asset) => {
            "id": asset["id"],
            "tripID": asset["tripID"],
            // Menghapus bagian path yang sudah ada dan hanya menambahkan gambar
            "picture": '$assetImageBaseUrl${asset["picture"].split('assetstrip/').last}', // Gambar tambahan tanpa duplikasi path
          }),
        ),
      };
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception(
          'Gagal memuat detail trip: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error Exception: $e');
    throw Exception('Terjadi kesalahan: $e');
  }
}

}
