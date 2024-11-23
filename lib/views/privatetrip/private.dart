import 'package:flutter/material.dart';
import 'package:permatawisata/views/privatetrip/customTrip/custom_trip.dart';
import 'privateTrip/private_trip.dart';

class PrivateTrip extends StatefulWidget {
  const PrivateTrip({super.key});

  @override
  State<PrivateTrip> createState() => _PrivateTripState();
}

class _PrivateTripState extends State<PrivateTrip> {
  String selectedButton = 'private'; // Default tombol yang aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Menempatkan di atas
        crossAxisAlignment: CrossAxisAlignment.center, // Di tengah horizontal
        children: [
          const SizedBox(height: 20), // Jarak dari atas layar
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Di tengah secara horizontal
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedButton = 'private';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedButton == 'private'
                      ? Colors.blueAccent
                      : Colors.white, // Ubah warna berdasarkan pilihan
                  foregroundColor: selectedButton == 'private'
                      ? Colors.white
                      : Colors.black, // Warna teks
                  side: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Membulatkan tombol
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, // Padding horizontal
                    vertical: 15, // Padding vertical
                  ),
                ),
                child: const Text('Private'),
              ),
              const SizedBox(width: 16), // Spasi antar tombol
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedButton = 'custom';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedButton == 'custom'
                      ? Colors.blueAccent
                      : Colors.white, // Ubah warna berdasarkan pilihan
                  foregroundColor: selectedButton == 'custom'
                      ? Colors.white
                      : Colors.black, // Warna teks
                  side: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Membulatkan tombol
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30, // Padding horizontal
                    vertical: 15, // Padding vertical
                  ),
                ),
                child: const Text('Custom'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: selectedButton == 'private'
                ? const PrivateTripPage() // Tampilkan PrivateTripPage
                :  const CustomTrip(),
          ),
        ],
      ),
    );
  }
}
