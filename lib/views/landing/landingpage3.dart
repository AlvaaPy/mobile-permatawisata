import 'package:flutter/material.dart';
import '../auth/login.dart';

class Landingpage3 extends StatefulWidget {
  const Landingpage3({Key? key}) : super(key: key);

  @override
  State<Landingpage3> createState() => _Landingpage3State();
}

class _Landingpage3State extends State<Landingpage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar di bagian atas
              Image.asset(
                'assets/img/landingpage3.png', // Ganti dengan path gambar Anda
                fit: BoxFit.cover,
                height: 265,
              ),
              const SizedBox(height: 20), // Jarak antara gambar dan teks

              // Padding untuk teks dan elemen lainnya
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // RichText untuk "Apa saja yang ada di Permata Wisata"
                    const Text(
                      'Apa saja yang ada di',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Permata Wisata',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Color(0xFFD30000), // Warna merah
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Open Trip
                    buildServiceRow(
                      title: 'Open Trip',
                      description:
                          'Bergabung dengan grup, kunjungi destinasi populer, dan temukan teman baru.',
                      icon: Icons.people_outline,
                    ),
                    const SizedBox(height: 10),

                    // Private Trip
                    buildServiceRow(
                      title: 'Private Trip',
                      description:
                          'Kemewahan dan kenyamanan dalam satu paket liburan.',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 10),

                    // Custom Trip
                    buildServiceRow(
                      title: 'Custom Trip',
                      description:
                          'Rancang perjalanan impian Anda bersama kami.',
                      icon: Icons.edit_outlined,
                    ),
                    const SizedBox(height: 10),

                    // Sewa Kendaraan
                    buildServiceRow(
                      title: 'Sewa Kendaraan',
                      description:
                          'Bebas kemana saja, kapan saja. Petualangan Anda dimulai dari sini.',
                      icon: Icons.directions_car_outlined,
                    ),
                    const SizedBox(height: 110),

                    // Tombol Login
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD30000),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            )
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Indikator Slide di Landingpage3
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tidak Aktif (Halaman 1)
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              color: Colors.grey, // Warna tidak aktif
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Tidak Aktif (Halaman 2)
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              color: Colors.grey, // Warna tidak aktif
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Aktif (Halaman 3)
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              color: Colors.red, // Warna aktif
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun baris layanan
  Widget buildServiceRow({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 36, color: Colors.red), // Ikon untuk tiap layanan
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
