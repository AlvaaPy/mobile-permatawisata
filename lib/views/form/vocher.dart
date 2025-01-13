import 'package:flutter/material.dart';
import '../../networks/api_voucher.dart';

class VoucherSelectionPage extends StatelessWidget {
  const VoucherSelectionPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchVouchers() async {
    return await ApiVoucher.getVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Voucher'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchVouchers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada voucher tersedia.'));
          }

          final vouchers = snapshot.data!;
          return ListView.builder(
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    voucher['picture'], // URL gambar dari API
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                title: Text(voucher['voucher_code']),
                subtitle: Text(
                  voucher['fixed_discount'] != null
                      ? "Diskon Tetap: ${voucher['fixed_discount']}"
                      : "Diskon Persen: ${voucher['percentage_discount']}%",
                ),
                onTap: () {
                  Navigator.pop(context, voucher);
                },
              );
            },
          );
        },
      ),
    );
  }
}
