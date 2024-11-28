import 'package:flutter/material.dart';
import 'package:permatawisata/views/auth/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../networks/api_users.dart';
import '../home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Method to build the email input field
  Widget _buildEmailInput() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Method to build the password input field
  Widget _buildPasswordInput() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
    );
  }

  // Method to build login button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;

        try {
          final userData = await ApiUsers.login(email, password);

          if (userData != true) {
            // Save user data to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('username', userData['username'] ?? 'Guest');
            prefs.setString('profile_picture', userData['profile_picture'] ?? '');
            

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  username: userData['username'] ?? 'Guest',
                  profilePicture: userData['profile_picture'] ?? '',
                ),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: const Text('Login'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 50),
        backgroundColor: const Color(0xFFD30000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Method to build registration text
  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Belum punya akun? '),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Register()));
          },
          child: const Text('Daftar Sekarang!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsiveness
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar di bagian atas
            Image.asset(
              "assets/img/loginassets.png",
              fit: BoxFit.cover,
              height: screenSize.height * 0.35,
              width: double.infinity,
            ),
            const SizedBox(height: 10),

            // Gambar logo di bawah gambar utama
            Image.asset(
              "assets/img/logo.png",
              height: screenSize.height * 0.15,
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Siap untuk liburan tak terlupakan? Masuk dan biarkan kami bantu mewujudkannya!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54, // Slightly faded color
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20), // Space after the text

            // Input fields for email and password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildEmailInput(),
                  const SizedBox(height: 10), // Space between fields
                  _buildPasswordInput(),
                ],
              ),
            ),

            const SizedBox(height: 20), // Space after inputs

            // Login Button
            _buildLoginButton(),

            const SizedBox(height: 20),

            // Registration text
            _buildRegisterText(),
          ],
        ),
      ),
    );
  }
}
