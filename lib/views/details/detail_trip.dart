import 'package:flutter/material.dart';
import '../../networks/api_trip.dart';
import 'description.dart';
import 'itenary_trip.dart';
import 'meeting_points.dart';

class DetailTripPage extends StatefulWidget {
  final int tripID;

  const DetailTripPage({Key? key, required this.tripID}) : super(key: key);

  @override
  State<DetailTripPage> createState() => _DetailTripPageState();
}

class _DetailTripPageState extends State<DetailTripPage>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _tripDetailFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tripDetailFuture = ApiTrip.detailTrips(widget.tripID);
    _tabController = TabController(
        length: 3, vsync: this); // Menambahkan TabController untuk 3 tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tripDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan."));
          }

          final trip = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar utama trip
                Image.network(
                  trip['picture'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/img/default_trip.png",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Gambar aset trip di bawah gambar utama
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: trip['package_trip_asset']
                        .map<Widget>((asset) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    asset['picture'],
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/img/landingpage1.png",
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Nama Trip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    trip['namaTrip'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Alamat/kota
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip['alamat'],
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        trip['rating'] != null
                            ? trip['rating'].toString()
                            : "Belum ada rating",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Deskripsi trip
                const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Deskripsi",
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _shortenText(trip['deskripsi']),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 16),

                // Bagian Tab Menu dan TabBarView
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Description'),
                      Tab(text: 'Itinerary'),
                      Tab(text: 'Meeting Point'),
                    ],
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                ),

                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Deskripsi
                      DescriptionTab(
                          description:
                              trip['deskripsi'] ?? "Deskripsi tidak tersedia"),

                      // Tab Itinerary
                      trip['itenary_trip'] != null &&
                              trip['itenary_trip'] is List
                          ? ItineraryTab(
                              itinerary: List<Map<String, dynamic>>.from(
                                  trip['itenary_trip']))
                          : const Center(
                              child: Text("Itinerary tidak tersedia")),

                      // Tab Meeting Point
                      MeetingPointTab(
                          meetingPoint: trip['meeting_point'] ??
                              "Meeting point belum ditentukan"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan aksi untuk tombol jika perlu
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pemesanan Trip")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text("Pesan Sekarang"),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  String _shortenText(String text) {
    List<String> words = text.split(' '); // Memisahkan teks menjadi kata-kata
    if (words.length <= 15) {
      return text; // Jika kurang dari 15 kata, tampilkan teks asli
    }
    return words.sublist(0, 15).join(' ') +
        '...'; // Gabungkan 15 kata pertama dengan "..."
  }
}
