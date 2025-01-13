import 'package:flutter/material.dart';

import '../payment/payment.dart';

class ReservationSummary extends StatelessWidget {
  final String nameTrip;
  final int jumlahHari;
  final int totalHarga;
  final int jumlahPeserta;
  final String meetingPoint;
  final String namaPemesan;
  final String emailPemesan;
  final String noTeleponPemesan;
  final String voucherID;
  final String pictureTrip;
  final List<Map<String, String>> participants;

  const ReservationSummary({
    Key? key,
    required this.nameTrip,
    required this.jumlahHari,
    required this.totalHarga,
    required this.jumlahPeserta,
    required this.meetingPoint,
    required this.namaPemesan,
    required this.emailPemesan,
    required this.noTeleponPemesan,
    required this.voucherID,
    required this.pictureTrip,
    required this.participants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nameTrip,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image with Shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pictureTrip,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Section Title
            Text(
              "Detail Reservasi",
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Trip Info
            _buildDetailSection(
              context,
              title: "Informasi Trip",
              details: [
                {"Nama Trip": nameTrip},
                {"Jumlah Hari": "$jumlahHari hari"},
                {"Total Harga": "Rp$totalHarga"},
                {"Jumlah Peserta": "$jumlahPeserta orang"},
                {"Meeting Point": meetingPoint},
              ],
            ),
            const SizedBox(height: 20),
            // Pemesan Info
            _buildDetailSection(
              context,
              title: "Informasi Pemesan",
              details: [
                {"Nama Pemesan": namaPemesan},
                {"Email Pemesan": emailPemesan},
                {"No Telepon": noTeleponPemesan},
                {"Voucher ID": voucherID.isNotEmpty ? voucherID : "Tidak digunakan"},
              ],
            ),
            const SizedBox(height: 20),
            // Participants Section
            Text(
              "Daftar Peserta",
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < participants.length; i++) ...[
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Peserta ${i + 1}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Nama: ${participants[i]['nama_peserta']}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Email: ${participants[i]['email_peserta']}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            // Payment Button
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Payement()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[700],
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  child: const Text(
    "Bayar Sekarang",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required List<Map<String, String>> details,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
        ),
        const SizedBox(height: 10),
        ...details.map((detail) {
          String key = detail.keys.first;
          String value = detail.values.first;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
