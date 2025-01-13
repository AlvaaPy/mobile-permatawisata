import 'package:flutter/material.dart';
import '../../networks/api_rental.dart';
import 'components/paymentrental.dart';

class DetailRentalPage extends StatefulWidget {
  final int rentalID;

  DetailRentalPage({required this.rentalID});

  @override
  _DetailRentalPageState createState() => _DetailRentalPageState();
}

class _DetailRentalPageState extends State<DetailRentalPage> {
  late Future<Map<String, dynamic>> rentalDetail;
  bool isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    rentalDetail = ApiRental.detailRental(widget.rentalID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Rental',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: rentalDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Detail rental tidak ditemukan',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final rental = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Utama
                rental['foto'] != ''
                    ? GestureDetector(
                        onTap: () {
                          _showFullScreenImage(context, rental['foto']);
                        },
                        child: Image.network(
                          rental['foto'],
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 250,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Text('Gambar tidak tersedia'),
                        ),
                      ),
                const SizedBox(height: 16),

                // Informasi Kendaraan dalam Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Kendaraan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Row pertama untuk 2 item
                          Row(
                            children: [
                              Flexible(
                                child: _infoItem(
                                  Icons.people,
                                  'Kapasitas Kendaraan',
                                  '${rental['kapasitasKendaraan']} orang',
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // untuk memberi jarak antar kolom
                              Flexible(
                                child: _infoItem(
                                  Icons.luggage,
                                  'Kapasitas Bagasi',
                                  '${rental['kapasitasBagasi']} kg',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Row kedua untuk 2 item
                          Row(
                            children: [
                              Flexible(
                                child: _infoItem(
                                  Icons.calendar_today,
                                  'Umur Kendaraan',
                                  '${rental['umurKendaraan']} tahun',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: _infoItem(
                                  Icons.directions_car,
                                  'Jenis Kendaraan',
                                  rental['jenisKendaraan'] ?? '-',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Row ketiga untuk 1 item (karena ada 5 item total)
                          _infoItem(Icons.person, 'Supir',
                              rental['denganSupir'] ?? '-'),

                          const SizedBox(height: 16),
                          Text(
                            'Harga: Rp ${rental['harga']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Deskripsi
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDescriptionExpanded = !isDescriptionExpanded;
                              });
                            },
                            child: Text(
                              isDescriptionExpanded
                                  ? rental['deskripsi'] ??
                                      'Deskripsi tidak tersedia'
                                  : (rental['deskripsi']?.length ?? 0) > 100
                                      ? '${rental['deskripsi']?.substring(0, 100)}...'
                                      : rental['deskripsi'] ??
                                          'Deskripsi tidak tersedia',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Foto Tambahan
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Foto Tambahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                rental['imagesRental'].isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Tidak ada gambar tambahan'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: rental['imagesRental'].length,
                          itemBuilder: (context, index) {
                            final image = rental['imagesRental'][index];
                            return GestureDetector(
                              onTap: () {
                                _showFullScreenImage(context, image['picture']);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    image['picture'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 18),
                // Tombol Navigasi ke Halaman Pembayaran
                Center(
                  child: SizedBox(
                    width: double.infinity, // Lebar penuh
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(),
                          ),
                        );
                      },
                      child: const Text('Lanjut ke Pembayaran'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Ikon dengan latar belakang
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          // Label dan Nilai
          Expanded(
            // Menambahkan Expanded untuk memberi ruang pada teks
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.grey.shade600), // Menurunkan ukuran font label
                  overflow: TextOverflow
                      .ellipsis, // Menambahkan overflow agar teks tidak meluap
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold), // Menurunkan ukuran font value
                  overflow:
                      TextOverflow.ellipsis, // Menambahkan overflow pada value
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan gambar dalam fullscreen menggunakan Dialog
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Agar gambar bisa ditutup dengan tap di luar
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
