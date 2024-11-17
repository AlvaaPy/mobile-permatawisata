import 'package:flutter/material.dart';
import '../../networks/api_users.dart';
import '../auth/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await ApiUsers.getProfile();
      setState(() {
        profile = data;
      });
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await ApiUsers.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Langsung ke LoginPage
        (route) => false, // Menghapus semua halaman sebelumnya
      );
    } catch (e) {
      print('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout. Silakan coba lagi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto Profil
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profile!['profile_picture']),
                  ),
                  const SizedBox(height: 20),
                  // Username
                  Text(
                    profile!['username'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Text(
                    profile!['email'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Detail Profil
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileDetailRow(
                          icon: Icons.person,
                          title: "Nama Lengkap",
                          value: profile!['fullname'],
                        ),
                        const Divider(),
                        ProfileDetailRow(
                          icon: Icons.phone,
                          title: "No Telepon",
                          value: profile!['noTlpn'],
                        ),
                        const Divider(),
                        ProfileDetailRow(
                          icon: Icons.cake,
                          title: "Tanggal Lahir",
                          value: profile!['birthDate'],
                        ),
                        const Divider(),
                        ProfileDetailRow(
                          icon: Icons.male,
                          title: "Gender",
                          value: profile!['gender'],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  // Tombol Edit Profil dan Logout
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            print('Navigasi ke halaman edit profil');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.edit, size: 20),
                          label: const Text(
                            "Edit Profil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.logout, size: 20),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
