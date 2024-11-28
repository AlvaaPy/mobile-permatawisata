import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class SelectDatePage extends StatefulWidget {
  const SelectDatePage({Key? key}) : super(key: key);

  @override
  State<SelectDatePage> createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  DateTime? startDate;
  DateTime? endDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = args.value.startDate;
        endDate = args.value.endDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Tanggal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Rentang Tanggal",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: _onSelectionChanged,
              initialSelectedRange: PickerDateRange(
                startDate ?? DateTime.now(),
                endDate ?? DateTime.now().add(const Duration(days: 1)),
              ),
            ),
            const SizedBox(height: 30),
            if (startDate != null && endDate != null)
              Text(
                "Tanggal Terpilih: ${DateFormat('yyyy-MM-dd').format(startDate!)} - ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                style: const TextStyle(fontSize: 16.0),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap pilih rentang tanggal."),
                      ),
                    );
                  } else {
                    // Navigasi ke halaman berikutnya
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CustomTripForm(
                    //       startDate: startDate!,
                    //       endDate: endDate!,
                    //     ),
                    //   ),
                    // );
                  }
                },
                child: const Text("Lanjut ke Form Custom Trip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
