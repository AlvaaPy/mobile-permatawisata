import 'package:flutter/material.dart';
import 'landingpage3.dart';

class Landingpage2 extends StatefulWidget {
  const Landingpage2({Key? key}) : super(key: key);

  @override
  State<Landingpage2> createState() => _Landingpage2State();
}

class _Landingpage2State extends State<Landingpage2> {
  // Variabel untuk mengatur halaman aktif pada indikator slide
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar di bagian atas
            Image.asset(
              'assets/img/landingpage2.png', // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
              height: 380,
            ),
            const SizedBox(height: 20), // Jarak setelah gambar

            // Padding untuk teks dan elemen lainnya
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul "Kenapa Milih Permata Wisata?"
                  const Text(
                    'Kenapa Milih',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Permata Wisata?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFFD30000), // Warna merah
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Baris dengan Icon dan Teks
                  buildIconTextRow(
                    icon: Icons.support_agent,
                    label: 'Pelayanan Prima',
                    iconColor: Colors.black54,
                  ),
                  const SizedBox(height: 10),
                  buildIconTextRow(
                    icon: Icons.attach_money,
                    label: 'Harga Paket Terbaik',
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  buildIconTextRow(
                    icon: Icons.place,
                    label: 'Pilihan Destinasi Favorit',
                    iconColor: Colors.red,
                  ),
                  const SizedBox(height: 10),
                  buildIconTextRow(
                    icon: Icons.history,
                    label: 'Berpengalaman Sejak 1990',
                    iconColor: Colors.orange,
                  ),

                  const SizedBox(height: 40),

                  // Tombol Next untuk navigasi ke Landingpage3
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
                            builder: (context) => const Landingpage3(),
                          ),
                        );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // Jarak setelah tombol

                  // Indikator Slide
                  buildPageIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun baris dengan ikon dan teks
  Widget buildIconTextRow({
    required IconData icon,
    required String label,
    Color iconColor = Colors.black,
  }) {
    return Row(
      children: [
        Icon(icon, size: 42, color: iconColor),
        const SizedBox(width: 10), // Jarak antara ikon dan teks
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  // Fungsi untuk indikator slide
  Widget buildPageIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Indikator untuk halaman pertama (non-aktif)
          buildIndicator(isActive: currentPage == 0),
          // Indikator untuk halaman kedua (aktif)
          buildIndicator(isActive: currentPage == 1),
          // Indikator untuk halaman ketiga (non-aktif)
          buildIndicator(isActive: currentPage == 2),
        ],
      ),
    );
  }

  // Fungsi untuk membangun indikator slide
  Widget buildIndicator({required bool isActive}) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.grey, // Warna aktif dan non-aktif
        shape: BoxShape.circle,
      ),
    );
  }
}
