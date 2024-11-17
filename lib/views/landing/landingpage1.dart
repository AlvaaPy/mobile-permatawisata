import 'package:flutter/material.dart';
import 'landingpage2.dart'; // Pastikan path ke LandingPage2 benar

class Landingpage extends StatefulWidget {
  const Landingpage({Key? key}) : super(key: key);

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Bagian Gambar
              LandingPageImage(),

              SizedBox(height: 20),

              // Bagian Konten Teks
              LandingPageContent(),

              SizedBox(height: 170),

              // Tombol Next
              Center(
                child: NextButton(),
              ),

              SizedBox(height: 20),

              // Indikator Slide
              LandingPageIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class LandingPageImage extends StatelessWidget {
  const LandingPageImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/landingpage1.png', // Ganti dengan path gambar Anda
      fit: BoxFit.cover,
      height: 365,
    );
  }
}

class LandingPageContent extends StatelessWidget {
  const LandingPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RichText untuk "Paket Wisata"
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Paket',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(text: '   '),
                TextSpan(
                  text: 'Wisata',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFFD30000),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // RichText untuk "Liburan Seru"
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Liburan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFFD30000),
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: ' Seru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Hashtag
          const Text(
            '#LebihLokalLebihSeru',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Color(0xFFD30000),
            ),
          ),
          const SizedBox(height: 10),

          // Teks Deskripsi
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
              children: [
                TextSpan(text: 'Liburan menjadi lebih '),
                TextSpan(
                  text: 'CEPAT, MUDAH ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD30000),
                  ),
                ),
                TextSpan(text: 'dan '),
                TextSpan(
                  text: 'MENYENANGKAN ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD30000),
                  ),
                ),
                TextSpan(text: 'bersama Permata Wisata.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD30000),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // Navigasi ke landingpage2 dengan animasi geser
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Landingpage2()),
        );
      },
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class LandingPageIndicator extends StatelessWidget {
  const LandingPageIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIndicator(isActive: true),
        _buildIndicator(isActive: false),
        _buildIndicator(isActive: false),
      ],
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
