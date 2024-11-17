import 'package:flutter/material.dart';
import '../../../networks/api_users.dart';
import 'register_form.dart';


class RegisterOTP extends StatefulWidget {
  final String email;

  const RegisterOTP({super.key, required this.email});

  @override
  State<RegisterOTP> createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  // Method untuk input OTP
  Widget _buildOtpInput() {
    return TextField(
      controller: _otpController,
      decoration: InputDecoration(
        labelText: 'Kode OTP',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  // Method untuk tombol submit verifikasi OTP
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              String otp = _otpController.text;

              // Simulasikan loading state
              setState(() {
                _isLoading = true;
              });

              try {
                // Memanggil API verifyOtp dengan email dan OTP
                bool isOtpVerified = await ApiUsers.verifyOtp(otp, widget.email);
                if (isOtpVerified) {
                  // Setelah OTP berhasil diverifikasi, lanjutkan ke form pendaftaran
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterForm(email: widget.email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP tidak valid!')),
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
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Tombol lebar penuh
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Verifikasi OTP'),
    );
  }

  // Method untuk prompt kirim ulang OTP
  Widget _buildResendOtpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Belum menerima kode? '),
        TextButton(
          onPressed: () {
            // Fungsi kirim ulang OTP
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP telah dikirim ulang!')),
            );
            print('Resend OTP');
          },
          child: const Text('Kirim Ulang'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masukkan Kode OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Kami telah mengirimkan kode OTP ke email Anda.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildOtpInput(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
            const SizedBox(height: 20),
            _buildResendOtpText(),
          ],
        ),
      ),
    );
  }
}
