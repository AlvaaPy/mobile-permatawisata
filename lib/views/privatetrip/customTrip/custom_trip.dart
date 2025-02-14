import 'package:flutter/material.dart';
import 'package:permatawisata/views/privatetrip/customTrip/date_custom.dart';

class CustomTrip extends StatefulWidget {
  const CustomTrip({super.key});

  @override
  State<CustomTrip> createState() => _CustomTripState();
}

class _CustomTripState extends State<CustomTrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Aksi ketika tombol diklik
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectDatePage()));
            
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor, // Warna tombol mengikuti tema primaryColor
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Buat Custom Trip",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Warna teks putih untuk kontras
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
