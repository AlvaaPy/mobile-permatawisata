import 'package:flutter/material.dart';
import 'detail_rental.dart';
import '../../networks/api_rental.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({Key? key}) : super(key: key);

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  late Future<List<Map<String, dynamic>>> _rentalFuture;

  @override
  void initState() {
    super.initState();
    _rentalFuture = ApiRental.getRental();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _rentalFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada kendaraan rental tersedia",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final rentals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: (rental['foto'] != null && rental['foto'].isNotEmpty)
                        ? Image.network(
                            rental['foto'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/img/default_rental.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    rental['namaKendaraan'] ?? "Nama kendaraan tidak tersedia",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.luggage, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            "${rental['kapasitasBagasi']} liter",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            rental['jenisKendaraan'] ?? 'Jenis kendaraan tidak tersedia',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "Rp ${rental['harga'] ?? '0'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigasi ke halaman DetailRentalPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailRentalPage(rentalID: rental['rentalID']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
