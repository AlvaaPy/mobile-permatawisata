import 'package:flutter/material.dart';
import '../../../networks/api_trip.dart';
import '../../details/detail_trip.dart';

class PrivateTripPage extends StatefulWidget {
  const PrivateTripPage({super.key});

  @override
  State<PrivateTripPage> createState() => _PrivateTripPageState();
}

class _PrivateTripPageState extends State<PrivateTripPage> {
  late Future<List<Map<String, dynamic>>> _privateTripsFuture;

  @override
  void initState() {
    super.initState();
    _privateTripsFuture = ApiTrip.getTrips(); // Ambil data private trips
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _privateTripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: EmptyStateWidget());
          }

          final privateTrips = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: privateTrips.length,
              itemBuilder: (context, index) {
                final trip = privateTrips[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailTripPage(tripID: trip['tripID']),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          child: trip['picture'].isNotEmpty
                              ? Image.network(
                                  trip['picture'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/img/default_trip.png",
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip['namaTrip'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      trip['alamat'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on,
                                      size: 12, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Rp ${trip['price']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${trip['start_date']} - ${trip['end_date']}",
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk menambah atau memfilter private trip
        },
        child: const Icon(Icons.filter_list),
        tooltip: 'Filter Private Trip',
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Tidak ada private trip tersedia",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
