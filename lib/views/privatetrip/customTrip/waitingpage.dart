import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulasi loading 4 detik
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Konfirmasi'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Menampilkan CircularProgressIndicator jika loading
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    )
                  else
                    const Icon(
                      Icons.access_time, // Icon yang menunjukkan 'waiting'
                      size: 100.0,
                      color: Colors.blueAccent,
                    ),
                  const SizedBox(height: 30),

                  // Teks informasi bahwa pengguna sedang menunggu
                  const Text(
                    'Permintaan Anda sedang diproses...',
                    style: TextStyle(
                      fontSize: 22, // Ukuran font yang lebih besar untuk kenyamanan
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.5, // Jarak antar teks lebih nyaman dibaca
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Penjelasan lebih lanjut kepada pengguna
                  const Text(
                    'Tunggu konfirmasi dari admin, dan cek email Anda secara berkala dalam waktu 2x24 jam.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Tombol untuk kembali ke halaman utama atau lainnya
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                    },
                    
                    child: const Text(
                      'Kembali ke Halaman Utama',
                      style: TextStyle(
                        fontSize: 18, // Ukuran font tombol lebih besar
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: const Size(double.infinity, 50),
                      primary: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Membuat tombol lebih modern
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
