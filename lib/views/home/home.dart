import 'package:flutter/material.dart';
import 'package:permatawisata/views/profile/profile.dart';
import 'package:permatawisata/views/rental/rental.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../privatetrip/private.dart';
import '../trip/opentrip.dart';
import 'components/homebar.dart';
import 'homepage.dart';

class Home extends StatefulWidget {
  final String username; // Parameter untuk menerima username
  final String profilePicture; // Parameter untuk menerima profilePicture

  const Home({
    super.key,
    required this.username,
    required this.profilePicture,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  String? username;
  String? profilePicture;

  // Inisialisasi data yang diteruskan dari Login melalui konstruktor
  @override
  void initState() {
    super.initState();
    username = widget.username;
    profilePicture = widget.profilePicture;
  }

  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token yang disimpan: $token');
  }

  final List<Widget> _pages = [
    const HomeContent(),
    const OpentripPage(),
    const PrivateTrip(),
    const RentalPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index < _pages.length ? index : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Halo, ${username ?? 'User'}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
            ),
            profilePicture != null && profilePicture!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture!),
                    radius: 20,
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage("assets/img/logo.png"),
                    radius: 20,
                  ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
