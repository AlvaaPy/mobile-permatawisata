import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../networks/api_reservation.dart'; // Pastikan file API ini sesuai

class ReservationForm extends StatefulWidget {
  final int tripID; // Tambahkan tripID
  final DateTime tglStart;
  final DateTime tglEnd;

  const ReservationForm({
    Key? key,
    required this.tripID,
    required this.tglStart,
    required this.tglEnd,
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
  String? voucherID;
  int jumlahPeserta = 1;
  DateTime? tglReservation = DateTime.now();

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
        final response = await ApiReservation.reservation(
          tripID: widget.tripID,
          jumlah_peserta: jumlahPeserta,
          nama_pemesan: namaPemesan,
          email_pemesan: emailPemesan,
          no_telepon_pemesan: noTeleponPemesan,
          meeting_points: meetingPoints,
          tgl_reservation:
              DateFormat('yyyy-MM-dd').format(DateTime.now()), // Sekarang
          tgl_start: DateFormat('yyyy-MM-dd')
              .format(widget.tglStart), // Dari DateOpenTrip
          tgl_end: DateFormat('yyyy-MM-dd')
              .format(widget.tglEnd), // Dari DateOpenTrip
          voucherID: voucherID,
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
        title: const Text('Form Reservasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Pemesan'),
                  onSaved: (value) => namaPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Nama pemesan wajib diisi' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email Pemesan'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => emailPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Email wajib diisi' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'No Telepon Pemesan'),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => noTeleponPemesan = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'No telepon wajib diisi' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Meeting Points'),
                  onSaved: (value) => meetingPoints = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Meeting point wajib diisi' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Voucher ID (Opsional)'),
                  onSaved: (value) => voucherID = value,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Jumlah Peserta'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => jumlahPeserta = int.parse(value!),
                  validator: (value) =>
                      value!.isEmpty || int.tryParse(value) == null
                          ? 'Jumlah peserta harus berupa angka'
                          : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Kirim Reservasi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
