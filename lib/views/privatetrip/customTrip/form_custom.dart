import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networks/api_cities.dart';
import '../../../networks/api_custom.dart';
import '../../../networks/api_trip.dart'; // Untuk API Trip

// Model City untuk parsing data respons API
class City {
  final int cityID;
  final String cityName;

  City({required this.cityID, required this.cityName});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityID: json['cityID'],
      cityName: json['city_name'],
    );
  }
}

// Model Trip untuk parsing data respons API
class Trip {
  final int tripID;
  final String namaTrip;

  Trip({required this.tripID, required this.namaTrip});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripID: json['tripID'],
      namaTrip: json['namaTrip'],
    );
  }
}

class CustomTripForm extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const CustomTripForm({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<CustomTripForm> createState() => _CustomTripFormState();
}

class _CustomTripFormState extends State<CustomTripForm> {
  final _formKey = GlobalKey<FormState>();

  String namaPemesan = "";
  int jumlahPeserta = 1;
  String jenisCustom = "Individu";
  String alamatDetail = "";
  String? catatan;
  int? _selectedCityID;

  final List<String> jenisCustomList = [
    "Individu",
    "Perusahaan",
    "Sekolah",
    "Universitas"
  ];

  String jenisProdukTrip = "Permata"; // Default jenis trip
  List<City> _cities = []; // Data kota dari API
  List<Trip> _tripList = []; // Data trip dari API
  int? _selectedTripID; // Pilihan trip ID untuk produk Permata
  String? judulTripCustom; // Judul trip untuk produk Bebas

  @override
  void initState() {
    super.initState();
    _loadCities(); // Fetch cities saat inisialisasi
  }

  Future<void> _loadCities() async {
    try {
      final cities = await ApiCities.getCities();
      setState(() {
        _cities = cities.map((city) => City.fromJson(city)).toList();
        _selectedCityID = _cities.isNotEmpty ? _cities[0].cityID : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cities: $e')),
      );
    }
  }

  Future<void> _loadTrips() async {
    try {
      final trips = await ApiTrip.getTrips();
      setState(() {
        _tripList = trips.map((trip) => Trip.fromJson(trip)).toList();
        _selectedTripID = _tripList.isNotEmpty ? _tripList[0].tripID : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading trips: $e')),
      );
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final token = await _getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token tidak ditemukan. Harap login terlebih dahulu.')),
        );
        return;
      }

      try {
        final response = await ApiTripCustom.requestTrip(
          namaPemesan: namaPemesan,
          startDate: widget.startDate.toIso8601String(),
          endDate: widget.endDate.toIso8601String(),
          jumlahPeserta: jumlahPeserta,
          tripID: jenisProdukTrip == "Permata" ? _selectedTripID?.toString() : null,
          judul_trip: jenisProdukTrip == "Bebas" ? judulTripCustom : null,
          jenisCustom: jenisCustom,
          cityID: _selectedCityID!,
          alamatDetail: alamatDetail,
          catatan: catatan,
          token: token,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Custom Trip"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nama Pemesan"),
                  onSaved: (value) => namaPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? "Nama pemesan wajib diisi" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Jumlah Peserta"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => jumlahPeserta = int.parse(value!),
                  validator: (value) =>
                      value == null || int.tryParse(value) == null
                          ? "Jumlah peserta harus berupa angka"
                          : null,
                ),
                DropdownButtonFormField<String>(
                  value: jenisProdukTrip,
                  items: ["Permata", "Bebas"]
                      .map((jenis) =>
                          DropdownMenuItem(value: jenis, child: Text(jenis)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      jenisProdukTrip = value!;
                      if (jenisProdukTrip == "Permata") {
                        _loadTrips();
                      } else {
                        _selectedTripID = null;
                      }
                    });
                  },
                  decoration: const InputDecoration(labelText: "Jenis Produk Trip"),
                ),
                if (jenisProdukTrip == "Permata")
                  DropdownButtonFormField<int>(
                    value: _selectedTripID,
                    items: _tripList
                        .map((trip) => DropdownMenuItem(
                              value: trip.tripID,
                              child: Text(trip.namaTrip),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedTripID = value),
                    decoration: const InputDecoration(labelText: "Pilih Produk Trip"),
                    validator: (value) =>
                        value == null ? "Produk Trip Permata wajib dipilih" : null,
                  ),
                if (jenisProdukTrip == "Bebas")
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Judul Trip Bebas"),
                    onSaved: (value) => judulTripCustom = value,
                    validator: (value) =>
                        value!.isEmpty ? "Judul trip wajib diisi untuk Produk Bebas" : null,
                  ),
                DropdownButtonFormField<String>(
                  value: jenisCustom,
                  items: jenisCustomList
                      .map((jenis) =>
                          DropdownMenuItem(value: jenis, child: Text(jenis)))
                      .toList(),
                  onChanged: (value) => setState(() => jenisCustom = value!),
                  decoration: const InputDecoration(labelText: "Jenis Custom Trip"),
                ),
                DropdownButtonFormField<int>(
                  value: _selectedCityID,
                  items: _cities
                      .map((city) => DropdownMenuItem(
                            value: city.cityID,
                            child: Text(city.cityName),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCityID = value),
                  decoration: const InputDecoration(labelText: "Pilih Kota"),
                  validator: (value) =>
                      value == null ? "Kota wajib dipilih" : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Alamat Detail"),
                  onSaved: (value) => alamatDetail = value!,
                  validator: (value) =>
                      value!.isEmpty ? "Alamat detail wajib diisi" : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Catatan (Opsional)"),
                  onSaved: (value) => catatan = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Kirim Custom Trip"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
