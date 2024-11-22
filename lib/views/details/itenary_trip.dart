import 'package:flutter/material.dart';

class ItineraryTab extends StatelessWidget {
  final List<Map<String, dynamic>> itinerary;

  const ItineraryTab({Key? key, required this.itinerary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: itinerary.length,
      itemBuilder: (context, index) {
        final item = itinerary[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0), // Jarak antar elemen
          padding: const EdgeInsets.all(16.0), // Padding dalam kotak
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF9F9F9)], // Gradasi warna
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0), // Sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Warna bayangan
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2), // Bayangan ke bawah
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Itinerary
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    radius: 20,
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Hari ke-${item['hari_ke']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Deskripsi
              Text(
                item['deskripsi'] ?? "Deskripsi tidak tersedia",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),

              // Garis separator
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),

              // Waktu mulai dan selesai
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${item['waktu_mulai']} - ${item['waktu_selesai']}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
