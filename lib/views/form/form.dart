import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../networks/api_reservation.dart';
import 'reservation_summary.dart';
import 'vocher.dart';

class ReservationForm extends StatefulWidget {
  final int tripID;
  final DateTime tglStart;
  final DateTime tglEnd;
  final String namaTrip;
  final String pictureTrip;

  const ReservationForm({
    Key? key,
    required this.tripID,
    required this.tglStart,
    required this.tglEnd,
    required this.namaTrip,
    required this.pictureTrip,
  }) : super(key: key);

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  String namaPemesan = '';
  String emailPemesan = '';
  String noTeleponPemesan = '';
  String meetingPoints = '';
  Map<String, dynamic>? selectedVoucher;
  int jumlahPeserta = 1;
  List<Map<String, String>> participants = [
    {'nama_peserta': '', 'email_peserta': ''}
  ];

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Participants Data: $participants'); // Debug log
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
        final response = await ApiReservation.reservation(
          tripID: widget.tripID,
          jumlah_peserta: jumlahPeserta,
          nama_pemesan: namaPemesan,
          email_pemesan: emailPemesan,
          no_telepon_pemesan: noTeleponPemesan,
          meeting_points: meetingPoints,
          tgl_reservation: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          tgl_start: DateFormat('yyyy-MM-dd').format(widget.tglStart),
          tgl_end: DateFormat('yyyy-MM-dd').format(widget.tglEnd),
          voucherID: selectedVoucher?['voucherID'].toString(),
          token: token,
          participants: participants,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationSummary(
                pictureTrip: widget.pictureTrip,
                nameTrip: widget.namaTrip,
                jumlahHari: response['data']['jumlah_hari'] ?? 0,
                totalHarga: response['data']['total_harga'] ?? 0,
                jumlahPeserta: jumlahPeserta,
                meetingPoint: meetingPoints.isNotEmpty
                    ? meetingPoints
                    : 'Belum ditentukan',
                namaPemesan:
                    namaPemesan.isNotEmpty ? namaPemesan : 'Tidak diketahui',
                emailPemesan:
                    emailPemesan.isNotEmpty ? emailPemesan : 'Tidak diketahui',
                noTeleponPemesan: noTeleponPemesan.isNotEmpty
                    ? noTeleponPemesan
                    : 'Tidak diketahui',
                voucherID:
                    selectedVoucher?['voucher_code'] ?? 'Tidak digunakan',
                participants: participants,
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      }
    }
  }

  void _updateParticipants(int count) {
    setState(() {
    if (count > participants.length) {
      participants.add({'nama_peserta': '', 'email_peserta': ''});
    } else if (count < participants.length) {
      participants.removeLast();
    }
    jumlahPeserta = participants.length;
  });
  }

  Widget _buildParticipantFields(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: participants[index]['nama_peserta'],
              decoration: _inputDecoration('Nama Peserta ${index + 1}'),
              onSaved: (value) => participants[index]['nama_peserta'] = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Nama peserta wajib diisi' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: participants[index]['email_peserta'],
              decoration: _inputDecoration('Email Peserta ${index + 1}'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => participants[index]['email_peserta'] = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Email peserta wajib diisi' : null,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaTrip),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.pictureTrip,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Nama Pemesan',
                  onSaved: (value) => namaPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Nama pemesan wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email Pemesan',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => emailPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Email wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'No Telepon Pemesan',
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => noTeleponPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'No telepon wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Meeting Points',
                  onSaved: (value) => meetingPoints = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Meeting point wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: Colors.grey.shade200,
                  title: Text(
                    selectedVoucher != null
                        ? ' ${selectedVoucher!['voucher_code']}'
                        : 'Pilih Voucher',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () async {
                    final voucher = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VoucherSelectionPage()),
                    );
                    if (voucher != null) {
                      setState(() {
                        selectedVoucher = voucher;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Atur posisi kiri dan kanan
                  children: [
                    // Teks di sebelah kiri
                    const Text(
                      'Jumlah Peserta',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Spacer untuk memberikan jarak dinamis
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (jumlahPeserta > 1) {
                              _updateParticipants(jumlahPeserta - 1);
                            }
                          },
                          icon: const Icon(Icons.remove,
                              color: Colors.blueAccent),
                        ),
                        Text(
                          '$jumlahPeserta',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            _updateParticipants(jumlahPeserta + 1);
                          },
                          icon: const Icon(Icons.add, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < participants.length; i++) ...[
                  _buildParticipantFields(i),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Kirim Reservasi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      onSaved: onSaved,
      validator: validator,
    );
  }

  
}
