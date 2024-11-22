import 'package:flutter/material.dart';

class MeetingPointTab extends StatelessWidget {
  final String meetingPoint;

  const MeetingPointTab({Key? key, required this.meetingPoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0), // Memberikan jarak dari elemen lain
      padding: const EdgeInsets.all(16.0), // Memberikan jarak di dalam kotak
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang
        borderRadius: BorderRadius.circular(12.0), // Membuat sudut kotak melengkung
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Warna bayangan
            spreadRadius: 1, // Lebar bayangan
            blurRadius: 1, // Efek blur bayangan
            offset: const Offset(0, 0), // Posisi bayangan
          ),
        ],
      ),
      child: Text(
        meetingPoint.isNotEmpty ? meetingPoint : "Meeting point tidak tersedia",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54, // Warna teks yang lembut
          height: 1.6, // Spasi antar baris teks
        ),
        textAlign: TextAlign.justify, // Teks rata kanan-kiri
      ),
    );
  }
}
