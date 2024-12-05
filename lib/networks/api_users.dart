import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Untuk menentukan tipe mime pada file
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk mendapatkan ekstensi file

class ApiUsers {
  static const String baseUrl = 'http://192.168.119.1:8000/api/auth/v1/';

  // Register
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Failed to register. Status code: ${response.statusCode}');
    }
  }

  // Otp
  static Future<bool> verifyOtp(String otp, String email) async {
    final response = await http.post(
      Uri.parse('${baseUrl}verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'otp': otp,
        'email': email, // Kirimkan email bersama OTP
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Invalid OTP. Status code: ${response.statusCode}');
    }
  }

  // Complete Profile - formData
  static Future<bool> formData({
    required String email,
    required String fullname,
    required String username,
    required String noTlpn,
    required String birthDate,
    required String gender,
    String? profile_picture,
  }) async {
    final uri = Uri.parse('${baseUrl}complete-profile');
    final request = http.MultipartRequest('POST', uri);

    // Menambahkan headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });

    // Menambahkan data-data biasa
    request.fields['email'] = email;
    request.fields['fullname'] = fullname;
    request.fields['username'] = username;
    request.fields['noTlpn'] = noTlpn;
    request.fields['birthDate'] = birthDate;
    request.fields['gender'] = gender;

    // Menambahkan file foto profil jika tersedia
    if (profile_picture != null && profile_picture.isNotEmpty) {
      File imageFile = File(profile_picture);
      String fileName = basename(imageFile.path);
      String mimeType =
          'image/${extension(fileName).substring(1)}'; // Mengambil mime type sesuai ekstensi
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture', // Sesuai dengan nama field di backend
          imageFile.path,
          contentType: MediaType.parse(mimeType), // Menentukan mime type
        ),
      );
    }

    // Mengirimkan request
    final response = await request.send();

    // Mengecek status response dari server
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to submit data diri. Status code: ${response.statusCode}');
    }
  }

  // Login
  static Future<Map<String, String?>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'), // Pastikan baseUrl sudah benar
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final username = data['data']['user']['username'] ??
          'Guest'; // Default jika username null
      final profilePicture = data['data']['user']['profile_picture'];
      final token = data['data']['token']['original']['access_token'];
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'token', token); // Simpan token ke SharedPreferences
      }

      // Tetapkan URL gambar default jika profilePicture null atau kosong
      final profilePictureUrl = (profilePicture != null &&
              profilePicture.isNotEmpty)
          ? 'http://192.168.119.1:8000/uploads/profile_pictures/$profilePicture'
          : 'http://192.168.119.1:8000/uploads/profile_pictures/default.png';

      // Menyimpan data pengguna di SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('profile_picture', profilePictureUrl);
      print(response.body); // Debugging untuk memastikan response dari API

      return {
        'username': username,
        'profile_picture': profilePictureUrl,
      };
    } else {
      throw Exception(
          'Invalid email or password. Status code: ${response.statusCode}');
    }
  }

  // Profile

  static Future<Map<String, dynamic>> getProfile() async {
    // Ambil token dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found. Please log in.');
    }

    final response = await http.get(
      Uri.parse('${baseUrl}user'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Tambahkan token ke header Authorization
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil data profil dari response
      final profileData = {
        'email': data['data']['email'],
        'username': data['data']['username'] ?? 'Guest',
        'fullname': data['data']['fullname'] ?? '-',
        'noTlpn': data['data']['noTlpn'] ?? '-',
        'birthDate':
            data['data']['birthDate'].substring(0, 10), // Ambil Y-m-d saja
        'gender': data['data']['gender'] ?? 'Unknown',
        'profile_picture': (data['data']['profile_picture'] != null)
            ? 'http://192.168.119.1:8000/uploads/profile_pictures/${data['data']['profile_picture']}'
            : 'http://192.168.119.1:8000/uploads/profile_pictures/default.png',
      };

      return profileData;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access. Please log in again.');
    } else {
      throw Exception(
          'Failed to fetch profile. Status code: ${response.statusCode}');
    }
  }

  // Logout
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found. User may already be logged out.');
    }

    final response = await http.post(
      Uri.parse('${baseUrl}logout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Hapus token dari SharedPreferences
      await prefs.remove('token');
      await prefs.remove('username');
      await prefs.remove('profile_picture');
    } else {
      throw Exception('Failed to log out. Status code: ${response.statusCode}');
    }
  }

//update profile


}
