import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networks/api_cities.dart';
import '../../../networks/api_custom.dart';
import '../../../networks/api_trip.dart';
import 'waitingpage.dart'; // Untuk API Trip

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
  final String picture;
  final String namaTrip;

  Trip({required this.tripID, required this.namaTrip, required this.picture});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripID: json['tripID'],
      namaTrip: json['namaTrip'],
      picture: json['picture'],
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
  bool _isLoadingCities = true; // Menandakan loading kota
  bool _isLoadingTrips = false; // Menandakan loading trips

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
        _isLoadingCities = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cities: $e')),
      );
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _loadTrips() async {
    setState(() {
      _isLoadingTrips = true;
    });

    try {
      final trips = await ApiTrip.getTrips();
      setState(() {
        _tripList = trips.map((trip) => Trip.fromJson(trip)).toList();
        _selectedTripID = _tripList.isNotEmpty ? _tripList[0].tripID : null;
        _isLoadingTrips = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading trips: $e')),
      );
      setState(() {
        _isLoadingTrips = false;
      });
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
          const SnackBar(
              content:
                  Text('Token tidak ditemukan. Harap login terlebih dahulu.')),
        );
        return;
      }

      try {
        final response = await ApiTripCustom.requestTrip(
          namaPemesan: namaPemesan,
          startDate: widget.startDate.toIso8601String(),
          endDate: widget.endDate.toIso8601String(),
          jumlahPeserta: jumlahPeserta,
          tripID:
              jenisProdukTrip == "Permata" ? _selectedTripID?.toString() : null,
          judul_trip: jenisProdukTrip == "Bebas" ? judulTripCustom : null,
          jenisCustom: jenisCustom,
          cityID: _selectedCityID!,
          alamatDetail: alamatDetail,
          catatan: catatan,
          token: token,
        );
        // Tampilkan snack bar dengan pesan respons
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        // Navigasi ke halaman tunggu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaitingPage()),
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
                // Bagian Informasi Pemesan
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nama Pemesan",
                      icon: Icon(Icons.person),
                    ),
                    onSaved: (value) => namaPemesan = value!,
                    validator: (value) =>
                        value!.isEmpty ? "Nama pemesan wajib diisi" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Jumlah Peserta",
                      icon: Icon(Icons.people),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => jumlahPeserta = int.parse(value!),
                    validator: (value) =>
                        value == null || int.tryParse(value) == null
                            ? "Jumlah peserta harus berupa angka"
                            : null,
                  ),
                ),

                // Bagian Jenis Trip
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<String>(
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
                    decoration:
                        const InputDecoration(labelText: "Jenis Produk Trip"),
                  ),
                ),

                // Menampilkan trip jika memilih "Permata"
                if (jenisProdukTrip == "Permata")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _isLoadingTrips
                        ? const CircularProgressIndicator()
                        : DropdownButtonFormField<int>(
                            value: _selectedTripID,
                            items: _tripList
                                .map((trip) => DropdownMenuItem(
                                      value: trip.tripID,
                                      child: Row(
                                        children: [
                                          // Menampilkan gambar trip
                                          Image.network(
                                            trip.picture,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                              width:
                                                  10), // Spasi antara gambar dan nama
                                          // Menampilkan nama trip
                                          Text(trip.namaTrip),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedTripID = value),
                            decoration: const InputDecoration(
                                labelText: "Pilih Produk Trip"),
                            validator: (value) => value == null
                                ? "Produk Trip Permata wajib dipilih"
                                : null,
                          ),
                  ),

                // Judul Trip Bebas jika memilih "Bebas"
                if (jenisProdukTrip == "Bebas")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Judul Trip Bebas",
                        icon: Icon(Icons.title),
                      ),
                      onSaved: (value) => judulTripCustom = value,
                      validator: (value) => value!.isEmpty
                          ? "Judul trip wajib diisi untuk Produk Bebas"
                          : null,
                    ),
                  ),

                // Bagian Jenis Custom Trip
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: jenisCustom,
                    items: jenisCustomList
                        .map((jenis) =>
                            DropdownMenuItem(value: jenis, child: Text(jenis)))
                        .toList(),
                    onChanged: (value) => setState(() => jenisCustom = value!),
                    decoration:
                        const InputDecoration(labelText: "Jenis Custom Trip"),
                  ),
                ),

                // Bagian Pilih Kota
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _isLoadingCities
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          value: _selectedCityID,
                          items: _cities
                              .map((city) => DropdownMenuItem(
                                    value: city.cityID,
                                    child: Text(city.cityName),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCityID = value),
                          decoration:
                              const InputDecoration(labelText: "Pilih Kota"),
                          validator: (value) =>
                              value == null ? "Kota wajib dipilih" : null,
                        ),
                ),

                // Bagian Alamat Detail
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Alamat Detail Penjemputan",
                      icon: Icon(Icons.location_on),
                    ),
                    onSaved: (value) => alamatDetail = value!,
                    validator: (value) =>
                        value!.isEmpty ? "Alamat detail wajib diisi" : null,
                  ),
                ),

                // Catatan Opsional
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Catatan (Opsional)",
                      icon: Icon(Icons.note),
                    ),
                    onSaved: (value) => catatan = value,
                    maxLines: 3,
                  ),
                ),

                // Tombol Submit
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Kirim"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
