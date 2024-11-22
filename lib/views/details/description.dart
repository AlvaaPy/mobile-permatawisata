import 'package:flutter/material.dart';

class DescriptionTab extends StatelessWidget {
  final String description;

  const DescriptionTab({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Memberikan jarak dari elemen lain
      child: Container(
        padding: const EdgeInsets.all(16.0), // Memberikan jarak di dalam kotak
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang
          borderRadius:
              BorderRadius.circular(12.0), // Membuat sudut kotak melengkung
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Warna bayangan
              spreadRadius: 1, // Lebar bayangan
              blurRadius: 1, // Efek blur bayangan
              offset: const Offset(0, 0), // Posisi bayangan
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54, // Warna teks agar tidak terlalu kontras
              height: 1.6, // Spasi antar baris teks
            ),
            textAlign: TextAlign.justify, // Rata kanan-kiri
          ),
        ),
      ),
    );
  }
}
