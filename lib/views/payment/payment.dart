import 'package:flutter/material.dart';

class Payement extends StatefulWidget {
  const Payement({super.key});

  @override
  State<Payement> createState() => _PayementState();
}

class _PayementState extends State<Payement> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: const Center(
        child: Text('This is the payment page. On Progress!!!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the payment gateway or payment processing page.
          // For simplicity, we'll just print the message here.
          debugPrint('Payment processing...');
        },
        child: const Icon(Icons.payment),
      ),
    );
  }
}