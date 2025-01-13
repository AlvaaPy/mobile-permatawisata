import 'package:flutter/material.dart';
import 'package:permatawisata/views/privatetrip/customTrip/form_custom.dart';

class SelectDatePage extends StatefulWidget {
  const SelectDatePage({Key? key}) : super(key: key);

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Tanggal"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tanggal Mulai
            const Text(
              "Pilih Tanggal Mulai",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  setState(() {
                    startDate = selected;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  startDate != null
                      ? startDate!.toLocal().toString().split(' ')[0]
                      : "Klik untuk memilih tanggal mulai",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tanggal Selesai
            const Text(
              "Pilih Tanggal Selesai",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  setState(() {
                    endDate = selected;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  endDate != null
                      ? endDate!.toLocal().toString().split(' ')[0]
                      : "Klik untuk memilih tanggal selesai",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Lanjut
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomTripForm(
                          startDate: startDate!,
                          endDate: endDate!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Colors.blueAccent, // Warna tombol
                ),
                child: const Text(
                  "Lanjut ke Form Custom Trip",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
