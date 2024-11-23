import 'package:flutter/material.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("On Progresssss !!!!!")
          ],
        ),
      )
    );
  }
}