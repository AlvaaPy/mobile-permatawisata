import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Untuk memastikan semua item tetap di baris yang sama
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Open Trip',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lock_person),
          label: 'Private Trip',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.car_rental_outlined),
          label: 'Rental',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueAccent,  // Warna ikon yang dipilih
      unselectedItemColor: Colors.grey,     // Warna ikon yang tidak dipilih
      onTap: onItemTapped,  // Menangani aksi saat tab ditekan
      selectedIconTheme: const IconThemeData(
        size: 30,  // Ukuran ikon saat dipilih
      ),
      unselectedIconTheme: const IconThemeData(
        size: 24,  // Ukuran ikon saat tidak dipilih
      ),
      showUnselectedLabels: true, // Menampilkan label meskipun tidak dipilih
      backgroundColor: Colors.white, // Warna latar belakang navbar
      elevation: 8.0, // Memberikan efek shadow pada navbar
    );
  }
}
