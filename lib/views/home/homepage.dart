import 'package:flutter/material.dart';
import 'package:permatawisata/views/home/components/banner.dart';
// import '../components/banner.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Widget untuk mempermudah pembuatan Row
  Widget buildSection({required Widget child, required double height}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Row 1: Search
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Cari sesuatu',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            // Row 2: Banner Ads
            buildSection(
              child: const BannerSlide(),
              height: 130.0,
            ),
            // Row 3: Voucher (Placeholder)
            // buildSection(
            //   child: const Placeholder(color: Colors.green),
            //   height: 100.0,
            // ),
            // // Row 4: Keberangkatan Minggu Ini (Placeholder)
            // buildSection(
            //   child: const Placeholder(color: Colors.orange),
            //   height: 100.0,
            // ),
            // // Row 5: Berdasarkan Meeting Point (Placeholder)
            // buildSection(
            //   child: const Placeholder(color: Colors.red),
            //   height: 100.0,
            // ),
            // // Row 6: New Open Trip (Placeholder)
            // buildSection(
            //   child: const Placeholder(color: Colors.purple),
            //   height: 100.0,
            // ),
            // // Row 7: Paket Wisata Favorit (Placeholder)
            // buildSection(
            //   child: const Placeholder(color: Colors.yellow),
            //   height: 100.0,
            // ),
          ],
        ),
      ),
    );
  }
}
