import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/landing/landingpage1.dart'; // Pastikan path import sudah benar
import 'views/home/home.dart'; // Pastikan path import untuk Home.dart benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Mengecek apakah pengguna sudah login atau belum
  Future<Map<String, String>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? profilePicture = prefs.getString('profile_picture');

    return {
      'username': username ?? '',
      'profile_picture': profilePicture ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Ukuran desain untuk responsif
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins', // Pastikan font Poppins diatur di sini
          ),
          home: FutureBuilder<Map<String, String>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              // Memeriksa status pengambilan data pengguna
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Menunggu hasil pengecekan
              } else if (snapshot.hasData) {
                String username = snapshot.data?['username'] ?? '';
                String profilePicture = snapshot.data?['profile_picture'] ?? '';

                if (username.isNotEmpty) {
                  // Jika sudah login, arahkan ke halaman Home dengan data pengguna
                  return Home(username: username, profilePicture: profilePicture);
                } else {
                  // Jika belum login, arahkan ke halaman LandingPage
                  return const Landingpage();
                }
              } else {
                // Jika terjadi error atau data tidak tersedia, arahkan ke LandingPage
                return const Landingpage();
              }
            },
          ),
        );
      },
    );
  }
}
