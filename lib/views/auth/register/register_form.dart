import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../networks/api_users.dart';
// import '../../home/home.dart';
import '../login.dart';

class RegisterForm extends StatefulWidget {
  final String email;

  const RegisterForm({super.key, required this.email});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _gender;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  // Method to build input field
  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    void Function()? onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: inputType,
      onTap: onTap,
    );
  }

  // Method to pick profile image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    setState(() {
      _image = pickedFile;
    });
  }

  // Method to build profile image selector
  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
        child: _image == null
            ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
            : null,
      ),
    );
  }

  // Method to build gender selection row
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jenis Kelamin'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const Text('Laki-laki'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const Text('Perempuan'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Method to build submit button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              String fullName = _fullNameController.text;
              String dob = _dobController.text;
              String gender = _gender ?? 'Belum dipilih';
              String whatsapp = _whatsappController.text;
              String username = _usernameController.text;

              if (fullName.isEmpty ||
                  dob.isEmpty ||
                  gender.isEmpty ||
                  whatsapp.isEmpty ||
                  username.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),

                );
                return;
              }

              setState(() {
                _isLoading = true;
              });

              try {
                // Mengirimkan data diri dan foto profil ke API
                bool isDataSent = await ApiUsers.formData(
                  email: widget.email,
                  fullname: fullName,
                  username: username,
                  noTlpn: whatsapp,
                  birthDate: dob, // Menggunakan format 'YYYY-MM-DD'
                  gender: gender,
                  profile_picture: _image != null
                      ? _image!.path
                      : '', // Mengirim foto profil jika ada
                );
                if (isDataSent) {
                  // Menampilkan notifikasi registrasi berhasil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registrasi berhasil!')),
                  );

                  // Setelah data berhasil disubmit, lanjutkan ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login()
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Setuju dan Lanjutkan'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Full width button
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambahkan Informasimu!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Display profile picture
              _buildProfilePicture(),
              const SizedBox(height: 20),

              // Full name input
              _buildTextInput(
                label: 'Nama Lengkap',
                controller: _fullNameController,
              ),
              const SizedBox(height: 16),

              // Username input
              _buildTextInput(
                label: 'Username',
                controller: _usernameController,
              ),
              const SizedBox(height: 16),

              // Date of birth input with date picker
              _buildTextInput(
                label: 'Tanggal Lahir',
                controller: _dobController,
                inputType: TextInputType.datetime,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    // Format date to 'YYYY-MM-DD'
                    _dobController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Gender selection
              _buildGenderSelection(),
              const SizedBox(height: 16),

              // WhatsApp number input
              _buildTextInput(
                label: 'Nomor WhatsApp',
                controller: _whatsappController,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              const Text(
                'Dengan memilih Setuju dan Lanjutkan, saya menyetujui Syarat dan Ketentuan dan Kebijakan Privasi dari Permata Wisata.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Submit button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
