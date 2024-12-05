import 'package:flutter/material.dart';

import 'form.dart';
// import 'package:permatawisata/views/privatetrip/customTrip/form_custom.dart';

class DateOpenTrip extends StatefulWidget {
  final DateTime allowedStartDate;
  final DateTime allowedEndDate;
  final int tripID; // Tambahkan tripID

  const DateOpenTrip({
    Key? key,
    required this.allowedStartDate,
    required this.allowedEndDate,
    required this.tripID, // Tambahkan tripID
  }) : super(key: key);

  @override
  State<DateOpenTrip> createState() => _DateOpenTripState();
}

class _DateOpenTripState extends State<DateOpenTrip> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Tanggal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Tanggal Mulai",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: widget.allowedStartDate,
                  firstDate: widget.allowedStartDate,
                  lastDate: widget.allowedEndDate,
                );
                if (selected != null) {
                  setState(() {
                    startDate = selected;
                    endDate = null; // Reset tanggal selesai
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  startDate != null
                      ? startDate!.toLocal().toString().split(' ')[0]
                      : "Klik untuk memilih tanggal mulai",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pilih Tanggal Selesai",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: startDate == null
                  ? null
                  : () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: startDate!,
                        firstDate: startDate!,
                        lastDate: widget.allowedEndDate,
                      );
                      if (selected != null) {
                        setState(() {
                          endDate = selected;
                        });
                      }
                    },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: startDate == null ? Colors.grey[300] : null,
                ),
                child: Text(
                  endDate != null
                      ? endDate!.toLocal().toString().split(' ')[0]
                      : "Klik untuk memilih tanggal selesai",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap pilih tanggal mulai dan selesai."),
                      ),
                    );
                  } else {
                    // Lakukan navigasi ke CustomTripForm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationForm(
                          tripID: widget.tripID, // Kirim tripID
                          tglStart: startDate!,
                          tglEnd: endDate!,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Lanjut ke Form Custom Trip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
